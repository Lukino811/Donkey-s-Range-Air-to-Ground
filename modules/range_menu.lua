-- =============================================================================
-- RANGE MENU MODULE
-- F10 menu creation and handlers
-- =============================================================================

local RangeMenu = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangeZones = nil
local RangePilots = nil
local RangeMessages = nil
local RangeStack = nil
local RangeFSM = nil

function RangeMenu.init(config, state, zones, pilots, messages, stack)
    RANGE = config.RANGE
    RangeState = state.State
    RangeZones = zones
    RangePilots = pilots
    RangeMessages = messages
    RangeStack = stack
end

-- Inject FSM reference after FSM module is created
function RangeMenu.setFSM(fsm)
    RangeFSM = fsm
end

-- Menu Handlers

function RangeMenu.MenuCheckIn()
    -- Trova il client che ha chiamato il menu
    local callerName = nil
    local callerGroup = nil
    local callerUnit = nil
    
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() and callerName == nil then
            callerName = client:GetPlayerName()
            callerGroup = client:GetGroup()
            callerUnit = client:GetClientGroupUnit()
        end
    end)
    
    if not callerName then
        env.info(RANGE.Name .. ": CHECK-IN called but no client found")
        return
    end
    
    env.info(RANGE.Name .. ": CHECK-IN requested by " .. callerName)
    
    -- Verifica se già registrato
    if RangePilots.IsPilotRegistered(callerName) then
        if callerGroup then
            RangeMessages.SendMessageToGroup("CHECKIN_ALREADY", callerGroup, 10, nil, callerName)
        end
        env.info(RANGE.Name .. ": " .. callerName .. " already registered")
        return
    end
    
    -- V10: Verifica se nella Training Area (se esiste)
    if RangeState.TrainingAreaAvailable and callerUnit then
        local inTrainingArea = RangeZones.TRAINING_AREA and callerUnit:IsInZone(RangeZones.TRAINING_AREA)
        
        if not inTrainingArea then
            if callerGroup then
                RangeMessages.SendMessageToGroup("CHECKIN_OUTSIDE_ZONE", callerGroup, 10, nil, callerName)
            end
            env.info(RANGE.Name .. ": " .. callerName .. " tried to check-in from outside training area")
            return
        end
    else
        -- Training area non configurata - check-in disponibile ovunque
        if not RangeState.TrainingAreaAvailable then
            env.info(RANGE.Name .. ": Training area not available, allowing check-in from anywhere")
        end
    end
    
    -- Registra il pilota
    if RangePilots.RegisterPilot(callerName) then
        if callerGroup then
            RangeMessages.SendMessageToGroup("CHECKIN_SUCCESS", callerGroup, 10, nil, callerName)
        end
        
        -- V10: Aggiungi automaticamente allo stack se il range è HOT o OCCUPIED
        local currentState = RangeFSM:GetState()
        if currentState == "HOT" or currentState == "OCCUPIED" then
            TIMER:New(function()
                if RangePilots.IsPilotRegistered(callerName) and not RangeStack.IsPilotInHolding(callerName) then
                    RangeStack.AddPilotToStack(callerName, callerGroup)
                end
            end):Start(2)
        end
        
        -- Notifica agli altri registrati
        local newPilot = callerName
        RangePilots.ForEachRegisteredClient(function(client)
            local clientName = client:GetPlayerName()
            if clientName and clientName ~= newPilot then
                local group = client:GetGroup()
                if group then
                    MESSAGE:New(RANGE.Name .. ": " .. newPilot .. " si e' registrato al range", 5):ToGroup(group)
                end
            end
        end)
    end
end

