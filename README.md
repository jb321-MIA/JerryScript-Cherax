# JerryScript-Cherax

A modular Lua scripting framework for Cherax mod menu (GTA V).

## Features

- **Modular Architecture** - Split into reusable libraries and feature modules
- **Easy Updates** - Change one library, all features benefit
- **Clean Code** - Well-documented functions with consistent APIs
- **Powerful Tools** - Entity manipulation, physics, PTFX, networking

## Structure

```
JerryScript-Cherax/
├── loader.lua              # Main loader script
├── libs/                   # Core libraries
│   ├── entity.lua          # Entity manipulation (coords, rotation, deletion)
│   ├── vehicle.lua         # Vehicle functions (health, doors, tires)
│   ├── force.lua           # Physics/force application
│   ├── ptfx.lua            # Particle effects
│   └── network.lua         # Network sync, crash methods
└── modules/                # Feature modules (coming soon)
    ├── attackers.lua       # NPC attackers
    ├── trolling.lua        # Trolling features
    └── crashes.lua         # Crash methods
```

## Installation

1. Clone this repo or download the files
2. Place in your Cherax `Scripts` folder:
   ```
   Cherax/Scripts/JerryScript/
   ```
3. Load `loader.lua` from the Cherax Lua menu

## Library Usage

### Entity Library
```lua
local Entity = JerryScript.Entity

-- Get coordinates
local x, y, z = Entity.GetCoords(someEntity)

-- Teleport
Entity.SetCoords(entity, x, y, z)

-- Request network control
if Entity.RequestControl(entity) then
    Entity.Delete(entity)
end

-- Distance calculations
local dist = Entity.Distance(entity1, entity2)
```

### Force Library
```lua
local Force = JerryScript.Force

-- Launch entity upward
Force.LaunchUp(vehicle, 200)

-- Spin like beyblade
Force.SpinHorizontal(vehicle, 10)

-- Tornado swirl effect
Force.TornadoSwirl(entity, targetX, targetY, targetZ, 15)

-- Anchor (pull down)
Force.Anchor(vehicle, 150)
```

### PTFX Library
```lua
local PTFX = JerryScript.PTFX

-- Spawn fire at coordinates
PTFX.SpawnAtCoord(x, y, z, "FIRE")

-- Spawn with random offset (spam)
PTFX.SpawnAtCoordRandom(x, y, z, PTFX.Effects.BLOOD, 6)

-- Spawn on entity
PTFX.SpawnOnEntity(ped, "SPARKS", 0, 0, 1)

-- Looped effect
local handle = PTFX.SpawnLoopedAtCoord(x, y, z, "SMOKE")
-- Later...
PTFX.StopLooped(handle)
```

### Vehicle Library
```lua
local Vehicle = JerryScript.Vehicle

-- Get player's vehicle
local veh = Vehicle.GetPedVehicle(ped)

-- Damage
Vehicle.SetEngineHealth(veh, 0)
Vehicle.BurstAllTyres(veh)
Vehicle.Explode(veh)

-- Control
Vehicle.SetBurnout(veh, true)
Vehicle.LockDoors(veh, 2)
```

### Network Library
```lua
local Network = JerryScript.Network

-- Get player info
local coords = Network.GetPlayerCoords(pid)
local ped = Network.GetPlayerPed(pid)

-- Crash methods
Network.IWCrash(pid)  -- Invalid weapon crash
```

## Adding New Features

1. Create a new module in `modules/`
2. Use the libraries for common operations
3. Register features with Cherax's FeatureMgr

Example module:
```lua
-- modules/my_feature.lua
local Entity = JerryScript.Entity
local Force = JerryScript.Force

local MyFeature = {}

function MyFeature.DoSomething(pid)
    local ped = Network.GetPlayerPed(pid)
    local veh = Vehicle.GetPedVehicle(ped)
    if veh then
        Force.LaunchUp(veh, 500)
    end
end

return MyFeature
```

## Credits

- JerryScript - Original concept
- Cherax Team - Mod menu API
- Stand Dolos - Inspiration for many features

## Disclaimer

For educational purposes only. Use responsibly.
