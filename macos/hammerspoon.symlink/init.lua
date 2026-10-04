require("hs.ipc")  -- enables the `hs` CLI for debugging

-- Keep the mic the user chose. macOS makes a device the default input when
-- it connects (a Bluetooth headset, which then records in call mode:
-- low-quality, quieter audio with its own volume); undo that, but keep a mic
-- the user picks by hand. The audio events don't say which mic was replaced,
-- so remember it, and when each mic appeared.
local ARRIVAL_GRACE = 5  -- seconds after connecting that a switch counts as macOS's
local knownMics = {}     -- UID -> time the mic appeared
local chosenMic = nil    -- UID of the default input the user wants

local function noteArrivals()
  local now = hs.timer.secondsSinceEpoch()
  local present = {}
  for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
    present[dev:uid()] = knownMics[dev:uid()] or now
  end
  knownMics = present
end

local function keepChosenMic()
  noteArrivals()
  local mic = hs.audiodevice.defaultInputDevice()
  if not mic then return end
  local justArrived = hs.timer.secondsSinceEpoch() - knownMics[mic:uid()] < ARRIVAL_GRACE
  local previous = chosenMic and hs.audiodevice.findDeviceByUID(chosenMic)
  if justArrived and previous and chosenMic ~= mic:uid() then
    previous:setDefaultInputDevice()
  else
    chosenMic = mic:uid()
  end
end

-- Duck output volume while the microphone is in use.
local DUCK = 40
local saved = nil     -- volume to restore
local savedUID = nil  -- UID of the output device that was ducked

local function check()
  local mic = hs.audiodevice.defaultInputDevice()
  local out = hs.audiodevice.defaultOutputDevice()
  if not mic or not out then return end
  if mic:inUse() and not saved then
    -- nil when the device has no software volume, or mid-switch (Bluetooth
    -- headsets change profile when their mic starts); the timer retries.
    local vol = out:outputVolume()
    if not vol then return end
    saved = vol
    savedUID = out:uid()
    out:setOutputVolume(math.min(DUCK, saved))  -- never make it louder
  elseif not mic:inUse() and saved then
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

-- (Re)bind the per-device watcher to the current default input.
-- Global so the watcher isn't garbage-collected.
function bindMic()
  if micWatcherDevice then micWatcherDevice:watcherStop() end
  micWatcherDevice = hs.audiodevice.defaultInputDevice()
  if not micWatcherDevice then return end
  micWatcherDevice:watcherCallback(function(_, event)
    if event == "gone" then check() end  -- "gone" = mic started/stopped being used
  end)
  micWatcherDevice:watcherStart()
end

-- System-level watcher: default device changed (AirPods/USB mic connect etc.).
hs.audiodevice.watcher.setCallback(function(event)
  if event == "dev#" then noteArrivals() end  -- devices added or removed
  if event == "dIn " or event == "dOut" then  -- note trailing space in "dIn "
    keepChosenMic()
    bindMic()
    check()
  end
end)
hs.audiodevice.watcher.start()

-- Safety net in case events are missed.
micTimer = hs.timer.doEvery(5, check)

noteArrivals()
for uid in pairs(knownMics) do knownMics[uid] = 0 end
keepChosenMic()
bindMic()
check()
