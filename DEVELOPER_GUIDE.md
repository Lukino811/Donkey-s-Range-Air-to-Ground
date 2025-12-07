# Developer Guide

## Quick Start for Developers

This guide helps developers understand and work with the modular range system.

## Module Quick Reference

### Dependencies Flow

```
range.lua (bootstrapper)
    ↓
┌───────────────────────────────────────────────────┐
│ Load Modules                                      │
├───────────────────────────────────────────────────┤
│ RangeConfig     (no dependencies)                 │
│ RangeState      (config)                          │
│ RangePilots     (config, state, stack)            │
│ RangeMessages   (config, state, pilots)           │
│ RangeStack      (config, state, pilots, messages) │
│ RangeTimers     (config, state, zones, pilots,   │
│                  messages, stack, fsm*)           │
│ RangeTargets    (config, state, zones, messages)  │
│ RangeFSM        (config, state, pilots, messages, │
│                  stack, timers, targets)          │
│ RangeMenu       (config, state, zones, pilots,    │
│                  messages, stack, fsm*)           │
│ RangeSections   (config, state)                   │
└───────────────────────────────────────────────────┘
    * = injected after FSM creation
```

## Common Development Tasks

### Adding a New Message

1. **Add to config:**
```lua
-- modules/range_config.lua
Messages = {
    -- ...existing messages...
    NEW_MESSAGE = {
        text = "Your message text here",
        sound = "sound_file.ogg"  -- or nil
    }
}
```

2. **Use in code:**
```lua
-- Any module with RangeMessages dependency
RangeMessages.SendMessageToRegistered("NEW_MESSAGE", 10, "extra text")
```

### Adding a New Timer Check

1. **Add check function:**
```lua
-- modules/range_timers.lua
function RangeTimers.CheckNewThing()
    -- Your periodic check logic
    if condition then
        -- Do something
    end
end
```

2. **Add start/stop functions:**
```lua
function RangeTimers.StartNewCheckTimer()
    if RangeState.NewCheckTimer then
        RangeState.NewCheckTimer:Stop()
    end
    
    RangeState.NewCheckTimer = TIMER:New(function()
        RangeTimers.CheckNewThing()
    end):Start(5, interval)
end

function RangeTimers.StopNewCheckTimer()
    if RangeState.NewCheckTimer then
        RangeState.NewCheckTimer:Stop()
        RangeState.NewCheckTimer = nil
    end
end
```

3. **Call in FSM handlers:**
```lua
-- modules/range_fsm.lua in OnEnterHOT
RangeTimers.StartNewCheckTimer()

-- in OnEnterGREEN/OnEnterABORT
RangeTimers.StopNewCheckTimer()
```

### Adding a New Training Module

1. **Add to config:**
```lua
-- modules/range_config.lua
TrainingModules = {
    -- ...existing...
    NEW_MODULE = "New Module Name"
},

GroupPrefixes = {
    -- ...existing...
    TARGET_NEW = "RANGE_TGT_NEW"
}
```

2. **Add to lookup map:**
```lua
-- modules/range_config.lua
ModuleToPrefixMap = {
    -- ...existing...
    [RangeConfig.RANGE.TrainingModules.NEW_MODULE] = RangeConfig.RANGE.GroupPrefixes.TARGET_NEW
}
```

3. **Add to menu:**
```lua
-- modules/range_menu.lua in CreateRangeMenu()
MENU_MISSION_COMMAND:New("New Module", moduleMenu, RangeMenu.MenuSelectModule, RANGE.TrainingModules.NEW_MODULE)
```

4. **Create groups in mission editor:**
- Name them: `RANGE_TGT_NEW_1`, `RANGE_TGT_NEW_2`, etc.

### Adding a New State to FSM

1. **Add transition:**
```lua
-- modules/range_fsm.lua in init()
RangeFSM:AddTransition("EXISTINGSTATE", "NewEvent", "NEWSTATE")
```

2. **Add event handler:**
```lua
-- modules/range_fsm.lua
function RangeFSM_Module.OnEnterNEWSTATE()
    -- Your state entry logic
    env.info(RANGE.Name .. " FSM: Entered NEWSTATE")
    
    -- Call other module APIs as needed
    RangeMessages.SendBroadcastToTrainingArea("SOME_MESSAGE", 15)
end
```

3. **Bind handler:**
```lua
-- modules/range_fsm.lua in init()
RangeFSM.OnEnterNEWSTATE = RangeFSM_Module.OnEnterNEWSTATE
```

### Adding a New Menu Command

1. **Add handler function:**
```lua
-- modules/range_menu.lua
function RangeMenu.MenuNewCommand()
    env.info(RANGE.Name .. " Menu: New command requested")
    
    -- Your logic here
    -- Can access: RangeFSM, RangeState, RangeMessages, etc.
end
```

