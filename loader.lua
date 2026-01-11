--[[
    ═══════════════════════════════════════════════════════════════════════════
    JERRYSCRIPT LOADER - CHERAX EDITION
    ═══════════════════════════════════════════════════════════════════════════
    
    Advanced loader that fetches JerryScript from GitHub
    Auto-updates, version checking, error handling
    
    GitHub: https://github.com/jb321-MIA/JerryScript-Cherax
    ═══════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════
local CONFIG = {
    NAME = "JerryScript",
    VERSION = "1.1.0",
    
    -- GitHub Settings
    GITHUB_USER = "jb321-MIA",
    GITHUB_REPO = "JerryScript-Cherax",
    GITHUB_BRANCH = "main",
    
    -- Files to load
    MAIN_SCRIPT = "JerryScript_v11_0_DOLOS.lua",
    
    -- Libraries (loaded first, available globally)
    LIBS = {
        "entity",
        "force", 
        "ptfx",
        "vehicle",
        "network"
    },
    
    -- Settings
    LOAD_LIBS = true,           -- Load helper libraries
    LOAD_MAIN = true,           -- Load main script
    SHOW_CONSOLE_LOG = true,    -- Show detailed logs
    FETCH_TIMEOUT = 10000,      -- HTTP timeout (ms)
}

-- Build base URL
local GITHUB_RAW = "https://raw.githubusercontent.com/" 
    .. CONFIG.GITHUB_USER .. "/" 
    .. CONFIG.GITHUB_REPO .. "/" 
    .. CONFIG.GITHUB_BRANCH .. "/"

-- ═══════════════════════════════════════════════════════════════════════════
-- LOGGING
-- ═══════════════════════════════════════════════════════════════════════════
local function log(msg, level)
    if CONFIG.SHOW_CONSOLE_LOG then
        local prefix = "[" .. CONFIG.NAME .. "]"
        if level == "OK" then
            prefix = prefix .. " ✓"
        elseif level == "FAIL" then
            prefix = prefix .. " ✗"
        elseif level == "WARN" then
            prefix = prefix .. " ⚠"
        elseif level == "INFO" then
            prefix = prefix .. " ►"
        end
        print(prefix .. " " .. tostring(msg))
    end
end

local function toast(msg, duration)
    pcall(function()
        GUI.AddToast(CONFIG.NAME, msg, duration or 3000, eToastPos.TopRight)
    end)
end

local function logHeader(text)
    log("═══════════════════════════════════════════════════════════════")
    log(" " .. text)
    log("═══════════════════════════════════════════════════════════════")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- HTTP FETCHING (Using Cherax Curl API)
-- ═══════════════════════════════════════════════════════════════════════════
local ActiveCurls = {}  -- Prevent garbage collection

local function fetchURL(url, timeout)
    timeout = timeout or CONFIG.FETCH_TIMEOUT
    
    local curl = Curl.Easy()
    table.insert(ActiveCurls, curl)
    
    -- Configure request
    curl:Setopt(eCurlOption.CURLOPT_URL, url)
    curl:Setopt(eCurlOption.CURLOPT_USERAGENT, CONFIG.NAME .. "-Loader/" .. CONFIG.VERSION)
    curl:DisableErrorLog()  -- Suppress curl errors in console
    
    -- Start async request
    curl:Perform()
    
    -- Wait for completion
    local waited = 0
    while not curl:GetFinished() and waited < timeout do
        Script.Yield(10)
        waited = waited + 10
    end
    
    -- Check result
    if curl:GetFinished() then
        local code, response = curl:GetResponse()
        if code == eCurlCode.CURLE_OK and response and #response > 0 then
            return response, nil
        else
            return nil, "HTTP Error: " .. tostring(code)
        end
    else
        return nil, "Timeout after " .. timeout .. "ms"
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CODE EXECUTION
-- ═══════════════════════════════════════════════════════════════════════════
local function executeCode(code, name)
    if not code then 
        return nil, "No code provided"
    end
    
    -- Parse the code
    local fn, parseErr = load(code, name)
    if not fn then
        return nil, "Parse error: " .. tostring(parseErr)
    end
    
    -- Execute the code
    local success, result = pcall(fn)
    if not success then
        return nil, "Runtime error: " .. tostring(result)
    end
    
    return result, nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- LIBRARY LOADER
-- ═══════════════════════════════════════════════════════════════════════════
local LoadedLibs = {}

local function loadLibrary(name)
    local url = GITHUB_RAW .. "libs/" .. name .. ".lua"
    log("Loading lib: " .. name, "INFO")
    
    local code, fetchErr = fetchURL(url)
    if not code then
        log("Failed to fetch " .. name .. ": " .. fetchErr, "FAIL")
        return nil
    end
    
    local result, execErr = executeCode(code, "lib/" .. name)
    if not result then
        log("Failed to execute " .. name .. ": " .. execErr, "FAIL")
        return nil
    end
    
    log("Loaded: " .. name .. " (" .. #code .. " bytes)", "OK")
    LoadedLibs[name] = result
    return result
end

local function loadAllLibraries()
    log("Loading libraries...", "INFO")
    
    local loaded = 0
    local failed = 0
    
    for _, libName in ipairs(CONFIG.LIBS) do
        Script.Yield(25)  -- Small delay between requests
        local lib = loadLibrary(libName)
        if lib then
            loaded = loaded + 1
        else
            failed = failed + 1
        end
    end
    
    log("Libraries: " .. loaded .. " loaded, " .. failed .. " failed")
    return loaded, failed
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN SCRIPT LOADER
-- ═══════════════════════════════════════════════════════════════════════════
local function loadMainScript()
    local url = GITHUB_RAW .. CONFIG.MAIN_SCRIPT
    log("Loading main script: " .. CONFIG.MAIN_SCRIPT, "INFO")
    
    toast("Downloading JerryScript...", 2000)
    
    local code, fetchErr = fetchURL(url)
    if not code then
        log("Failed to fetch main script: " .. fetchErr, "FAIL")
        toast("Failed to download script!", 5000)
        return false
    end
    
    log("Downloaded: " .. #code .. " bytes", "OK")
    toast("Initializing...", 1500)
    
    local result, execErr = executeCode(code, CONFIG.MAIN_SCRIPT)
    if execErr then
        log("Failed to execute main script: " .. execErr, "FAIL")
        toast("Script error! Check console.", 5000)
        return false
    end
    
    log("Main script loaded successfully!", "OK")
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- VERSION CHECK (Optional - checks for updates)
-- ═══════════════════════════════════════════════════════════════════════════
local function checkForUpdates()
    local versionUrl = GITHUB_RAW .. "version.txt"
    local remoteVersion, err = fetchURL(versionUrl, 3000)
    
    if remoteVersion then
        remoteVersion = remoteVersion:gsub("%s+", "")  -- Trim whitespace
        if remoteVersion ~= CONFIG.VERSION then
            log("Update available! Current: " .. CONFIG.VERSION .. " -> New: " .. remoteVersion, "WARN")
            toast("Update available: v" .. remoteVersion, 5000)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GLOBAL EXPORTS (Available to other scripts)
-- ═══════════════════════════════════════════════════════════════════════════
local JS = {
    Version = CONFIG.VERSION,
    Config = CONFIG,
    Libs = LoadedLibs,
    
    -- Utility functions
    Log = log,
    Toast = toast,
    Fetch = fetchURL,
    Execute = executeCode,
    
    -- Library access shortcuts (populated after loading)
    Entity = nil,
    Force = nil,
    PTFX = nil,
    Vehicle = nil,
    Network = nil,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════
local function initialize()
    logHeader(CONFIG.NAME .. " Loader v" .. CONFIG.VERSION)
    log("GitHub: " .. CONFIG.GITHUB_USER .. "/" .. CONFIG.GITHUB_REPO, "INFO")
    log("Branch: " .. CONFIG.GITHUB_BRANCH, "INFO")
    logHeader("Starting...")
    
    toast("JerryScript Loader starting...", 2000)
    
    -- Step 1: Load libraries (optional)
    if CONFIG.LOAD_LIBS then
        Script.Yield(100)
        local loaded, failed = loadAllLibraries()
        
        -- Export loaded libraries
        JS.Entity = LoadedLibs.entity
        JS.Force = LoadedLibs.force
        JS.PTFX = LoadedLibs.ptfx
        JS.Vehicle = LoadedLibs.vehicle
        JS.Network = LoadedLibs.network
        JS.Libs = LoadedLibs
    end
    
    -- Step 2: Load main script
    if CONFIG.LOAD_MAIN then
        Script.Yield(100)
        local success = loadMainScript()
        
        if success then
            logHeader("JerryScript Ready!")
            toast("JerryScript loaded! ✓", 3000)
        else
            logHeader("Load Failed!")
            toast("Failed to load JerryScript!", 5000)
        end
    end
    
    -- Step 3: Check for updates (non-blocking)
    Script.QueueJob(function()
        Script.Yield(2000)
        checkForUpdates()
    end)
    
    -- Export globally
    _G.JerryScript = JS
    _G.JS = JS
end

-- ═══════════════════════════════════════════════════════════════════════════
-- START
-- ═══════════════════════════════════════════════════════════════════════════
Script.QueueJob(function()
    Script.Yield(50)  -- Small delay for Cherax to fully initialize
    initialize()
end)

return JS
