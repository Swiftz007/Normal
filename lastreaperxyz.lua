Local HttpService = game:GetService("HttpService")

local scriptId = "DVORJUQM"
local success, response = pcall(function()
    return game:HttpGet("https://reaper-58298-default-rtdb.asia-southeast1.firebasedatabase.app/src/" .. scriptId .. ".json")
end)

if success and response then
    local successDecode, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if successDecode and data and data.Code then
        loadstring(data.Code)()
    else
        warn("SCRIPT NOT FOUND OR REMOVED!")
    end
else
    warn("FAILED TO CONNECT TO REAPER SERVER!")
end
