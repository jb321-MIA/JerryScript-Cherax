--[[
    ═══════════════════════════════════════════════════════════════
    JERRYSCRIPT LOADER v2.0 - CHERAX EDITION
    ═══════════════════════════════════════════════════════════════
    
    Simple, reliable loader for JerryScript from GitHub
    
    GitHub: https://github.com/jb321-MIA/JerryScript-Cherax
    ═══════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION - EDIT THESE IF NEEDED
-- ═══════════════════════════════════════════════════════════════
local GITHUB_USER = "jb321-MIA"
local GITHUB_REPO = "JerryScript-Cherax"
local GITHUB_BRANCH = "main"

-- THE FILENAME ON GITHUB (must match exactly, case-sensitive!)
local MAIN_SCRIPT = "JerryScript.lua"

-- ═══════════════════════════════════════════════════════════════
-- DO NOT EDIT BELOW THIS LINE
-- ═══════════════════════════════════════════════════════════════
local SCRIPT_NAME = "JerryScript"
local LOADER_VERSION = "2.0"

local BASE_URL = "https://raw.githubusercontent.com/" 
    .. GITHUB_USER .. "/" 
    .. GITHUB_REPO .. "/" 
    .. GITHUB_BRANCH .. "/"

local function log(msg)
    print("[JS-Loader] " .. tostring(msg))
end

local function toast(msg, duration)
    pcall(function()
        GUI.AddToast(SCRIPT_NAME, msg, duration or 3000, eToastPos.TopRight)
    end)
end

-- Simple HTTP fetch
local function fetchURL(url, timeout)
    timeout = timeout or 15000
    
    local curl = Curl.Easy()
    curl:Setopt(eCurlOption.CURLOPT_URL, url)
    curl:Setopt(eCurlOption.CURLOPT_USERAGENT, "JerryScript-Loader/" .. LOADER_VERSION)
    curl:Setopt(eCurlOption.CURLOPT_FOLLOWLOCATION, true)
    
    local ok, err = pcall(function() curl:Perform() end)
    if not ok then
        return nil, "Curl error: " .. tostring(err)
    end
    
    local waited = 0
    while not curl:GetFinished() and waited < timeout do
        Script.Yield(50)
        waited = waited + 50
    end
    
    if not curl:GetFinished() then
        return nil, "Timeout"
    end
    
    local code, response = curl:GetResponse()
    if code == eCurlCode.CURLE_OK and response and #response > 0 then
        -- Check for GitHub 404
        if response:find("404: Not Found") or response:sub(1,15) == "<!DOCTYPE html>" then
            return nil, "404 Not Found"
        end
        return response, nil
    end
    
    return nil, "HTTP error: " .. tostring(code)
end

-- Main loader
local function loadScript()
    log("═══════════════════════════════════════════════════════════════")
    log(" JerryScript Loader v" .. LOADER_VERSION)
    log("═══════════════════════════════════════════════════════════════")
    log("Repository: " .. GITHUB_USER .. "/" .. GITHUB_REPO)
    log("Branch: " .. GITHUB_BRANCH)
    log("Script: " .. MAIN_SCRIPT)
    log("")
    
    toast("Loading JerryScript...", 2000)
    
    -- Build URL
    local scriptURL = BASE_URL .. MAIN_SCRIPT
    log("Fetching: " .. scriptURL)
    
    -- Download script
    local code, err = fetchURL(scriptURL)
    
    if not code then
        log("")
        log("═══════════════════════════════════════════════════════════════")
        log(" DOWNLOAD FAILED: " .. tostring(err))
        log("═══════════════════════════════════════════════════════════════")
        log("")
        log("Please check:")
        log("  1. File '" .. MAIN_SCRIPT .. "' exists on GitHub")
        log("  2. Repository is public")
        log("  3. Branch is '" .. GITHUB_BRANCH .. "'")
        log("")
        log("Expected URL: " .. scriptURL)
        toast("Download failed! Check console.", 5000)
        return false
    end
    
    log("Downloaded " .. #code .. " bytes")
    
    -- Parse
    local fn, parseErr = load(code, MAIN_SCRIPT)
    if not fn then
        log("")
        log("═══════════════════════════════════════════════════════════════")
        log(" PARSE ERROR!")
        log("═══════════════════════════════════════════════════════════════")
        log(tostring(parseErr))
        toast("Parse error! Check console.", 5000)
        return false
    end
    
    log("Parsed successfully")
    
    -- Execute
    local ok, execErr = pcall(fn)
    if not ok then
        log("")
        log("═══════════════════════════════════════════════════════════════")
        log(" RUNTIME ERROR!")
        log("═══════════════════════════════════════════════════════════════")
        log(tostring(execErr))
        toast("Runtime error! Check console.", 5000)
        return false
    end
    
    log("")
    log("═══════════════════════════════════════════════════════════════")
    log(" JerryScript loaded successfully!")
    log("═══════════════════════════════════════════════════════════════")
    toast("JerryScript Ready!", 3000)
    return true
end

-- Start
Script.QueueJob(function()
    Script.Yield(100)
    loadScript()
end)
