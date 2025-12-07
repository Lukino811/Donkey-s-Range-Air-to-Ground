# DONKEY'S RANGE - Air-to-Ground Training Range System

## Overview

This is a modular DCS World training range system built with the MOOSE framework. The system provides a structured air-to-ground training environment with holding stack management, CHECK-IN/CHECK-OUT pilot registration, and finite state machine control.

## Version

**Version 10 (Modular)** - Refactored from monolithic script into separate logical modules.

## Files

### Main Bootstrapper

- **`range.lua`** - Main entry point that loads all modules, wires dependencies, and initializes the range system.

### Original Monolithic Script

- **`RANGE TARGET_suoniV10.lua`** - Original monolithic version (1800+ lines). Maintained for reference and backward compatibility.

## Module Structure

All modules are located in the `modules/` directory:

### 1. `range_config.lua`
Configuration and constants module containing:
- `RANGE` configuration table with all settings
- Training module types (Static Bombing, Convoy, Pop-Up, Urban)
- Defense levels (None, Low, Medium, High)
- Timer configurations
- Group prefixes for targets and defenses
- Zone names
- Stack/holding configuration
- Sound file paths
- All message templates
- Lookup tables (`ModuleToPrefixMap`, `DefenseToPrefixMap`)

**Exports:** `RangeConfig` module table

### 2. `range_state.lua`
Runtime state storage module containing:
- `State` table with:
  - Selected module and defense level
  - Holding stack and pilot stack tables
  - Active client information
  - Timer references
  - Active target/defense group lists
  - Sound queue state
  - Cooldown timers
  - Pilot registration data (CHECK-IN/CHECK-OUT)
- `Zones` table (HOLD, IP, AREA, TRAINING_AREA)
- `SpawnTemplates` table (Targets, Defenses)

**Exports:** `RangeState` module with `init()` function

### 3. `range_pilots.lua`
Pilot registration system (CHECK-IN/CHECK-OUT):
- `RegisterPilot(pilotName)` - Register a pilot to the range
- `UnregisterPilot(pilotName)` - Unregister a pilot
- `IsPilotRegistered(pilotName)` - Check registration status
- `GetRegisteredCount()` - Count of registered pilots
- `GetRegisteredPilotsList()` - List all registered pilots
- `ClearAllRegistrations()` - Clear all registrations
- `ForEachRegisteredClient(actionFunc)` - Iterate over registered clients
- `ForEachClientInTrainingArea(actionFunc)` - Iterate over clients in training area

**Exports:** `RangePilots` module with public API functions

### 4. `range_messages.lua`
Messaging and audio system:
- `PlaySoundToRegistered(soundFile)` - Queue sound to registered pilots
- `PlaySoundToTrainingArea(soundFile)` - Play sound to all in training area
- `PlaySoundToGroup(soundFile, group)` - Play sound to specific group
- `PlaySoundDirect(soundFile)` - Play sound directly (no queue)
- `SendMessageToRegistered(messageKey, duration, extraText)` - Message to registered
- `SendBroadcastToTrainingArea(messageKey, duration, extraText)` - Broadcast to area
- `SendMessageToAll(messageKey, duration, extraText)` - Message to all registered
- `SendMessageToGroup(messageKey, group, duration, extraText, prefix)` - Message to group
- `SendComposedMessageToAll(prefix, messageKey, extraText, duration)` - Composed message

**Note:** Duplicate function definitions from the original script were consolidated while maintaining identical APIs.

**Exports:** `RangeMessages` module with public API functions

### 5. `range_stack.lua`
Holding stack management system:
- `GetStackFL(stackNum)` - Get flight level for stack number
- `GetStackAltitudeFt(stackNum)` - Get altitude in feet for stack
- `GetHoldingCount()` - Count of pilots in holding
- `GetFirstFreeStack()` - Find first available stack position
- `IsPilotInHolding(pilotName)` - Check if pilot is in holding
- `GetPilotStack(pilotName)` - Get pilot's assigned stack number
- `GetNextPilotInStack()` - Get next pilot in queue
- `AddPilotToStack(pilotName, callerGroup)` - Add pilot to holding stack
- `RemovePilotFromStack(pilotName)` - Remove pilot from stack
- `ShiftStacksDown()` - Shift all stacks down after removal
- `ClearAllStacks()` - Clear all holding stacks
- `NotifyNextPilotInStack()` - Notify first pilot in queue

**Exports:** `RangeStack` module with public API functions

### 6. `range_timers.lua`
Timer management and periodic checks:
- `CheckHoldingAltitudes()` - Check pilots maintain assigned altitudes
- `StartAltitudeCheckTimer()` / `StopAltitudeCheckTimer()` - Altitude monitoring
- `CheckTrainingAreaPresence()` - Monitor pilots in/out of training area
- `StartZoneCheckTimer()` / `StopZoneCheckTimer()` - Zone monitoring
- `CheckClientPositions()` - Check client positions in zones
- `StartClientCheckTimer()` / `StopClientCheckTimer()` - Position monitoring

**Exports:** `RangeTimers` module with public API functions

### 7. `range_targets.lua`
Target and defense spawning system:
- `InitializeSpawnTemplates()` - Initialize MOOSE SPAWN templates
- `InitializeZones()` - Initialize zone objects
- `ActivateTargets(moduleType)` - Spawn targets for selected module
- `DeactivateAllTargets()` - Destroy all active target groups
- `ActivateDefenses(defenseLevel)` - Spawn defenses for selected level
- `DeactivateAllDefenses()` - Destroy all active defense groups

**Exports:** `RangeTargets` module with public API functions

### 8. `range_fsm.lua`
Finite State Machine orchestration:

