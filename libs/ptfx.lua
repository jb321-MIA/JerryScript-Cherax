--[[
    JerryScript PTFX Library
    Particle effects management for Cherax
]]

local PTFX = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES
-- ═══════════════════════════════════════════════════════════════════════════

local N = {
    REQUEST_NAMED_PTFX_ASSET = 0xB80D8756B4668AB6,
    HAS_NAMED_PTFX_ASSET_LOADED = 0x8702416E512EC454,
    REMOVE_NAMED_PTFX_ASSET = 0x5F61EBBE1D00F305,
    USE_PARTICLE_FX_ASSET = 0x6C38AF3693A69A91,
    START_PARTICLE_FX_NON_LOOPED_AT_COORD = 0x25129531F77B9ED3,
    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD = 0xF56B8137DF10135D,
    START_PARTICLE_FX_LOOPED_AT_COORD = 0xE184F4F0DC5910E7,
    START_NETWORKED_PARTICLE_FX_LOOPED_AT_COORD = 0x6F60E89A7B64EE1D,
    START_PARTICLE_FX_NON_LOOPED_ON_ENTITY = 0x0D53A3B8DA0809D2,
    START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY = 0xC95EB1DB6E92113D,
    START_PARTICLE_FX_LOOPED_ON_ENTITY = 0x1AE42C1660FD6517,
    STOP_PARTICLE_FX_LOOPED = 0x8F75B0EE9D5A8DC7,
    REMOVE_PARTICLE_FX = 0xC401503DFE8D53CF,
    SET_PARTICLE_FX_NON_LOOPED_COLOUR = 0x26143A59EF48B262,
    SET_PARTICLE_FX_LOOPED_COLOUR = 0x7F8F65877F88783B,
    SET_PARTICLE_FX_LOOPED_ALPHA = 0x726845132380142E,
    SET_PARTICLE_FX_LOOPED_SCALE = 0xB44250AAA456492D,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- EFFECT PRESETS
-- ═══════════════════════════════════════════════════════════════════════════

PTFX.Effects = {
    -- Core effects (always loaded)
    FIRE = {asset = "core", effect = "ent_sht_flame", scale = 2.0},
    FIRE_SMALL = {asset = "core", effect = "ent_sht_flame", scale = 1.0},
    FIRE_LARGE = {asset = "core", effect = "ent_sht_flame", scale = 4.0},
    BLOOD = {asset = "core", effect = "ent_sht_blood", scale = 1.5},
    BLOOD_HD = {asset = "core", effect = "ent_sht_blood_hd", scale = 2.0},
    WATER = {asset = "core", effect = "ent_sht_water", scale = 2.0},
    SPARKS = {asset = "core", effect = "ent_brk_sparks", scale = 1.5},
    SMOKE = {asset = "core", effect = "exp_grd_bzgas_smoke", scale = 2.0},
    SMOKE_SMALL = {asset = "core", effect = "exp_grd_bzgas_smoke", scale = 1.0},
    EXPLOSION_SMOKE = {asset = "core", effect = "exp_grd_grenade_smoke", scale = 1.5},
    
    -- Script effects (need loading)
    CLOWN = {asset = "scr_rcbarry1", effect = "scr_clown_appears", scale = 1.0},
    ALIEN = {asset = "scr_rcbarry2", effect = "scr_exp_clown", scale = 1.0},
    WEED = {asset = "scr_rcbarry2", effect = "scr_barry2_weed_yourshirt", scale = 1.0},
    CONFETTI = {asset = "scr_xs_celebration", effect = "scr_xs_confetti_burst", scale = 2.0},
    CHAMPAGNE = {asset = "scr_xs_celebration", effect = "scr_xs_champagne_spray", scale = 1.5},
    
    -- Vehicle effects
    EXHAUST_FLAMES = {asset = "veh_xs_vehicle_mods", effect = "veh_nitrous", scale = 1.0},
    
    -- Heist effects
    BANK_MONEY = {asset = "scr_ornate_heist", effect = "scr_orn_mny_bag_float", scale = 1.0},
}

-- ═══════════════════════════════════════════════════════════════════════════
-- ASSET MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

local LoadedAssets = {}

function PTFX.RequestAsset(asset, timeout)
    if LoadedAssets[asset] then return true end
    
    timeout = timeout or 100
    Natives.InvokeVoid(N.REQUEST_NAMED_PTFX_ASSET, asset)
    
    local waited = 0
    while not Natives.InvokeBool(N.HAS_NAMED_PTFX_ASSET_LOADED, asset) do
        Script.Yield(0)
        waited = waited + 1
        if waited > timeout then
            return false
        end
    end
    
    LoadedAssets[asset] = true
    return true
end

function PTFX.IsAssetLoaded(asset)
    return Natives.InvokeBool(N.HAS_NAMED_PTFX_ASSET_LOADED, asset)
end

function PTFX.RemoveAsset(asset)
    Natives.InvokeVoid(N.REMOVE_NAMED_PTFX_ASSET, asset)
    LoadedAssets[asset] = nil
end

function PTFX.SetAsset(asset)
    Natives.InvokeVoid(N.USE_PARTICLE_FX_ASSET, asset)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPAWN FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Spawn non-looped effect at coordinates (networked)
function PTFX.SpawnAtCoord(x, y, z, effect, scale, networked)
    local fx = effect
    if type(effect) == "string" then
        fx = PTFX.Effects[effect] or PTFX.Effects.FIRE
    end
    
    if not PTFX.RequestAsset(fx.asset, 50) then
        return false
    end
    
    PTFX.SetAsset(fx.asset)
    scale = scale or fx.scale or 1.0
    
    if networked ~= false then
        Natives.InvokeInt(N.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD,
            fx.effect, x, y, z,
            0.0, 0.0, 0.0,
            scale,
            false, false, false, false)
    else
        Natives.InvokeInt(N.START_PARTICLE_FX_NON_LOOPED_AT_COORD,
            fx.effect, x, y, z,
            0.0, 0.0, 0.0,
            scale,
            false, false, false)
    end
    
    return true
end

-- Spawn with random offset (for spam effects)
function PTFX.SpawnAtCoordRandom(x, y, z, effect, range, scale)
    local ox = (math.random() - 0.5) * (range or 6)
    local oy = (math.random() - 0.5) * (range or 6)
    local oz = math.random() * ((range or 6) / 3)
    
    return PTFX.SpawnAtCoord(x + ox, y + oy, z + oz, effect, scale)
end

-- Spawn looped effect at coordinates
function PTFX.SpawnLoopedAtCoord(x, y, z, effect, scale, networked)
    local fx = effect
    if type(effect) == "string" then
        fx = PTFX.Effects[effect] or PTFX.Effects.FIRE
    end
    
    if not PTFX.RequestAsset(fx.asset, 50) then
        return nil
    end
    
    PTFX.SetAsset(fx.asset)
    scale = scale or fx.scale or 1.0
    
    local handle
    if networked ~= false then
        handle = Natives.InvokeInt(N.START_NETWORKED_PARTICLE_FX_LOOPED_AT_COORD,
            fx.effect, x, y, z,
            0.0, 0.0, 0.0,
            scale,
            false, false, false, false)
    else
        handle = Natives.InvokeInt(N.START_PARTICLE_FX_LOOPED_AT_COORD,
            fx.effect, x, y, z,
            0.0, 0.0, 0.0,
            scale,
            false, false, false, false)
    end
    
    return handle
end

-- Spawn non-looped effect on entity
function PTFX.SpawnOnEntity(entity, effect, offsetX, offsetY, offsetZ, scale, networked)
    local fx = effect
    if type(effect) == "string" then
        fx = PTFX.Effects[effect] or PTFX.Effects.FIRE
    end
    
    if not PTFX.RequestAsset(fx.asset, 50) then
        return false
    end
    
    PTFX.SetAsset(fx.asset)
    scale = scale or fx.scale or 1.0
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    offsetZ = offsetZ or 0
    
    if networked ~= false then
        Natives.InvokeInt(N.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY,
            fx.effect, entity,
            offsetX, offsetY, offsetZ,
            0.0, 0.0, 0.0,
            scale,
            false, false, false)
    else
        Natives.InvokeInt(N.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY,
            fx.effect, entity,
            offsetX, offsetY, offsetZ,
            0.0, 0.0, 0.0,
            scale,
            false, false, false)
    end
    
    return true
end

-- Spawn looped effect on entity
function PTFX.SpawnLoopedOnEntity(entity, effect, offsetX, offsetY, offsetZ, scale)
    local fx = effect
    if type(effect) == "string" then
        fx = PTFX.Effects[effect] or PTFX.Effects.FIRE
    end
    
    if not PTFX.RequestAsset(fx.asset, 50) then
        return nil
    end
    
    PTFX.SetAsset(fx.asset)
    scale = scale or fx.scale or 1.0
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    offsetZ = offsetZ or 0
    
    return Natives.InvokeInt(N.START_PARTICLE_FX_LOOPED_ON_ENTITY,
        fx.effect, entity,
        offsetX, offsetY, offsetZ,
        0.0, 0.0, 0.0,
        scale,
        false, false, false)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CONTROL FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function PTFX.StopLooped(handle)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.STOP_PARTICLE_FX_LOOPED, handle, false)
    end
