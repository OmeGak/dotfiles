require("hs.ipc")  -- enables the `hs` CLI for debugging

-- Duck output volume while the microphone is in use.
local DUCK = 40
local saved = nil     -- volume to restore
local savedUID = nil  -- UID of the output device that was ducked

local function check()
  local mic = hs.audiodevice.defaultInputDevice()
  local out = hs.audiodevice.defaultOutputDevice()
  if not mic or not out then return end
  if mic:inUse() and not saved then
    saved = out:outputVolume()
    savedUID = out:uid()
    out:setOutputVolume(math.min(DUCK, saved))  -- never make it louder
  elseif not mic:inUse() and saved then
    local dev = hs.audiodevice.findDeviceByUID(savedUID)
    if dev then dev:setOutputVolume(saved) end  -- skip if the device is gone
    saved, savedUID = nil, nil
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
  if event == "dIn " or event == "dOut" then  -- note trailing space in "dIn "
    bindMic()
    check()
  end
end)
hs.audiodevice.watcher.start()

-- Safety net in case events are missed.
micTimer = hs.timer.doEvery(5, check)

bindMic()
check()
