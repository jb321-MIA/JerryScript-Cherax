--[[
    JerryScript Loader - Cherax Edition
    GitHub: https://github.com/jb321-MIA/JerryScript-Cherax
]]

local SCRIPT_NAME = "JerryScript"
local SCRIPT_VERSION = "1.0.0"

local GITHUB_USERNAME = "jb321-MIA"
local GITHUB_REPO = "JerryScript-Cherax"
local GITHUB_BRANCH = "main"
local GITHUB_RAW = "https://raw.githubusercontent.com/" .. GITHUB_USERNAME .. "/" .. GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/"

local function log(msg)
    print("[" .. SCRIPT_NAME .. "] " .. tostring(msg))
end

local function toast(title, msg, duration)
    GUI.AddToast(title, msg, duration or 3000, eToastPos.TopRight)
end

local ActiveCurls = {}

local function fetchURLSync(url, timeout)
    timeout = timeout or 5000
    log("Fetching: " .. url)
    local curl = Curl.Easy()
    table.insert(ActiveCurls, curl)
    curl:Setopt(eCurlOption.CURLOPT_URL, url)
    curl:Setopt(eCurlOption.CURLOPT_USERAGENT, "JerryScript-Loader/1.0")
    curl:Perform()
    local waited = 0
    while not curl:GetFinished() and waited < timeout do
        Script.Yield(10)
        waited = waited + 10
    end
    if curl:GetFinished() then
        local code, response = curl:GetResponse()
        if code == eCurlCode.CURLE_OK and response and #response > 0 then
            log("  OK: " .. #response .. " bytes")
            return response
        else
            log("  FAIL: " .. tostring(code))
        end
    else
        log("  TIMEOUT")
    end
    return nil
end

local LoadedModules = {}
local JS = {}

local function loadCode(code, moduleName)
    if not code then return nil end
    local fn, err = load(code, moduleName)
    if fn then
        local success, result = pcall(fn)
        if success then return result
        else log("Error executing " .. moduleName .. ": " .. tostring(result)) end
    else log("Error parsing " .. moduleName .. ": " .. tostring(err)) end
    return nil
end

function JS.LoadLib(name)
    if LoadedModules["libs/" .. name] then return LoadedModules["libs/" .. name] end
    local url = GITHUB_RAW .. "libs/" .. name .. ".lua"
    local code = fetchURLSync(url)
    if code then
        local module = loadCode(code, "libs/" .. name)
        if module then
            LoadedModules["libs/" .. name] = module
            return module
        end
    end
    return nil
end

log("═══════════════════════════════════════════════════════════════")
log(" " .. SCRIPT_NAME .. " Loader v" .. SCRIPT_VERSION)
log(" GitHub: " .. GITHUB_USERNAME .. "/" .. GITHUB_REPO)
log("═══════════════════════════════════════════════════════════════")

toast(SCRIPT_NAME, "Loading from GitHub...", 2000)

Script.QueueJob(function()
    Script.Yield(100)
    JS.Entity = JS.LoadLib("entity")
    Script.Yield(50)
    JS.Force = JS.LoadLib("force")
    Script.Yield(50)
    JS.PTFX = JS.LoadLib("ptfx")
    Script.Yield(50)
    JS.Vehicle = JS.LoadLib("vehicle")
    Script.Yield(50)
    JS.Network = JS.LoadLib("network")
    Script.Yield(50)
    
    local loadedCount = 0
    local libs = {"Entity", "Force", "PTFX", "Vehicle", "Network"}
    for _, name in ipairs(libs) do
        if JS[name] then 
            loadedCount = loadedCount + 1 
            log(" OK " .. name)
        else
            log(" FAIL " .. name)
        end
    end
    
    log("═══════════════════════════════════════════════════════════════")
    log(" Loaded " .. loadedCount .. "/" .. #libs .. " libraries")
    log("═══════════════════════════════════════════════════════════════")
    
    if loadedCount == #libs then
        toast(SCRIPT_NAME, "All " .. #libs .. " libs loaded!", 3000)
    else
        toast(SCRIPT_NAME, loadedCount .. "/" .. #libs .. " libs", 4000)
    end
    
    _G.JerryScript = JS
    _G.JS = JS
end)

return JS