function RangeMenu.MenuCheckOut()
    -- Trova il client che ha chiamato il menu
    local callerName = nil
    local callerGroup = nil
    
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() and callerName == nil then
            callerName = client:GetPlayerName()
            callerGroup = client:GetGroup()
        end
    end)
    
    if not callerName then
        env.info(RANGE.Name .. ": CHECK-OUT called but no client found")
        return
    end
    
    env.info(RANGE.Name .. ": CHECK-OUT requested by " .. callerName)
    
    -- Verifica se registrato
    if not RangePilots.IsPilotRegistered(callerName) then
        if callerGroup then
            RangeMessages.SendMessageToGroup("CHECKOUT_NOT_REGISTERED", callerGroup, 10, nil, callerName)
        end
        env.info(RANGE.Name .. ": " .. callerName .. " not registered, cannot check-out")
        return
    end
    
    -- Handle active client egress before unregister
    if RangeState.ActiveClient == callerName then
        local currentState = RangeFSM:GetState()
        if currentState == "OCCUPIED" then
            if RangeStack.GetHoldingCount() > 0 then
                RangeFSM:EgressWithQueue()
            else
                RangeFSM:EgressNoQueue()
            end
        end
    end
    
    -- Deregistra il pilota
    if RangePilots.UnregisterPilot(callerName) then
        if callerGroup then
            RangeMessages.SendMessageToGroup("CHECKOUT_SUCCESS", callerGroup, 10, nil, callerName)
        end
        
        -- V10 FIX: Notifica agli altri registrati usando ForEachRegisteredClient
        local leavingPilot = callerName  -- Salva per la closure
        RangePilots.ForEachRegisteredClient(function(client)
            local clientName = client:GetPlayerName()
            if clientName and clientName ~= leavingPilot then
                local group = client:GetGroup()
                if group then
                    MESSAGE:New(RANGE.Name .. ": " .. leavingPilot .. " ha lasciato il range", 5):ToGroup(group)
                end
            end
        end)
    end
end

function RangeMenu.MenuSelectModule(moduleType)
    local currentState = RangeFSM:GetState()
    local previousModule = RangeState.SelectedModule
    
    if currentState == "HOT" and previousModule ~= moduleType then
        env.info(RANGE.Name .. " Menu: Module change while HOT - forcing reset")
        RangeMessages.SendBroadcastToTrainingArea("CONFIG_CHANGE_HOT", 5)
        RangeState.SelectedModule = moduleType
        RangeFSM:Reset()
        return
    end
    
    RangeState.SelectedModule = moduleType
    env.info(RANGE.Name .. " Menu: Module selected: " .. moduleType)
    
    -- V10: Config message broadcast
    MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.CONFIG_MODULE.text .. " " .. moduleType, 10):ToAll()
    
    -- Import CheckAutoHot from FSM module
    local RangeFSM_Module = require("modules.range_fsm")
    RangeFSM_Module.CheckAutoHot()
end

function RangeMenu.MenuSelectDefense(defenseLevel)
    local currentState = RangeFSM:GetState()
    local previousDefense = RangeState.SelectedDefense
    
    if currentState == "HOT" and previousDefense ~= defenseLevel then
        env.info(RANGE.Name .. " Menu: Defense change while HOT - forcing reset")
        RangeMessages.SendBroadcastToTrainingArea("CONFIG_CHANGE_HOT", 5)
        RangeState.SelectedDefense = defenseLevel
        RangeFSM:Reset()
        return
    end
    
    RangeState.SelectedDefense = defenseLevel
    env.info(RANGE.Name .. " Menu: Defense selected: " .. defenseLevel)
    
    -- V10: Config message broadcast
    MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.CONFIG_DEFENSE.text .. " " .. defenseLevel, 10):ToAll()
    
    -- Import CheckAutoHot from FSM module
    local RangeFSM_Module = require("modules.range_fsm")
    RangeFSM_Module.CheckAutoHot()
end

function RangeMenu.MenuSetGreen()
    env.info(RANGE.Name .. " Menu: SET GREEN requested")
    
    RangeState.SelectedModule = RANGE.TrainingModules.NONE
    RangeState.SelectedDefense = RANGE.DefenseLevels.NONE
    
    local currentState = RangeFSM:GetState()
    
    if currentState ~= "GREEN" and currentState ~= "INIT" then
        RangeMessages.SendBroadcastToTrainingArea("CONFIG_RESET", 5)
        RangeFSM:Reset()
    else
        MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.CONFIG_ALREADY_GREEN.text, 5):ToAll()
    end
