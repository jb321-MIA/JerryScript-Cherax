--[[
    JerryScript Vehicle Library
    Vehicle manipulation functions for Cherax
]]

local Vehicle = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- NATIVE HASHES
-- ═══════════════════════════════════════════════════════════════════════════

local N = {
    GET_VEHICLE_PED_IS_IN = 0x9A9112A0FE9A4713,
    IS_PED_IN_ANY_VEHICLE = 0x997ABD671D25CA0B,
    GET_PED_IN_VEHICLE_SEAT = 0xBB40DD2270B65366,
    IS_VEHICLE_SEAT_FREE = 0x22AC59A870E6A669,
    SET_VEHICLE_ON_GROUND_PROPERLY = 0x49733E92263139D1,
    SET_VEHICLE_FORWARD_SPEED = 0xAB54A438726D25D5,
    SET_VEHICLE_ENGINE_ON = 0x2497C4717C8B881E,
    SET_VEHICLE_LIGHTS = 0x34E710FF01247C5A,
    SET_VEHICLE_FIXED = 0x115722B1B9C14C1C,
    SET_VEHICLE_DEFORMATION_FIXED = 0x953DA1E1B12C0491,
    SET_VEHICLE_UNDRIVEABLE = 0x8ADB4F6D5571FED5,
    SET_VEHICLE_DOORS_LOCKED = 0xB664292EAECF7FA6,
    SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS = 0xA2F80B8D040727CC,
    SET_VEHICLE_DOOR_OPEN = 0x7C65DAC73C35C862,
    SET_VEHICLE_DOOR_SHUT = 0x93D9BD300D7789E5,
    GET_VEHICLE_DOOR_ANGLE_RATIO = 0xFE3F9C29F7B32BD5,
    IS_VEHICLE_DOOR_FULLY_OPEN = 0x3E933CFF7B111C22,
    SET_VEHICLE_ENGINE_HEALTH = 0x45F6D8EEF34ABEF1,
    GET_VEHICLE_ENGINE_HEALTH = 0xC45D23BAF168AAB8,
    SET_VEHICLE_BODY_HEALTH = 0xB77D05AC8C78AADB,
    GET_VEHICLE_BODY_HEALTH = 0xF271147EB7B40F12,
    SET_VEHICLE_PETROL_TANK_HEALTH = 0x70DB57649FA8D0D8,
    GET_VEHICLE_PETROL_TANK_HEALTH = 0x7D5DABE888D2D074,
    EXPLODE_VEHICLE = 0xBA71116ADF5B514C,
    SET_VEHICLE_TYRE_BURST = 0xEC6A202EE4960385,
    IS_VEHICLE_TYRE_BURST = 0xBA291848A0815CA9,
    SET_VEHICLE_TYRES_CAN_BURST = 0xEB9DC3C7D8596C46,
    GET_VEHICLE_CLASS = 0x29439776AAA00A62,
    GET_VEHICLE_MAX_SPEED = 0x53AF99BAA671CA47,
    MODIFY_VEHICLE_TOP_SPEED = 0x93A3996368C94158,
    SET_VEHICLE_BURNOUT = 0xFB8794444A7D60FB,
    IS_VEHICLE_IN_BURNOUT = 0x1297A88E081430EB,
    SET_VEHICLE_REDUCE_GRIP = 0x5E569EC46EC21CAE,
    NETWORK_REQUEST_CONTROL_OF_ENTITY = 0xB69317BF5E782347,
    NETWORK_HAS_CONTROL_OF_ENTITY = 0x01BF60A500E28887,
    GET_ENTITY_COORDS = 0x3FEF770D40960D5A,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- VEHICLE CLASSES
-- ═══════════════════════════════════════════════════════════════════════════

Vehicle.Class = {
    COMPACT = 0,
    SEDAN = 1,
    SUV = 2,
    COUPE = 3,
    MUSCLE = 4,
    SPORT_CLASSIC = 5,
    SPORT = 6,
    SUPER = 7,
    MOTORCYCLE = 8,
    OFF_ROAD = 9,
    INDUSTRIAL = 10,
    UTILITY = 11,
    VAN = 12,
    CYCLE = 13,
    BOAT = 14,
    HELICOPTER = 15,
    PLANE = 16,
    SERVICE = 17,
    EMERGENCY = 18,
    MILITARY = 19,
    COMMERCIAL = 20,
    TRAIN = 21,
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
-- GET FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.GetPedVehicle(ped, lastVehicle)
    if not ped or ped == 0 then return nil end
    lastVehicle = lastVehicle or false
    return Natives.InvokeInt(N.GET_VEHICLE_PED_IS_IN, ped, lastVehicle)
end

function Vehicle.IsPedInVehicle(ped)
    if not ped or ped == 0 then return false end
    return Natives.InvokeBool(N.IS_PED_IN_ANY_VEHICLE, ped, false)
end

function Vehicle.GetDriver(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeInt(N.GET_PED_IN_VEHICLE_SEAT, vehicle, -1, false)
end

function Vehicle.IsSeatFree(vehicle, seat)
    if not vehicle or vehicle == 0 then return true end
    return Natives.InvokeBool(N.IS_VEHICLE_SEAT_FREE, vehicle, seat, false)
end

function Vehicle.GetClass(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeInt(N.GET_VEHICLE_CLASS, vehicle)
end

function Vehicle.GetMaxSpeed(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeFloat(N.GET_VEHICLE_MAX_SPEED, vehicle)
end

function Vehicle.GetCoords(vehicle)
    if not vehicle or vehicle == 0 then return nil, nil, nil end
    return Natives.InvokeV3(N.GET_ENTITY_COORDS, vehicle, true)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- HEALTH FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.GetEngineHealth(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeFloat(N.GET_VEHICLE_ENGINE_HEALTH, vehicle)
end

function Vehicle.SetEngineHealth(vehicle, health)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_ENGINE_HEALTH, vehicle, health)
    return true
end

function Vehicle.GetBodyHealth(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeFloat(N.GET_VEHICLE_BODY_HEALTH, vehicle)
end

function Vehicle.SetBodyHealth(vehicle, health)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_BODY_HEALTH, vehicle, health)
    return true
end

function Vehicle.GetPetrolTankHealth(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    return Natives.InvokeFloat(N.GET_VEHICLE_PETROL_TANK_HEALTH, vehicle)
end

function Vehicle.SetPetrolTankHealth(vehicle, health)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_PETROL_TANK_HEALTH, vehicle, health)
    return true
end

function Vehicle.Fix(vehicle)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_FIXED, vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_DEFORMATION_FIXED, vehicle)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CONTROL FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.SetOnGround(vehicle)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    return Natives.InvokeBool(N.SET_VEHICLE_ON_GROUND_PROPERLY, vehicle, 5.0)
end

function Vehicle.SetForwardSpeed(vehicle, speed)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_FORWARD_SPEED, vehicle, speed)
    return true
end

function Vehicle.SetEngineOn(vehicle, on, instantly, noAutoTurnOn)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_ENGINE_ON, vehicle, on, instantly or false, noAutoTurnOn or false)
    return true
end

function Vehicle.SetLights(vehicle, state)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_LIGHTS, vehicle, state)
    return true
end

function Vehicle.SetUndriveable(vehicle, undriveable)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_UNDRIVEABLE, vehicle, undriveable)
    return true