2. **Add to menu:**
```lua
-- modules/range_menu.lua in CreateRangeMenu()
MENU_MISSION_COMMAND:New("New Command", mainMenu, RangeMenu.MenuNewCommand)
```

## Module API Reference

### RangeConfig

**Exports:** Configuration table
```lua
RangeConfig.RANGE              -- Main configuration
RangeConfig.ModuleToPrefixMap  -- Module → Group prefix mapping
RangeConfig.DefenseToPrefixMap -- Defense level → Group prefixes mapping
```

**No functions, pure data.**

### RangeState

**Exports:** State management
```lua
RangeState.init(config)        -- Initialize state with config
RangeState.State               -- Runtime state table
RangeState.Zones               -- Zone objects table
RangeState.SpawnTemplates      -- Spawn template tables
```

### RangePilots

**Exports:** Pilot registration API
```lua
RangePilots.init(config, state, stack)
RangePilots.RegisterPilot(pilotName) → boolean
RangePilots.UnregisterPilot(pilotName) → boolean
RangePilots.IsPilotRegistered(pilotName) → boolean
RangePilots.GetRegisteredCount() → number
RangePilots.GetRegisteredPilotsList() → table
RangePilots.ClearAllRegistrations()
RangePilots.ForEachRegisteredClient(actionFunc)
RangePilots.ForEachClientInTrainingArea(actionFunc)
```

### RangeMessages

**Exports:** Messaging and audio API
```lua
RangeMessages.init(config, state, pilots)
RangeMessages.PlaySoundToRegistered(soundFile)
RangeMessages.PlaySoundToTrainingArea(soundFile)
RangeMessages.PlaySoundToGroup(soundFile, group)
RangeMessages.PlaySoundDirect(soundFile)
RangeMessages.SendMessageToRegistered(messageKey, duration, extraText)
RangeMessages.SendBroadcastToTrainingArea(messageKey, duration, extraText)
RangeMessages.SendMessageToAll(messageKey, duration, extraText)
RangeMessages.SendMessageToGroup(messageKey, group, duration, extraText, prefix)
RangeMessages.SendComposedMessageToAll(prefix, messageKey, extraText, duration)
```

### RangeStack

**Exports:** Stack management API
```lua
RangeStack.init(config, state, pilots, messages)
RangeStack.GetStackFL(stackNum) → number
RangeStack.GetStackAltitudeFt(stackNum) → number
RangeStack.GetHoldingCount() → number
RangeStack.GetFirstFreeStack() → number|nil
RangeStack.IsPilotInHolding(pilotName) → boolean
RangeStack.GetPilotStack(pilotName) → number|nil
RangeStack.GetNextPilotInStack() → string|nil
RangeStack.AddPilotToStack(pilotName, callerGroup) → boolean
RangeStack.RemovePilotFromStack(pilotName) → boolean|number
RangeStack.ShiftStacksDown()
RangeStack.ClearAllStacks()
RangeStack.NotifyNextPilotInStack()
```

### RangeTimers

**Exports:** Timer and check API
```lua
RangeTimers.init(config, state, zones, pilots, messages, stack)
RangeTimers.setFSM(fsm)  -- Called after FSM creation
RangeTimers.CheckHoldingAltitudes()
RangeTimers.StartAltitudeCheckTimer()
RangeTimers.StopAltitudeCheckTimer()
RangeTimers.CheckTrainingAreaPresence()
RangeTimers.StartZoneCheckTimer()
RangeTimers.StopZoneCheckTimer()
RangeTimers.CheckClientPositions()
RangeTimers.StartClientCheckTimer()
RangeTimers.StopClientCheckTimer()
```

### RangeTargets

**Exports:** Target/defense spawn API
```lua
RangeTargets.init(config, state, zones, messages)
RangeTargets.InitializeSpawnTemplates()
RangeTargets.InitializeZones() → boolean
RangeTargets.ActivateTargets(moduleType)
RangeTargets.DeactivateAllTargets()
RangeTargets.ActivateDefenses(defenseLevel)
RangeTargets.DeactivateAllDefenses()
```

### RangeFSM_Module

**Exports:** FSM creation and management
```lua
RangeFSM_Module.init(config, state, pilots, messages, stack, timers, targets) → FSM
RangeFSM_Module.CheckAutoHot()
RangeFSM_Module.getFSM() → FSM
-- Event handlers (internal, bound to FSM):
RangeFSM_Module.OnEnterINIT()
RangeFSM_Module.OnEnterGREEN()
RangeFSM_Module.OnEnterHOT()
RangeFSM_Module.OnEnterOCCUPIED()
RangeFSM_Module.OnEnterABORT()
RangeFSM_Module.OnAfterEgressWithQueue()
RangeFSM_Module.OnAfterEgressNoQueue()
```

