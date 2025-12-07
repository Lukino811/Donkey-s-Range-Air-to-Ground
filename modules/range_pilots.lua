-- =============================================================================
-- RANGE PILOTS MODULE
-- Pilot registration system (CHECK-IN/CHECK-OUT)
-- =============================================================================

local RangePilots = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangeStack = nil

function RangePilots.init(config, state, stack)
    RANGE = config.RANGE
    RangeState = state.State
    RangeStack = stack
end

function RangePilots.RegisterPilot(pilotName)
    if not pilotName then return false end
    
    if RangeState.RegisteredPilots[pilotName] then
        env.info(RANGE.Name .. ": " .. pilotName .. " already registered")
        return false
    end
    
    RangeState.RegisteredPilots[pilotName] = true
    RangeState.CheckoutTimers[pilotName] = nil
    
    env.info(RANGE.Name .. ": " .. pilotName .. " checked in to range")
    return true
end

function RangePilots.UnregisterPilot(pilotName)
    if not pilotName then return false end
    
    if not RangeState.RegisteredPilots[pilotName] then
        env.info(RANGE.Name .. ": " .. pilotName .. " not registered, cannot unregister")
        return false
    end
    
    -- Rimuovi da stack se presente
    if RangeStack.IsPilotInHolding(pilotName) then
        local removedStack = RangeStack.RemovePilotFromStack(pilotName)
        if removedStack then
            RangeStack.ShiftStacksDown()
        end
    end
    
    -- Se era il pilota attivo, gestisci egress forzato
    -- This will be handled by the FSM module through callback
    if RangeState.ActiveClient == pilotName then
        RangeState.ActiveClient = nil
        RangeState.ActiveClientEnteredArea = false
    end
    
    RangeState.RegisteredPilots[pilotName] = nil
    RangeState.CheckoutTimers[pilotName] = nil
    RangeState.AltitudeWarningCooldown[pilotName] = nil
    
    -- Pulisci anche reattack se era lui
    if RangeState.CanReattackDirectly == pilotName then
        RangeState.CanReattackDirectly = nil
    end
    
    env.info(RANGE.Name .. ": " .. pilotName .. " checked out from range")
    return true
end

function RangePilots.IsPilotRegistered(pilotName)
    if not pilotName then return false end
    return RangeState.RegisteredPilots[pilotName] == true
end

function RangePilots.GetRegisteredCount()
    local count = 0
    for _ in pairs(RangeState.RegisteredPilots) do
        count = count + 1
    end
    return count
end

function RangePilots.GetRegisteredPilotsList()
    local list = {}
    for pilotName, _ in pairs(RangeState.RegisteredPilots) do
        table.insert(list, pilotName)
    end
    return list
end

function RangePilots.ClearAllRegistrations()
    RangeState.RegisteredPilots = {}
    RangeState.CheckoutTimers = {}
    env.info(RANGE.Name .. ": All registrations cleared")
end

-- V10: Itera sui client registrati e esegue azione
function RangePilots.ForEachRegisteredClient(actionFunc)
    local allClients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    allClients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if clientName and RangePilots.IsPilotRegistered(clientName) then
                actionFunc(client)
            end
        end
    end)
end

-- V10: Itera sui client nella Training Area e esegue azione
function RangePilots.ForEachClientInTrainingArea(actionFunc)
    local RangeZones = RangeState._zones -- Will be injected
    
    if not RangeZones.TRAINING_AREA then
        -- Fallback: tutti i client
        local allClients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
        allClients:ForEachClient(function(client)
            if client and client:IsAlive() then
                actionFunc(client)
            end
        end)
        return
    end
    
    local allClients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    allClients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local unit = client:GetClientGroupUnit()
            if unit and unit:IsInZone(RangeZones.TRAINING_AREA) then
                actionFunc(client)
            end
        end
    end)
end

return RangePilots