end

function Vehicle.ModifyTopSpeed(vehicle, multiplier)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.MODIFY_VEHICLE_TOP_SPEED, vehicle, multiplier)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DOOR FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.LockDoors(vehicle, lockState)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_DOORS_LOCKED, vehicle, lockState or 2)
    return true
end

function Vehicle.LockDoorsForAll(vehicle, lock)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS, vehicle, lock)
    return true
end

function Vehicle.OpenDoor(vehicle, doorIndex, loose, instantly)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_DOOR_OPEN, vehicle, doorIndex, loose or false, instantly or false)
    return true
end

function Vehicle.CloseDoor(vehicle, doorIndex, instantly)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_DOOR_SHUT, vehicle, doorIndex, instantly or false)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- TIRE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.BurstTyre(vehicle, index, onRim, completely)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_TYRE_BURST, vehicle, index, onRim or true, completely or 1000.0)
    return true
end

function Vehicle.BurstAllTyres(vehicle)
    for i = 0, 7 do
        Vehicle.BurstTyre(vehicle, i, true, 1000.0)
    end
    return true
end

function Vehicle.SetTyresCanBurst(vehicle, canBurst)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_TYRES_CAN_BURST, vehicle, canBurst)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPECIAL FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Vehicle.Explode(vehicle, audible, invisible)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.EXPLODE_VEHICLE, vehicle, audible ~= false, invisible or false)
    return true
end

function Vehicle.SetBurnout(vehicle, enable)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_BURNOUT, vehicle, enable)
    return true
end

function Vehicle.IsInBurnout(vehicle)
    if not vehicle or vehicle == 0 then return false end
    return Natives.InvokeBool(N.IS_VEHICLE_IN_BURNOUT, vehicle)
end

function Vehicle.SetReduceGrip(vehicle, enable)
    if not vehicle or vehicle == 0 then return false end
    requestControl(vehicle)
    Natives.InvokeVoid(N.SET_VEHICLE_REDUCE_GRIP, vehicle, enable)
    return true
end

return Vehicle