end

function PTFX.Remove(handle)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.REMOVE_PARTICLE_FX, handle, false)
    end
end

function PTFX.SetLoopedColor(handle, r, g, b)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.SET_PARTICLE_FX_LOOPED_COLOUR, handle, r, g, b, false)
    end
end

function PTFX.SetLoopedAlpha(handle, alpha)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.SET_PARTICLE_FX_LOOPED_ALPHA, handle, alpha)
    end
end

function PTFX.SetLoopedScale(handle, scale)
    if handle and handle ~= 0 then
        Natives.InvokeVoid(N.SET_PARTICLE_FX_LOOPED_SCALE, handle, scale)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EFFECT PRESETS FOR SPAM
-- ═══════════════════════════════════════════════════════════════════════════

PTFX.SpamEffects = {
    {name = "Clown", effect = PTFX.Effects.CLOWN},
    {name = "Fire", effect = PTFX.Effects.FIRE},
    {name = "Explosion", effect = PTFX.Effects.EXPLOSION_SMOKE},
    {name = "Water", effect = PTFX.Effects.WATER},
    {name = "Sparks", effect = PTFX.Effects.SPARKS},
    {name = "Smoke", effect = PTFX.Effects.SMOKE},
    {name = "Blood", effect = PTFX.Effects.BLOOD},
    {name = "Alien", effect = PTFX.Effects.ALIEN},
}

function PTFX.GetSpamEffect(index)
    return PTFX.SpamEffects[index] or PTFX.SpamEffects[2]
end

return PTFX
