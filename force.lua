--[[
    JerryScript Force Library
    Physics and force application functions
]]

local Force = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES
-- ═══════════════════════════════════════════════════════════════════════════

local N = {
    APPLY_FORCE_TO_ENTITY = 0xC5F68BE9613E2D18,
    APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS = 0x18FF00FC7EFF559E,
    SET_ENTITY_VELOCITY = 0x1C99BB7B6E96D16F,
    GET_ENTITY_VELOCITY = 0x4805D2B1D8CF94A9,
    GET_ENTITY_COORDS = 0x3FEF770D40960D5A,
    IS_ENTITY_IN_AIR = 0x886E37EC497200B6,
    NETWORK_REQUEST_CONTROL_OF_ENTITY = 0xB69317BF5E782347,
    NETWORK_HAS_CONTROL_OF_ENTITY = 0x01BF60A500E28887,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- FORCE TYPES (from GTA)
-- ═══════════════════════════════════════════════════════════════════════════

Force.Type = {
    MIN_FORCE = 0,
    MAX_FORCE_ROT = 1,      -- Most common, includes rotation
    MIN_FORCE_2 = 2,
    MAX_FORCE_ROT_2 = 3,
    FORCE_NO_ROT = 4,
    FORCE_ROT_PLUS_FORCE = 5,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function requestControl(entity)
    if Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity) then
        return true
    end
    Natives.InvokeVoid(N.NETWORK_REQUEST_CONTROL_OF_ENTITY, entity)
    return Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CORE FORCE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Apply force to entity at center of mass
function Force.Apply(entity, fx, fy, fz, relative)
    if not entity or entity == 0 then return false end
    requestControl(entity)
    
    Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS, entity, 
        Force.Type.MAX_FORCE_ROT,
        fx, fy, fz,
        true,           -- Component (unknown)
        false,          -- isRel 
        true,           -- highPriority
        relative or false)  -- Relative to entity rotation
    return true
end

-- Apply force at specific offset (creates torque/spin)
function Force.ApplyAtOffset(entity, fx, fy, fz, ox, oy, oz, forceType)
    if not entity or entity == 0 then return false end
    requestControl(entity)
    
    Natives.InvokeVoid(N.APPLY_FORCE_TO_ENTITY, entity,
        forceType or Force.Type.MAX_FORCE_ROT,
        fx, fy, fz,     -- Force vector
        ox, oy, oz,     -- Offset from center
        0,              -- Bone index
        false,          -- isDirectionRel
        false,          -- ignoreUpVec
        true,           -- isForceRel
        false,          -- Unknown
        true)           -- Unknown
    return true
end

-- Set velocity directly (instant movement)
function Force.SetVelocity(entity, vx, vy, vz)
    if not entity or entity == 0 then return false end
    requestControl(entity)
    Natives.InvokeVoid(N.SET_ENTITY_VELOCITY, entity, vx, vy, vz)
    return true
end

-- Get current velocity
function Force.GetVelocity(entity)
    if not entity or entity == 0 then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_VELOCITY, entity)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DIRECTIONAL FORCE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Launch entity upward
function Force.LaunchUp(entity, power)
    return Force.Apply(entity, 0, 0, power or 100)
end

-- Launch entity in a direction
function Force.LaunchToward(entity, targetX, targetY, targetZ, power)
    if not entity or entity == 0 then return false end
    
    local ex, ey, ez = Natives.InvokeV3(N.GET_ENTITY_COORDS, entity, true)
    if not ex then return false end
    
    local dx = targetX - ex
    local dy = targetY - ey
    local dz = targetZ - ez
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    if dist == 0 then return false end
    
    power = power or 100
    return Force.Apply(entity, (dx/dist)*power, (dy/dist)*power, (dz/dist)*power)
end

-- Pull entity toward coordinates
function Force.PullToward(entity, targetX, targetY, targetZ, power)
    return Force.LaunchToward(entity, targetX, targetY, targetZ, power)
end

-- Push entity away from coordinates
function Force.PushAway(entity, fromX, fromY, fromZ, power)
    if not entity or entity == 0 then return false end
    
    local ex, ey, ez = Natives.InvokeV3(N.GET_ENTITY_COORDS, entity, true)
    if not ex then return false end
    
    local dx = ex - fromX
    local dy = ey - fromY
    local dz = ez - fromZ
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    if dist == 0 then return false end
    
    power = power or 100
    return Force.Apply(entity, (dx/dist)*power, (dy/dist)*power, (dz/dist)*power)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPIN/ROTATION FORCES
-- ═══════════════════════════════════════════════════════════════════════════

-- Spin entity horizontally (beyblade style)
function Force.SpinHorizontal(entity, power, lift)
    if not entity or entity == 0 then return false end
    requestControl(entity)
    
    -- Apply force at offset to create torque around Z axis
    return Force.ApplyAtOffset(entity, 
        power or 8.0, 0, lift or 0,  -- Force with optional lift
        0, 2.0, 0)                    -- Offset creates rotation
end

-- Spin entity like a top (vertical axis)
function Force.SpinVertical(entity, power)
    return Force.SpinHorizontal(entity, power, 0)
end

-- Tumble/flip entity
function Force.Tumble(entity, power)
    if not entity or entity == 0 then return false end
    return Force.ApplyAtOffset(entity,
        0, 0, power or 10,
        2.0, 0, 0)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPECIAL EFFECTS
-- ═══════════════════════════════════════════════════════════════════════════

-- Anchor (pull down if in air)
function Force.Anchor(entity, power)
    if not entity or entity == 0 then return false end
    
    if Natives.InvokeBool(N.IS_ENTITY_IN_AIR, entity) then
        return Force.Apply(entity, 0, 0, -(power or 150))
    end
    return false
end

-- To the moon (constant upward force)
function Force.Moon(entity, power)
    return Force.Apply(entity, 0, 0, power or 50)
end

-- Catapult (forward launch with arc)
function Force.Catapult(entity, power)
    if not entity or entity == 0 then return false end
    requestControl(entity)
    
    power = power or 100
    -- Forward + up for arc trajectory
    return Force.ApplyAtOffset(entity,
        0, power, power * 0.7,
        0, 0, 1.0)
end

-- Tornado swirl effect
function Force.TornadoSwirl(entity, centerX, centerY, centerZ, power)
    if not entity or entity == 0 then return false end
    
    local ex, ey, ez = Natives.InvokeV3(N.GET_ENTITY_COORDS, entity, true)
    if not ex then return false end
    
    local dx = centerX - ex
    local dy = centerY - ey
    local dist = math.sqrt(dx*dx + dy*dy)
    
    if dist < 1 then return false end
    
    -- Calculate swirl direction (perpendicular)
    local towardX = dx / dist
    local towardY = dy / dist
    local swirlX = -towardY
    local swirlY = towardX
    
    power = power or 10
    local swirlPower = power * 3
    local pullPower = power
    local liftPower = power * 2
    
    return Force.Apply(entity,
        (swirlX * swirlPower) + (towardX * pullPower),
        (swirlY * swirlPower) + (towardY * pullPower),
        liftPower)
end

-- Earthquake shake
function Force.Earthquake(entity, intensity)
    if not entity or entity == 0 then return false end
    
    intensity = intensity or 5
    local rx = (math.random() - 0.5) * intensity * 2
    local ry = (math.random() - 0.5) * intensity * 2
    local rz = math.random() * intensity
    
    return Force.Apply(entity, rx, ry, rz)
end

return Force