**States:**
- `INIT` - Initialization state
- `GREEN` - Safe/Reset state (range inactive)
- `HOT` - Range active, waiting for pilots
- `OCCUPIED` - Client attacking on range
- `ABORT` - Emergency abort state

**Transitions:**
- INIT → Initialize → GREEN
- GREEN → GoHot → HOT
- HOT → ClientEntersRun → OCCUPIED
- HOT/OCCUPIED → Reset → GREEN
- OCCUPIED → EgressWithQueue/EgressNoQueue → HOT
- * → Abort → ABORT
- ABORT → AbortComplete → GREEN

**Event Handlers:**
- `OnEnterINIT()`, `OnEnterGREEN()`, `OnEnterHOT()`, `OnEnterOCCUPIED()`, `OnEnterABORT()`
- `OnAfterEgressWithQueue()`, `OnAfterEgressNoQueue()`

**Functions:**
- `CheckAutoHot()` - Automatically transition to HOT when configured

**Exports:** `RangeFSM_Module` with `init()` and `getFSM()` functions

### 9. `range_menu.lua`
F10 menu system and handlers:
- `CreateRangeMenu()` - Build F10 menu structure
- `MenuCheckIn()` - Handle CHECK-IN request
- `MenuCheckOut()` - Handle CHECK-OUT request
- `MenuSelectModule(moduleType)` - Select training module
- `MenuSelectDefense(defenseLevel)` - Select defense level
- `MenuSetGreen()` - Reset range to GREEN
- `MenuShowStatus()` - Display range status
- `MenuEmergencyAbort()` - Emergency abort
- `ClientCallEgress()` - Pilot egress from range
- `GetRangeStatusString()` - Generate status report

**Exports:** `RangeMenu` module with public API functions

### 10. `range_sections.lua`
Placeholder for future "Set Section" feature:
- `CreateSection()` - Create a section (placeholder)
- `UpdateSection()` - Update section (placeholder)
- `ScanMembers()` - Scan section members (placeholder)
- `IsLeader(pilotName)` - Check if pilot is section leader (placeholder)
- `IsMember(pilotName)` - Check if pilot is section member (placeholder)
- `DissolveSection()` - Dissolve section (placeholder)

**Exports:** `RangeSections` module with placeholder functions

## Architecture

### Dependency Injection Pattern

The system uses dependency injection to avoid circular dependencies:

1. Modules are loaded via `require()`
2. Each module has an `init()` function that receives its dependencies
3. Cross-module references (like FSM) are injected via `setFSM()` functions
4. Modules expose public APIs and keep internal functions private (local)

### Module Initialization Order

```lua
1. Load all module files
2. Initialize RangeState
3. Initialize core modules (Pilots, Messages, Stack)
4. Initialize system modules (Timers, Targets, Menu)
5. Initialize FSM (depends on all others)
6. Inject FSM references back to Timers and Menu
7. Initialize zones and spawn templates
8. Create menus
9. Start the range FSM
```

## Features

### CHECK-IN/CHECK-OUT System (V10)
- Pilots must CHECK-IN before using the range
- Auto-checkout after 3 minutes outside training area
- Messages filtered to registered pilots only
- ABORT messages broadcast to all in training area

### Holding Stack System
- Multi-tier FL-based holding pattern (FL160+)
- Automatic stack assignment on CHECK-IN
- Altitude monitoring with warnings
- Stack shifting when pilots depart

### Training Modules
- Static Bombing
- Convoy
- Pop-Up Targets
- Urban Targets

### Defense Levels
- None
- Low (basic defenses)
- Medium
- High (advanced defenses)

### Safety Features
- Emergency ABORT function
- Range state validation
- Zone-based access control
- Client position monitoring

## Improvements Over Original

1. **Modular Structure** - Separated concerns into logical modules
2. **Consolidated Duplicates** - Removed duplicate function definitions
3. **Dependency Injection** - Clean module dependencies, no circular refs
4. **Better Maintainability** - Each module has a clear responsibility
5. **Extensibility** - Easy to add new features in isolated modules
6. **Type Safety** - Clear public APIs for each module

## Usage

### For Mission Designers

Use `range.lua` as the main script in your DCS mission. The system will:
1. Initialize all zones (HOLD, IP, AREA, TRAINING_AREA)
2. Set up spawn templates for targets and defenses
3. Create the F10 menu system
4. Start the range in INIT state

### For Developers

To add new features:
1. Create a new module in `modules/` directory
2. Follow the existing pattern: `init()` function for dependencies
3. Export public API functions
4. Wire dependencies in `range.lua`
5. Keep internal functions `local`

## Requirements

- DCS World
- MOOSE Framework (https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/index.html)
- Properly configured mission with required zones and groups

## Zone Configuration

Required zones in mission editor:
- `RANGE_ZONE_HOLD` - Holding pattern area
- `RANGE_ZONE_IP` - Initial Point zone
- `RANGE_ZONE_AREA` - Target area zone
- `RANGE_ZONE_TRAINING_AREA` - Overall training area (V10)

Required group prefixes:
- `RANGE_TGT_STATIC_*` - Static targets
- `RANGE_TGT_CONVOY_*` - Convoy targets
- `RANGE_TGT_POPUP_*` - Pop-up targets
- `RANGE_TGT_URBAN_*` - Urban targets
- `RANGE_DEF_LOW_*` - Low level defenses
- `RANGE_DEF_MED_*` - Medium level defenses
- `RANGE_DEF_HIGH_*` - High level defenses

## License

[Add your license information here]

## Credits

**Original Author:** Donkey (Lukino811)
**Version:** 10 (Modular Refactor)
