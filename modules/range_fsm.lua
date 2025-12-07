-- =============================================================================
-- RANGE FSM MODULE
-- Finite State Machine orchestration
-- =============================================================================

local RangeFSM_Module = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangePilots = nil
local RangeMessages = nil
local RangeStack = nil
local RangeTimers = nil
local RangeTargets = nil

-- FSM object
local RangeFSM = nil

function RangeFSM_Module.init(config, state, pilots, messages, stack, timers, targets)
    RANGE = config.RANGE
    RangeState = state.State
    RangePilots = pilots
    RangeMessages = messages
    RangeStack = stack
    RangeTimers = timers
    RangeTargets = targets
    
    -- Create FSM
    RangeFSM = FSM:New()
    RangeFSM:SetStartState("INIT")
    
    -- Define transitions
    RangeFSM:AddTransition("INIT", "Initialize", "GREEN")
    RangeFSM:AddTransition("GREEN", "GoHot", "HOT")
    RangeFSM:AddTransition("HOT", "ClientEntersRun", "OCCUPIED")
    RangeFSM:AddTransition("HOT", "Reset", "GREEN")
    RangeFSM:AddTransition("OCCUPIED", "EgressWithQueue", "HOT")
    RangeFSM:AddTransition("OCCUPIED", "EgressNoQueue", "HOT")
    RangeFSM:AddTransition("OCCUPIED", "Reset", "GREEN")
    RangeFSM:AddTransition("*", "Abort", "ABORT")
    RangeFSM:AddTransition("ABORT", "AbortComplete", "GREEN")
    
    -- Bind event handlers
    RangeFSM.OnEnterINIT = RangeFSM_Module.OnEnterINIT
    RangeFSM.OnEnterGREEN = RangeFSM_Module.OnEnterGREEN
    RangeFSM.OnEnterHOT = RangeFSM_Module.OnEnterHOT
    RangeFSM.OnEnterOCCUPIED = RangeFSM_Module.OnEnterOCCUPIED
    RangeFSM.OnEnterABORT = RangeFSM_Module.OnEnterABORT
    RangeFSM.OnAfterEgressWithQueue = RangeFSM_Module.OnAfterEgressWithQueue
    RangeFSM.OnAfterEgressNoQueue = RangeFSM_Module.OnAfterEgressNoQueue
    
    return RangeFSM
end

-- FSM Event Handlers

function RangeFSM_Module.OnEnterINIT()
    -- V10: INIT message to all (broadcast)
    MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.INIT.text, 10):ToAll()
    env.info(RANGE.Name .. " FSM: Entered INIT state")
end

function RangeFSM_Module.OnEnterGREEN()
    -- V10: GREEN broadcast to training area
    RangeMessages.SendBroadcastToTrainingArea("GREEN", 15)
    env.info(RANGE.Name .. " FSM: Entered GREEN state")
    
    RangeStack.ClearAllStacks()
    RangePilots.ClearAllRegistrations()  -- V10: Pulisci registrazioni
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    RangeState.CanReattackDirectly = nil
    RangeState.NextSoundTime = 0
    RangeState.CheckoutTimers = {}  -- V10: Reset checkout timers
    
    if RangeState.AbortTimer then
        RangeState.AbortTimer:Stop()
        RangeState.AbortTimer = nil
    end
    
    RangeTimers.StopClientCheckTimer()
    RangeTimers.StopAltitudeCheckTimer()
    RangeTimers.StopZoneCheckTimer()  -- V10
    RangeTargets.DeactivateAllTargets()
    RangeTargets.DeactivateAllDefenses()
    
    TIMER:New(function()
        RangeFSM_Module.CheckAutoHot()
    end):Start(1)
end