end

function RangeMenu.MenuShowStatus()
    local status = RangeMenu.GetRangeStatusString()
    env.info(RANGE.Name .. " Menu: Status requested")
    MESSAGE:New(status, 20):ToAll()
end

function RangeMenu.MenuEmergencyAbort()
    env.info(RANGE.Name .. " Menu: EMERGENCY ABORT requested")
    RangeFSM:Abort()
end

function RangeMenu.ClientCallEgress()
    local currentState = RangeFSM:GetState()
    
    local callerName = nil
    local callerGroup = nil
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() and callerName == nil then
            callerName = client:GetPlayerName()
            callerGroup = client:GetGroup()
        end
    end)
    
    if not callerName then
        env.info(RANGE.Name .. ": EGRESS called but no client found")
        return
    end
    
    env.info(RANGE.Name .. ": EGRESS called by " .. callerName)
    
    if currentState ~= "OCCUPIED" then
        RangeMessages.SendMessageToGroup("EGRESS_NOT_OCCUPIED", callerGroup, 10, nil, callerName)
        env.info(RANGE.Name .. ": EGRESS rejected - range not occupied")
        return
    end
    
    if RangeState.ActiveClient ~= callerName then
        RangeMessages.SendMessageToGroup("EGRESS_WRONG", callerGroup, 10, nil, callerName)
        env.info(RANGE.Name .. ": EGRESS rejected - " .. callerName .. " is not the active client")
        return
    end
    
    env.info(RANGE.Name .. ": EGRESS accepted from " .. callerName)
    RangeMessages.SendComposedMessageToAll(callerName, "EGRESS_SUCCESS", nil, 10)
    
    local previousClient = RangeState.ActiveClient
    
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    
    if RangeStack.GetHoldingCount() > 0 then
        TIMER:New(function()
            RangeMessages.SendComposedMessageToAll(previousClient, "EGRESS_BACK_TO_HOLD", nil, 10)
        end):Start(6)
        RangeState.CanReattackDirectly = nil
        RangeFSM:EgressWithQueue()
    else
        TIMER:New(function()
            RangeMessages.SendComposedMessageToAll(previousClient, "EGRESS_REATTACK", nil, 10)
        end):Start(6)
        RangeState.CanReattackDirectly = previousClient
        RangeFSM:EgressNoQueue()
    end
end

-- Utility

function RangeMenu.GetRangeStatusString()
    local status = "====== " .. RANGE.Name .. " STATUS ======\n"
    status = status .. "Stato: " .. RangeFSM:GetState() .. "\n"
    status = status .. "Modulo: " .. RangeState.SelectedModule .. "\n"
    status = status .. "Difese: " .. RangeState.SelectedDefense .. "\n"
    status = status .. "Target attivi: " .. #RangeState.ActiveTargetGroups .. "\n"
    status = status .. "Difese attive: " .. #RangeState.ActiveDefenseGroups .. "\n"
    
    -- V10: Sezione piloti registrati
    local registeredCount = RangePilots.GetRegisteredCount()
    status = status .. "Piloti registrati: " .. registeredCount .. "\n"
    
    if registeredCount > 0 then
        status = status .. "--- REGISTRAZIONI ---\n"
        for pilotName, _ in pairs(RangeState.RegisteredPilots) do
            local pilotStatus = "in attesa"
            local stackNum = RangeStack.GetPilotStack(pilotName)
            
            if pilotName == RangeState.ActiveClient then
                pilotStatus = "ATTIVO sul target"
            elseif stackNum then
                local fl = RangeStack.GetStackFL(stackNum)
                pilotStatus = "Stack " .. stackNum .. ", FL" .. fl
            elseif pilotName == RangeState.CanReattackDirectly then
                pilotStatus = "reattack autorizzato"
            end
            
            status = status .. "  - " .. pilotName .. " (" .. pilotStatus .. ")\n"
        end
    end
    
    local holdingCount = RangeStack.GetHoldingCount()
    status = status .. "Piloti in HOLD: " .. holdingCount .. "/" .. RANGE.Stack.MaxStacks .. "\n"
    
    if holdingCount > 0 then
        status = status .. "--- STACK HOLDING ---\n"
        for i = 1, RANGE.Stack.MaxStacks do
            local pilot = RangeState.HoldingStack[i]
            if pilot then
                local fl = RangeStack.GetStackFL(i)
                status = status .. "  Stack " .. i .. " (FL" .. fl .. "): " .. pilot .. "\n"
            end
        end
    end
    
    status = status .. "Pilota attivo: " .. (RangeState.ActiveClient or "Nessuno") .. "\n"
    
    if RangeState.ActiveClient then
        status = status .. "Nell'area target: " .. (RangeState.ActiveClientEnteredArea and "Si" or "No") .. "\n"
    end
    
    if RangeState.CanReattackDirectly then
        status = status .. "Reattack autorizzato: " .. RangeState.CanReattackDirectly .. "\n"
    end
    
    -- V10: Training Area status
    status = status .. "Training Area: " .. (RangeState.TrainingAreaAvailable and "Configurata" or "NON configurata") .. "\n"
    
    status = status .. "================================"
    return status
