--[[
    JerryScript Loader - Cherax Edition
    Loads modules from GitHub for easy updates
    
    Usage: Place this file in your Cherax Lua folder
    It will automatically fetch the latest modules
]]

local SCRIPT_NAME = "JerryScript"
local SCRIPT_VERSION = "1.0.0"
local GITHUB_RAW = "https://raw.githubusercontent.com/YOUR_USERNAME/JerryScript-Cherax/main/"

-- ═══════════════════════════════════════════════════════════════════════════
-- LOADER UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════

local LoadedModules = {}

-- Simple logging
local function log(msg)
    print("[" .. SCRIPT_NAME .. "] " .. tostring(msg))
end

local function toast(title, msg)
    GUI.AddToast(title, msg, 3000, eToastPos.TopRight)
end

-- HTTP fetch function using Cherax's capabilities
local function fetchURL(url, callback)
    -- Cherax doesn't have native HTTP, so we use a workaround
    -- Option 1: Use Script.HttpGet if available
    -- Option 2: Cache modules locally after first download
    
    -- For now, we'll use local file loading as fallback
    log("Fetching: " .. url)
    
    -- Try Cherax HTTP if available
    if Script and Script.HttpGet then
        Script.HttpGet(url, function(response)
            if response and response.success then
                callback(response.body)
            else
                log("HTTP fetch failed: " .. url)
                callback(nil)
            end
        end)
    else
        -- Fallback: Try to load from local cache
        log("HTTP not available, using local files")
        callback(nil)
    end
end

-- Load and execute Lua code
local function loadCode(code, moduleName)
    if not code then return nil end
    
    local fn, err = load(code, moduleName)
    if fn then
        local success, result = pcall(fn)
        if success then
            return result
        else
            log("Error executing " .. moduleName .. ": " .. tostring(result))
        end
    else
        log("Error loading " .. moduleName .. ": " .. tostring(err))
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MODULE LOADER
-- ═══════════════════════════════════════════════════════════════════════════

local JS = {}  -- Main JerryScript namespace

-- Load a library
function JS.LoadLib(name)
    if LoadedModules["libs/" .. name] then
        return LoadedModules["libs/" .. name]
    end
    
    log("Loading lib: " .. name)
    
    -- Try local file first (for development)
    local localPath = "JerryScript/libs/" .. name .. ".lua"
    local f = io.open(localPath, "r")
    if f then
        local code = f:read("*all")
        f:close()
        local module = loadCode(code, "libs/" .. name)
        if module then
            LoadedModules["libs/" .. name] = module
            return module
        end
    end
    
    -- Try GitHub
    fetchURL(GITHUB_RAW .. "libs/" .. name .. ".lua", function(code)
        if code then
            local module = loadCode(code, "libs/" .. name)
            if module then
                LoadedModules["libs/" .. name] = module
            end
        end
    end)
    
    return LoadedModules["libs/" .. name]
end

-- Load a module
function JS.LoadModule(name)
    if LoadedModules["modules/" .. name] then
        return LoadedModules["modules/" .. name]
    end
    
    log("Loading module: " .. name)
    
    -- Try local file first
    local localPath = "JerryScript/modules/" .. name .. ".lua"
    local f = io.open(localPath, "r")
    if f then
        local code = f:read("*all")
        f:close()
        local module = loadCode(code, "modules/" .. name)
        if module then
            LoadedModules["modules/" .. name] = module
            return module
        end
    end
    
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

log("═══════════════════════════════════════════════════════════════")
log(" " .. SCRIPT_NAME .. " Loader v" .. SCRIPT_VERSION)
log("═══════════════════════════════════════════════════════════════")

-- Load core libraries
JS.Entity = JS.LoadLib("entity")
JS.Vehicle = JS.LoadLib("vehicle")
JS.PTFX = JS.LoadLib("ptfx")
JS.Network = JS.LoadLib("network")
JS.Force = JS.LoadLib("force")

-- Load feature modules
JS.Attackers = JS.LoadModule("attackers")
JS.Trolling = JS.LoadModule("trolling")
JS.Crashes = JS.LoadModule("crashes")
JS.VehicleTrolls = JS.LoadModule("vehicle_trolls")

-- Export
_G.JerryScript = JS

toast(SCRIPT_NAME, "Loader v" .. SCRIPT_VERSION .. " initialized!")

return JS