function RangeFSM_Module.OnEnterHOT()
    RangeMessages.SendBroadcastToTrainingArea("HOT", 15)
    env.info(RANGE.Name .. " FSM: Entered HOT state")
    
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    
    RangeTargets.ActivateTargets(RangeState.SelectedModule)
    RangeTargets.ActivateDefenses(RangeState.SelectedDefense)
    
    RangeTimers.StartClientCheckTimer()
    RangeTimers.StartAltitudeCheckTimer()
    RangeTimers.StartZoneCheckTimer()
    
    -- V10: Assegna stack a tutti i piloti registrati che non sono ancora in holding
    TIMER:New(function()
        for pilotName, _ in pairs(RangeState.RegisteredPilots) do
            if not RangeStack.IsPilotInHolding(pilotName) then
                RangeStack.AddPilotToStack(pilotName, nil)
            end
        end
    end):Start(3)
    
    RangeStack.NotifyNextPilotInStack()
end

function RangeFSM_Module.OnEnterOCCUPIED()
    local clientName = RangeState.ActiveClient or "UNKNOWN"
    
    RangeMessages.PlaySoundToRegistered(RANGE.Messages.OCCUPIED.sound)
    
    -- V10 FIX: Usa ForEachRegisteredClient
    RangePilots.ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.OCCUPIED.text .. " - " .. clientName .. " sul target!", 10):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. " FSM: Entered OCCUPIED state, client: " .. clientName)
end

function RangeFSM_Module.OnEnterABORT()
    -- V10: ABORT broadcast a TUTTI nella training area (anche non registrati)
    RangeMessages.SendBroadcastToTrainingArea("ABORT", 20)
    env.info(RANGE.Name .. " FSM: Entered ABORT state")
    
    RangeStack.ClearAllStacks()
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    RangeState.CanReattackDirectly = nil
    -- V10: NON pulire registrazioni dopo abort
    
    RangeTimers.StopClientCheckTimer()
    RangeTimers.StopAltitudeCheckTimer()
    RangeTimers.StopZoneCheckTimer()  -- V10
    RangeTargets.DeactivateAllTargets()
    RangeTargets.DeactivateAllDefenses()
    
    RangeState.AbortTimer = TIMER:New(function()
        RangeState.SelectedModule = RANGE.TrainingModules.NONE
        RangeState.SelectedDefense = RANGE.DefenseLevels.NONE
        env.info(RANGE.Name .. ": Abort complete, transitioning to GREEN")
        RangeFSM:AbortComplete()
    end):Start(RANGE.Timers.ABORT_TO_GREEN_DELAY)
end

function RangeFSM_Module.OnAfterEgressWithQueue()
    env.info(RANGE.Name .. " FSM: EgressWithQueue - notifying next pilot")
    TIMER:New(function()
        RangeStack.NotifyNextPilotInStack()
    end):Start(8)
end

function RangeFSM_Module.OnAfterEgressNoQueue()
    env.info(RANGE.Name .. " FSM: EgressNoQueue - pilot can reattack directly")
end

-- Auto-HOT Check

function RangeFSM_Module.CheckAutoHot()
    local currentState = RangeFSM:GetState()
    
    env.info(RANGE.Name .. " CheckAutoHot: State=" .. currentState .. 
             ", Module=" .. RangeState.SelectedModule .. 
             ", Defense=" .. RangeState.SelectedDefense)
    
    local hasModule = RangeState.SelectedModule ~= RANGE.TrainingModules.NONE
    local hasDefense = RangeState.SelectedDefense ~= RANGE.DefenseLevels.NONE
    
    if currentState == "GREEN" and (hasModule or hasDefense) then
        env.info(RANGE.Name .. " CheckAutoHot: Conditions MET, transitioning to HOT")
        
        local configMsg = ""
        if hasModule and hasDefense then
            configMsg = "Modulo: " .. RangeState.SelectedModule .. " + Difese: " .. RangeState.SelectedDefense
        elseif hasModule then
            configMsg = "Modulo: " .. RangeState.SelectedModule .. " (Senza difese)"
        else
            configMsg = "Solo difese: " .. RangeState.SelectedDefense .. " (Senza target)"
        end
        
        -- V10: Config complete broadcast a tutti
        MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.CONFIG_COMPLETE.text .. " - " .. configMsg, 5):ToAll()
        RangeFSM:GoHot()
    else
        env.info(RANGE.Name .. " CheckAutoHot: Conditions not met")
    end
end

function RangeFSM_Module.getFSM()
    return RangeFSM
end

return RangeFSM_Module