end

-- Menu Creation

function RangeMenu.CreateRangeMenu()
    env.info(RANGE.Name .. ": Creating F10 menu...")
    
    local mainMenu = MENU_MISSION:New(RANGE.Name)
    
    -- V10: Sottomenu configurazione
    local configMenu = MENU_MISSION:New("CONFIGURA IL RANGE", mainMenu)
    
    local moduleMenu = MENU_MISSION:New("Seleziona Modulo", configMenu)
    MENU_MISSION_COMMAND:New("Static Bombing", moduleMenu, RangeMenu.MenuSelectModule, RANGE.TrainingModules.STATIC_BOMBING)
    MENU_MISSION_COMMAND:New("Convoy", moduleMenu, RangeMenu.MenuSelectModule, RANGE.TrainingModules.CONVOY)
    MENU_MISSION_COMMAND:New("Pop-Up", moduleMenu, RangeMenu.MenuSelectModule, RANGE.TrainingModules.POPUP)
    MENU_MISSION_COMMAND:New("Urban", moduleMenu, RangeMenu.MenuSelectModule, RANGE.TrainingModules.URBAN)
    
    local defenseMenu = MENU_MISSION:New("Seleziona Difese", configMenu)
    MENU_MISSION_COMMAND:New("Nessuna", defenseMenu, RangeMenu.MenuSelectDefense, RANGE.DefenseLevels.NONE)
    MENU_MISSION_COMMAND:New("Basse", defenseMenu, RangeMenu.MenuSelectDefense, RANGE.DefenseLevels.LOW)
    MENU_MISSION_COMMAND:New("Medie", defenseMenu, RangeMenu.MenuSelectDefense, RANGE.DefenseLevels.MEDIUM)
    MENU_MISSION_COMMAND:New("Alte", defenseMenu, RangeMenu.MenuSelectDefense, RANGE.DefenseLevels.HIGH)
    
    -- V10: CHECK-IN / CHECK-OUT
    MENU_MISSION_COMMAND:New(">>> CHECK-IN RANGE <<<", mainMenu, RangeMenu.MenuCheckIn)
    MENU_MISSION_COMMAND:New(">>> CHECK-OUT RANGE <<<", mainMenu, RangeMenu.MenuCheckOut)
    
    -- Egress
    MENU_MISSION_COMMAND:New(">>> CHIAMA EGRESS <<<", mainMenu, RangeMenu.ClientCallEgress)
    
    -- Altre opzioni
    MENU_MISSION_COMMAND:New("RANGE VERDE (Reset)", mainMenu, RangeMenu.MenuSetGreen)
    MENU_MISSION_COMMAND:New("Mostra Stato", mainMenu, RangeMenu.MenuShowStatus)
    MENU_MISSION_COMMAND:New("!!! ABORT EMERGENZA !!!", mainMenu, RangeMenu.MenuEmergencyAbort)
    
    env.info(RANGE.Name .. ": F10 menu created successfully")
end

return RangeMenu
