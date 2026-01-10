--[[
    JerryScript Entity Library
    Common entity manipulation functions for Cherax
]]

local Entity = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES
-- ═══════════════════════════════════════════════════════════════════════════

local N = {
    GET_ENTITY_COORDS = 0x3FEF770D40960D5A,
    SET_ENTITY_COORDS = 0x06843DA7060A026B,
    SET_ENTITY_COORDS_NO_OFFSET = 0x239A3351AC1DA385,
    GET_ENTITY_ROTATION = 0xAFBD61CC738D9EB9,
    SET_ENTITY_ROTATION = 0x8524A8B0171D5E07,
    GET_ENTITY_HEADING = 0xE83D4F9BA2A38914,
    SET_ENTITY_HEADING = 0x8E2530AA8ADA980E,
    GET_ENTITY_VELOCITY = 0x4805D2B1D8CF94A9,
    SET_ENTITY_VELOCITY = 0x1C99BB7B6E96D16F,
    GET_ENTITY_MODEL = 0x9F47B058362C84B5,
    GET_ENTITY_TYPE = 0x8ACD366038D14505,
    IS_ENTITY_DEAD = 0x5F9532F3B5CC2551,
    IS_ENTITY_VISIBLE = 0x47D6F43D77935C75,
    SET_ENTITY_VISIBLE = 0xEA1C610A04DB6BBB,
    IS_ENTITY_IN_AIR = 0x886E37EC497200B6,
    FREEZE_ENTITY_POSITION = 0x428CA6DBD1094446,
    SET_ENTITY_INVINCIBLE = 0x3882114BDE571AD4,
    SET_ENTITY_AS_MISSION_ENTITY = 0xAD738C3085FE7E11,
    DELETE_ENTITY = 0xAE3CBE5BF394C9C9,
    DOES_ENTITY_EXIST = 0x7239B21A38F536BA,
    NETWORK_GET_NETWORK_ID_FROM_ENTITY = 0xA11700682F3AD45C,
    NETWORK_REQUEST_CONTROL_OF_ENTITY = 0xB69317BF5E782347,
    NETWORK_HAS_CONTROL_OF_ENTITY = 0x01BF60A500E28887,
    DETACH_ENTITY = 0x961AC54BF0613F5D,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- CORE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Entity.Exists(entity)
    if not entity or entity == 0 then return false end
    return Natives.InvokeBool(N.DOES_ENTITY_EXIST, entity)
end

function Entity.GetCoords(entity)
    if not Entity.Exists(entity) then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_COORDS, entity, true)
end

function Entity.SetCoords(entity, x, y, z, noOffset)
    if not Entity.Exists(entity) then return false end
    if noOffset then
        Natives.InvokeVoid(N.SET_ENTITY_COORDS_NO_OFFSET, entity, x, y, z, false, false, false)
    else
        Natives.InvokeVoid(N.SET_ENTITY_COORDS, entity, x, y, z, false, false, false, false)
    end
    return true
end

function Entity.GetRotation(entity)
    if not Entity.Exists(entity) then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_ROTATION, entity, 2)
end

function Entity.SetRotation(entity, pitch, roll, yaw)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.SET_ENTITY_ROTATION, entity, pitch, roll, yaw, 2, true)
    return true
end

function Entity.GetHeading(entity)
    if not Entity.Exists(entity) then return nil end
    return Natives.InvokeFloat(N.GET_ENTITY_HEADING, entity)
end

function Entity.SetHeading(entity, heading)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.SET_ENTITY_HEADING, entity, heading)
    return true
end

function Entity.GetVelocity(entity)
    if not Entity.Exists(entity) then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_VELOCITY, entity)
end

function Entity.SetVelocity(entity, vx, vy, vz)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.SET_ENTITY_VELOCITY, entity, vx, vy, vz)
    return true
end

function Entity.GetModel(entity)
    if not Entity.Exists(entity) then return nil end
    return Natives.InvokeInt(N.GET_ENTITY_MODEL, entity)
end

