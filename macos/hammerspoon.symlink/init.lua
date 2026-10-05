require("hs.ipc")  -- enables the `hs` CLI for debugging

-- Why the mic or volume changed: `hs -c 'return hs.console.getConsole()'`.
local log = hs.logger.new("audio", "info")

-- Keep the mic the user chose. macOS switches the default input on its own
-- when the mics change: to a headset that connects (a Bluetooth headset then
-- records in call mode: low-quality, quieter audio with its own volume), or
-- to any mic when the chosen one goes away (undocking, waking). Undo that,
-- but keep a mic the user picks by hand. The audio events don't say who
-- switched, so tell by timing: macOS switches right as the mics change, or
-- as it reroutes the system output (a multipoint headset moving to or from
-- a phone call stays connected, but takes the output along).
local CHANGE_GRACE = 5   -- seconds after the mics change that a switch counts as macOS's
local REROUTE_GRACE = 2  -- seconds after a system output change, likewise
local BUILTIN_MIC = "BuiltInMicrophoneDevice"  -- UID of the MacBook's mic
local mics = {}          -- UIDs of the mics present
local lastChange = 0     -- time a mic last arrived or left
local lastReroute = 0    -- time the system output last changed
local chosenMic = nil    -- UID of the default input the user wants

local function noteMics()
  local present, changed = {}, false
  for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
    present[dev:uid()] = true
    if not mics[dev:uid()] then changed = true end
  end
  for uid in pairs(mics) do
    if not present[uid] then changed = true end
  end
  mics = present
  if changed then lastChange = hs.timer.secondsSinceEpoch() end
end

local function isBluetooth(dev) return dev:transportType() == "Bluetooth" end

local function keepChosenMic()
  noteMics()
  local mic = hs.audiodevice.defaultInputDevice()
  if not mic or mic:uid() == chosenMic then return end
  local now = hs.timer.secondsSinceEpoch()
  local byMacOS = now - lastChange < CHANGE_GRACE or now - lastReroute < REROUTE_GRACE
  if not byMacOS then
    log.i("hand-picked mic: " .. mic:name())
    chosenMic = mic:uid()
    return
  end
  -- While the chosen mic is away, a Bluetooth one is never what's wanted;
  -- any other stands in until the chosen one returns.
  local target = hs.audiodevice.findDeviceByUID(chosenMic)
  if not target and isBluetooth(mic) then target = hs.audiodevice.findDeviceByUID(BUILTIN_MIC) end
  if target then
    log.i("macOS picked " .. mic:name() .. ", back to " .. target:name())
    if not target:setDefaultInputDevice() then log.w("couldn't switch to " .. target:name()) end
  else
    log.i("macOS picked " .. mic:name() .. " while the chosen mic is away")
  end
end

-- Duck output volume while a mic is in use. Any mic, not just the default:
-- call apps record from the one picked in their own settings.
local DUCK = 40
local saved = nil     -- volume to restore
local savedUID = nil  -- UID of the output device that was ducked

-- Only devices that are just mics: a combined input/output device is in use
-- whenever it plays, and virtual or aggregate inputs (a call app's loopback)
-- aren't anyone talking.
local function isMic(dev)
  local t = dev:transportType()
  return not dev:isOutputDevice() and t ~= "Virtual" and t ~= "Aggregate"
end

local function micInUse()
  for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
    if isMic(dev) and dev:inUse() then return true end
  end
  return false
end

local function check()
  local out = hs.audiodevice.defaultOutputDevice()
  if not out then return end
  local inUse = micInUse()
  if inUse and not saved then
    -- nil when the device has no software volume, or mid-switch (Bluetooth
    -- headsets change profile when their mic starts); the timer retries.
    local vol = out:outputVolume()
    if not vol then return end
    saved = vol
    savedUID = out:uid()
    out:setOutputVolume(math.min(DUCK, saved))  -- never make it louder
    log.i(string.format("ducked %s from %.0f", out:name(), saved))
  elseif not inUse and saved then
    local dev = hs.audiodevice.findDeviceByUID(savedUID)
    if dev then
      dev:setOutputVolume(saved)
      -- A Bluetooth headset leaving call mode can drop the change; keep
      -- `saved` so the timer retries until it sticks.
      local vol = dev:outputVolume()
      if not vol or math.abs(vol - saved) > 1 then return end
    end
    saved, savedUID = nil, nil  -- restored, or the device is gone
  end
end

-- (Re)bind a watcher to every mic, to hear when one starts or stops being
-- used. Global so the watchers aren't garbage-collected.
micWatchers = {}
function bindMics()
  for _, dev in ipairs(micWatchers) do dev:watcherStop() end
  micWatchers = {}
  for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
    if isMic(dev) then
      dev:watcherCallback(function(_, event)
        if event == "gone" then check() end  -- "gone" = mic started/stopped being used
      end)
      dev:watcherStart()
      table.insert(micWatchers, dev)
    end
  end
end

-- System-level watcher: devices added or removed, or the defaults changed.
-- The input and system output changes of a reroute arrive in either order,
-- so act once they've settled.
local settle = hs.timer.delayed.new(0.5, function()
  keepChosenMic()
  bindMics()
  check()
end)
hs.audiodevice.watcher.setCallback(function(event)
  if event == "dev#" then noteMics() end
  if event == "sOut" then lastReroute = hs.timer.secondsSinceEpoch() end
  if event == "dev#" or event == "dIn " or event == "dOut" or event == "sOut" then  -- note trailing space in "dIn "
    settle:start()
  end
end)
hs.audiodevice.watcher.start()

-- Safety net in case events are missed.
micTimer = hs.timer.doEvery(5, check)

-- At startup there's no telling who picked the current mic; keep it unless
-- it's a Bluetooth one.
noteMics()
lastChange = 0
local mic = hs.audiodevice.defaultInputDevice()
if mic and isBluetooth(mic) then
  local builtin = hs.audiodevice.findDeviceByUID(BUILTIN_MIC)
  if builtin then builtin:setDefaultInputDevice(); mic = builtin end
end
chosenMic = mic and mic:uid()
bindMics()
check()
