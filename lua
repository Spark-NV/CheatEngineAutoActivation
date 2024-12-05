  <LuaScript>
local proc = "EXENAME.exe"
local steamURL = "steam://rungameid/ID"
local addressList = getAddressList()

function Launch()
  if not getProcessIDFromProcessName(proc) then
    shellExecute(steamURL) -- Launches the game through Steam
    sleep(8000) -- Wait up to 8 seconds to allow the process to start
  end

  local ticks = 0
  local maxTicks = 20000
  local tick = 100
  while process ~= proc and ticks &lt; maxTicks do
    openProcess(proc)
    sleep(tick)
    ticks = ticks + tick
  end

  local activationSuccessCount = 0
  local totalRecords = addressList.Count

  for i = 0, totalRecords - 1 do
    local memRecord = addressList[i]
    
    local activationSuccess, activationErr = pcall(function()
      memRecord.Active = true
    end)

    local isEffectivelyActivated = false
    if activationSuccess then
      local verificationSuccess, verificationErr = pcall(function()
        isEffectivelyActivated = memRecord.Active
      end)

      if not verificationSuccess or not isEffectivelyActivated then
        os.execute("taskkill /F /IM FFX.exe")
        messageDialog("Cheat activation failed. Process will be terminated.", mtError, mbOK)
      os.execute("taskkill /f /im cheatengine*")
        return false
      end

      activationSuccessCount = activationSuccessCount + 1
    end
  end

  print("Activation complete. Successfully activated " .. activationSuccessCount .. " out of " .. totalRecords .. " records")
  return true
end

Launch()

</LuaScript>
