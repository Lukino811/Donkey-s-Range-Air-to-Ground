-- =============================================================================
-- RANGE STATE MODULE
-- Runtime state tables and initialization
-- =============================================================================

local RangeState = {}

-- Module will be initialized with config
local RANGE = nil

function RangeState.init(config)
    RANGE = config.RANGE
    
    -- Initialize state tables
    RangeState.State = {
        SelectedModule = RANGE.TrainingModules.NONE,
        SelectedDefense = RANGE.DefenseLevels.NONE,
        
        HoldingStack = {},
        PilotStack = {},
        
        ActiveClient = nil,
        ActiveClientEnteredArea = false,
        CanReattackDirectly = nil,
        
        AbortTimer = nil,
        ClientCheckTimer = nil,
        AltitudeCheckTimer = nil,
        ZoneCheckTimer = nil,           -- V10: Timer per controllo zona training
        
        ActiveTargetGroups = {},
        ActiveDefenseGroups = {},
        
        -- Sistema coda audio
        NextSoundTime = 0,
        
        -- Cooldown warning altitudine
        AltitudeWarningCooldown = {},
        
        -- V10: Cooldown messaggio hold not registered
        HoldNotRegisteredCooldown = {},
        
        -- V10: Sistema CHECK-IN/CHECK-OUT
        RegisteredPilots = {},          -- [pilotName] = true/nil
        CheckoutTimers = {},            -- [pilotName] = timestamp prima uscita zona
        TrainingAreaAvailable = false   -- Flag se zona training esiste
    }
    
    -- Initialize holding stack
    for i = 1, RANGE.Stack.MaxStacks do
        RangeState.State.HoldingStack[i] = nil
    end
    
    -- Zone objects
    RangeState.Zones = {
        HOLD = nil,
        IP = nil,
        AREA = nil,
        TRAINING_AREA = nil  -- V10: Zona training area
    }
    
    -- Spawn templates
    RangeState.SpawnTemplates = {
        Targets = {},
        Defenses = {}
    }
end

return RangeState