function Entity.GetType(entity)
    if not Entity.Exists(entity) then return nil end
    return Natives.InvokeInt(N.GET_ENTITY_TYPE, entity)
end

function Entity.IsDead(entity)
    if not Entity.Exists(entity) then return true end
    return Natives.InvokeBool(N.IS_ENTITY_DEAD, entity, false)
end

function Entity.IsInAir(entity)
    if not Entity.Exists(entity) then return false end
    return Natives.InvokeBool(N.IS_ENTITY_IN_AIR, entity)
end

function Entity.IsVisible(entity)
    if not Entity.Exists(entity) then return false end
    return Natives.InvokeBool(N.IS_ENTITY_VISIBLE, entity)
end

function Entity.SetVisible(entity, visible)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.SET_ENTITY_VISIBLE, entity, visible, false)
    return true
end

function Entity.Freeze(entity, freeze)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.FREEZE_ENTITY_POSITION, entity, freeze)
    return true
end

function Entity.SetInvincible(entity, invincible)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.SET_ENTITY_INVINCIBLE, entity, invincible)
    return true
end

function Entity.Detach(entity)
    if not Entity.Exists(entity) then return false end
    Natives.InvokeVoid(N.DETACH_ENTITY, entity, true, true)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- NETWORK FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Entity.GetNetworkId(entity)
    if not Entity.Exists(entity) then return nil end
    return Natives.InvokeInt(N.NETWORK_GET_NETWORK_ID_FROM_ENTITY, entity)
end

function Entity.RequestControl(entity, timeout)
    if not Entity.Exists(entity) then return false end
    timeout = timeout or 100
    
    local startTime = os.clock()
    while not Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity) do
        Natives.InvokeVoid(N.NETWORK_REQUEST_CONTROL_OF_ENTITY, entity)
        if (os.clock() - startTime) * 1000 > timeout then
            return false
        end
        Script.Yield(0)
    end
    return true
end

function Entity.HasControl(entity)
    if not Entity.Exists(entity) then return false end
    return Natives.InvokeBool(N.NETWORK_HAS_CONTROL_OF_ENTITY, entity)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DELETION
-- ═══════════════════════════════════════════════════════════════════════════

function Entity.Delete(entity)
    if not Entity.Exists(entity) then return false end
    
    pcall(function()
        Entity.RequestControl(entity, 50)
        Natives.InvokeVoid(N.SET_ENTITY_AS_MISSION_ENTITY, entity, true, true)
        Natives.InvokeVoid(N.DELETE_ENTITY, entity)
    end)
    
    return not Entity.Exists(entity)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DISTANCE UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════

function Entity.Distance(entity1, entity2)
    local x1, y1, z1 = Entity.GetCoords(entity1)
    local x2, y2, z2 = Entity.GetCoords(entity2)
    if not x1 or not x2 then return nil end
    
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Entity.DistanceToCoords(entity, x, y, z)
    local ex, ey, ez = Entity.GetCoords(entity)
    if not ex then return nil end
    
    local dx = x - ex
    local dy = y - ey
    local dz = z - ez
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Entity.DistanceSq(entity1, entity2)
    local x1, y1, z1 = Entity.GetCoords(entity1)
    local x2, y2, z2 = Entity.GetCoords(entity2)
    if not x1 or not x2 then return nil end
    
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return dx*dx + dy*dy + dz*dz
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DIRECTION UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════

function Entity.DirectionTo(fromEntity, toEntity)
    local x1, y1, z1 = Entity.GetCoords(fromEntity)
    local x2, y2, z2 = Entity.GetCoords(toEntity)
    if not x1 or not x2 then return nil, nil, nil end
    
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    if dist == 0 then return 0, 0, 0 end
    return dx/dist, dy/dist, dz/dist
end

function Entity.DirectionToCoords(entity, x, y, z)
    local ex, ey, ez = Entity.GetCoords(entity)
    if not ex then return nil, nil, nil end
    
    local dx = x - ex
    local dy = y - ey
    local dz = z - ez
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    if dist == 0 then return 0, 0, 0 end
    return dx/dist, dy/dist, dz/dist
end

return Entity