### RangeMenu

**Exports:** Menu and handler API
```lua
RangeMenu.init(config, state, zones, pilots, messages, stack)
RangeMenu.setFSM(fsm, checkAutoHotFunc)  -- Called after FSM creation
RangeMenu.CreateRangeMenu()
RangeMenu.MenuCheckIn()
RangeMenu.MenuCheckOut()
RangeMenu.MenuSelectModule(moduleType)
RangeMenu.MenuSelectDefense(defenseLevel)
RangeMenu.MenuSetGreen()
RangeMenu.MenuShowStatus()
RangeMenu.MenuEmergencyAbort()
RangeMenu.ClientCallEgress()
RangeMenu.GetRangeStatusString() → string
```

### RangeSections

**Exports:** Section management API (placeholder)
```lua
RangeSections.init(config, state)
RangeSections.CreateSection()
RangeSections.UpdateSection()
RangeSections.ScanMembers() → table
RangeSections.IsLeader(pilotName) → boolean
RangeSections.IsMember(pilotName) → boolean
RangeSections.DissolveSection()
```

## Debugging Tips

### Enable Detailed Logging

Check DCS log file at: `Saved Games\DCS\Logs\dcs.log`

All modules use `env.info()` for logging with consistent prefixes:
```
DONKEY'S RANGE: [message]
```

### Common Issues

**Issue:** Module not found error
```
Solution: Ensure modules/ directory is in correct location relative to range.lua
```

**Issue:** Function not available
```
Solution: Check module is properly initialized and function is in public API
```

**Issue:** State not updating
```
Solution: Verify module has RangeState dependency injected via init()
```

**Issue:** FSM transitions not working
```
Solution: Check FSM:GetState() and verify transition is defined
```

### Testing Individual Modules

Since modules use dependency injection, you can test them in isolation:

```lua
-- Test range_config.lua
local config = require("modules.range_config")
assert(config.RANGE.Name == "DONKEY'S RANGE")
assert(config.RANGE.TrainingModules.STATIC_BOMBING == "Static Bombing")

-- Test range_stack.lua (requires mocking)
local stack = require("modules.range_stack")
local mockConfig = { RANGE = { Stack = { BaseFL = 160, Separation = 10 } } }
local mockState = { State = { HoldingStack = {}, PilotStack = {} } }
stack.init(mockConfig, mockState, mockPilots, mockMessages)
assert(stack.GetStackFL(1) == 160)
assert(stack.GetStackFL(2) == 170)
```

## Best Practices

### 1. Always Use Dependency Injection
```lua
-- GOOD
function MyModule.init(config, state, otherModule)
    RANGE = config.RANGE
    RangeState = state.State
    OtherModule = otherModule
end

-- BAD (circular dependency)
local OtherModule = require("modules.other_module")
```

### 2. Keep Internal Functions Local
```lua
-- GOOD
local function internalHelper()
    -- Private implementation
end

function MyModule.PublicFunction()
    internalHelper()
end

-- BAD (pollutes global namespace)
function InternalHelper()
    -- Should be local
end
```

### 3. Document Module APIs
```lua
-- At top of module file
-- =============================================================================
-- MODULE_NAME
-- Brief description of module purpose
-- =============================================================================
```

### 4. Use Consistent Naming
- Modules: `RangeXxx` (PascalCase)
- Functions: `FunctionName` (PascalCase)
- Variables: `variableName` (camelCase)
- Constants: `CONSTANT_NAME` (UPPER_SNAKE_CASE)

### 5. Handle Errors Gracefully
```lua
function MyModule.DoSomething(param)
    if not param then
        env.info(RANGE.Name .. ": DoSomething - no param provided")
        return nil
    end
    
    -- Implementation
end
```

## Contributing

When adding features:

1. Determine which module(s) to modify
2. Update module's `init()` if new dependencies needed
3. Add functions to module's public API
4. Update wiring in `range.lua` if new module
5. Document changes in module header comments
6. Test integration with existing modules
7. Update README.md and this guide

## Performance Considerations

### Timer Intervals

Default intervals (can be adjusted in config):
- Client position check: 10 seconds
- Altitude check: 10 seconds
- Zone check (auto-checkout): 10 seconds

Increasing intervals reduces CPU usage but decreases responsiveness.

### Sound Queue

The system queues sounds with 8-second delays to prevent audio overlap. This is managed in `RangeMessages.PlaySoundToRegistered()`.

### Spawn Template Caching

Spawn templates are initialized once at startup and reused for all spawns, improving performance over repeated `SPAWN:New()` calls.

## Further Reading

- **README.md** - Overview and features
- **MIGRATION_GUIDE.md** - Line-by-line mapping from original
- **MOOSE Documentation** - https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/index.html
