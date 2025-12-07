-- =============================================================================
-- DCS MOOSE AIR-TO-GROUND TRAINING RANGE
-- DONKEY'S RANGE - VERSIONE 10 (MODULAR)
-- Sistema CHECK-IN/CHECK-OUT esplicito + messaggi filtrati
-- =============================================================================

-- Load all modules
local RangeConfig = require("modules.range_config")
local RangeState = require("modules.range_state")
local RangePilots = require("modules.range_pilots")
local RangeMessages = require("modules.range_messages")
local RangeStack = require("modules.range_stack")
local RangeTimers = require("modules.range_timers")
local RangeTargets = require("modules.range_targets")
local RangeFSM_Module = require("modules.range_fsm")
local RangeMenu = require("modules.range_menu")
local RangeSections = require("modules.range_sections")

-- Initialize configuration and state
RangeState.init(RangeConfig)

-- Store zones reference for pilots module
RangeState.State._zones = RangeState.Zones

-- Initialize modules with dependencies (dependency injection pattern)
RangePilots.init(RangeConfig, RangeState, RangeStack)
RangeMessages.init(RangeConfig, RangeState, RangePilots)
RangeStack.init(RangeConfig, RangeState, RangePilots, RangeMessages)
RangeTimers.init(RangeConfig, RangeState, RangeState.Zones, RangePilots, RangeMessages, RangeStack)
RangeTargets.init(RangeConfig, RangeState, RangeState.Zones, RangeMessages)
RangeMenu.init(RangeConfig, RangeState, RangeState.Zones, RangePilots, RangeMessages, RangeStack)
RangeSections.init(RangeConfig, RangeState)

-- Initialize FSM (depends on most other modules)
local RangeFSM = RangeFSM_Module.init(RangeConfig, RangeState, RangePilots, RangeMessages, RangeStack, RangeTimers, RangeTargets)

-- Inject FSM reference back to modules that need it
RangeTimers.setFSM(RangeFSM)
RangeMenu.setFSM(RangeFSM)

-- Export global references for compatibility
RANGE = RangeConfig.RANGE
RangeState_Global = RangeState.State
RangeZones = RangeState.Zones
SpawnTemplates = RangeState.SpawnTemplates

-- Initialize zones and spawn templates
function InitializeRange()
    env.info(RangeConfig.RANGE.Name .. ": Starting initialization V10 (modular)...")
    
    RangeTargets.InitializeZones()
    RangeTargets.InitializeSpawnTemplates()
    RangeMenu.CreateRangeMenu()
    
    -- V10: Avviso se Training Area manca
    if not RangeState.State.TrainingAreaAvailable then
        MESSAGE:New(RangeConfig.RANGE.Name .. ": " .. RangeConfig.RANGE.Messages.TRAINING_AREA_MISSING.text, 15):ToAll()
        env.info(RangeConfig.RANGE.Name .. ": WARNING - Training Area not configured, check-in available everywhere")
    end
    
    RangeFSM:Initialize()
    
    env.info(RangeConfig.RANGE.Name .. ": Initialization complete V10 (modular), current state: " .. RangeFSM:GetState())
end

-- Start the range
TIMER:New(function()
    InitializeRange()
end):Start(1)

-- =============================================================================
-- FINE DONKEY'S RANGE V10 (MODULAR)
-- =============================================================================
