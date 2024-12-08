  <LuaScript>
local proc = "FFX.exe"
local steamURL = "steam://rungameid/359870"
local max_wait_time = 5000

-- DO NOT MODIFY BELOW THIS LINE --
local addressList = getAddressList()

function Kill_CE()
  os.execute("taskkill /F /IM cheatengine*")
  end
  
function Kill_PROC()
  os.execute("taskkill /F /IM " .. proc)
  end

function Launch()
  if not getProcessIDFromProcessName(proc) then
    shellExecute(steamURL)
    sleep(max_wait_time)
  end

  local ticks = 0
  local maxTicks = max_wait_time
  local tick = 100
  while process ~= proc and ticks &lt; maxTicks do
    openProcess(proc)
    sleep(tick)
    ticks = ticks + tick
  end

  local totalRecords = addressList.Count
  local activatedCount = 0

  for i = 0, totalRecords - 1 do
    local memRecord = addressList[i]

    local activationSuccess, activationErr = pcall(function()
      memRecord.Active = true
    end)

    if activationSuccess then
      sleep(500)

      if not memRecord.Active then
        Kill_PROC()
        messageDialog("Cheat activation failed on cheat #" .. i .. ". Process will be terminated.", mtError, mbOK)
        Kill_CE()
        return false
      else
        activatedCount = activatedCount + 1
      end
    else
      Kill_PROC()
      messageDialog("Error during activation of cheat #" .. i .. ": " .. (activationErr or "unknown error") .. ". Process will be terminated.", mtError, mbOK)
      Kill_CE()
      return false
    end
  end

  while getProcessIDFromProcessName(proc) do
    sleep(750)
  end

  Kill_CE()
  return true
end

Launch()

</LuaScript>
