-- =============================================================================
-- RANGE TIMERS MODULE
-- Timer start/stop and periodic check functions
-- =============================================================================

local RangeTimers = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangeZones = nil
local RangePilots = nil
local RangeMessages = nil
local RangeStack = nil
local RangeFSM = nil

function RangeTimers.init(config, state, zones, pilots, messages, stack)
    RANGE = config.RANGE
    RangeState = state.State
    RangeZones = zones
    RangePilots = pilots
    RangeMessages = messages
    RangeStack = stack
end

-- Inject FSM reference after FSM module is created
function RangeTimers.setFSM(fsm)
    RangeFSM = fsm
end

-- Altitude Check Functions

function RangeTimers.CheckHoldingAltitudes()
    local currentState = RangeFSM:GetState()
    
    if currentState ~= "HOT" and currentState ~= "OCCUPIED" then
        return
    end
    
    local currentTime = timer.getTime()
    
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if not clientName then return end
            
            -- V10: Solo piloti registrati
            if not RangePilots.IsPilotRegistered(clientName) then return end
            
            local assignedStack = RangeStack.GetPilotStack(clientName)
            if not assignedStack then return end
            
            local unit = client:GetClientGroupUnit()
            if not unit then return end
            
            local inHold = RangeZones.HOLD and unit:IsInZone(RangeZones.HOLD)
            if not inHold then return end
            
            local currentAltFt = unit:GetAltitude() * 3.28084
            local assignedAltFt = RangeStack.GetStackAltitudeFt(assignedStack)
            local tolerance = RANGE.Stack.ToleranceFt
            
            local altDiff = math.abs(currentAltFt - assignedAltFt)
            
            if altDiff > tolerance then
                local lastWarning = RangeState.AltitudeWarningCooldown[clientName] or 0
                
                if currentTime - lastWarning >= RANGE.Timers.ALTITUDE_WARNING_COOLDOWN then
                    RangeState.AltitudeWarningCooldown[clientName] = currentTime
                    
                    local assignedFL = RangeStack.GetStackFL(assignedStack)
                    local currentFL = math.floor(currentAltFt / 100)
                    
                    env.info(RANGE.Name .. ": " .. clientName .. " altitude warning - assigned FL" .. 
                             assignedFL .. ", current FL" .. currentFL .. " (diff: " .. math.floor(altDiff) .. " ft)")
                    
                    local group = client:GetGroup()
                    if group then
                        RangeMessages.SendMessageToGroup("STACK_ALTITUDE_WARNING", group, 10, assignedFL .. "! (Sei a FL" .. currentFL .. ")", clientName)
                    end
                end
            end
        end
    end)
end

function RangeTimers.StartAltitudeCheckTimer()
    if RangeState.AltitudeCheckTimer then
        RangeState.AltitudeCheckTimer:Stop()
    end
    
    RangeState.AltitudeCheckTimer = TIMER:New(function()
        RangeTimers.CheckHoldingAltitudes()
    end):Start(5, RANGE.Timers.ALTITUDE_CHECK_INTERVAL)
    
    env.info(RANGE.Name .. ": Altitude check timer started (every " .. RANGE.Timers.ALTITUDE_CHECK_INTERVAL .. " sec)")
end

function RangeTimers.StopAltitudeCheckTimer()
    if RangeState.AltitudeCheckTimer then
        RangeState.AltitudeCheckTimer:Stop()
        RangeState.AltitudeCheckTimer = nil
        env.info(RANGE.Name .. ": Altitude check timer stopped")
    end
end

-- Zone Check Functions (Auto-checkout)

function RangeTimers.CheckTrainingAreaPresence()
    if not RangeState.TrainingAreaAvailable then
        return  -- No auto-checkout if zone doesn't exist
    end
    
    local currentTime = timer.getTime()
    
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if not clientName then return end
            
            -- Solo piloti registrati
            if not RangePilots.IsPilotRegistered(clientName) then return end
            
            local unit = client:GetClientGroupUnit()
            if not unit then return end
            
            local inTrainingArea = RangeZones.TRAINING_AREA and unit:IsInZone(RangeZones.TRAINING_AREA)
            
            if inTrainingArea then
                -- Dentro zona: reset timer
                if RangeState.CheckoutTimers[clientName] then
                    RangeState.CheckoutTimers[clientName] = nil
                    env.info(RANGE.Name .. ": " .. clientName .. " returned to training area, checkout timer reset")
                end
            else
                -- Fuori zona: avvia o controlla timer
                if not RangeState.CheckoutTimers[clientName] then
                    RangeState.CheckoutTimers[clientName] = currentTime
                    env.info(RANGE.Name .. ": " .. clientName .. " left training area, starting checkout timer")
                else
                    local timeOutside = currentTime - RangeState.CheckoutTimers[clientName]
                    
                    if timeOutside >= RANGE.Timers.AUTO_CHECKOUT_DELAY then
                        env.info(RANGE.Name .. ": " .. clientName .. " auto-checked out (3 min outside area)")
                        
                        local group = client:GetGroup()
                        if group then
                            RangeMessages.SendMessageToGroup("AUTO_CHECKOUT", group, 15, nil, clientName)
                        end
                        
                        RangePilots.UnregisterPilot(clientName)
                    end
                end
            end
        end
    end)
end

function RangeTimers.StartZoneCheckTimer()
    if RangeState.ZoneCheckTimer then
        RangeState.ZoneCheckTimer:Stop()
    end
    
    RangeState.ZoneCheckTimer = TIMER:New(function()
        RangeTimers.CheckTrainingAreaPresence()
    end):Start(5, RANGE.Timers.ZONE_CHECK_INTERVAL)
    
    env.info(RANGE.Name .. ": Zone check timer started (every " .. RANGE.Timers.ZONE_CHECK_INTERVAL .. " sec)")
end

function RangeTimers.StopZoneCheckTimer()
    if RangeState.ZoneCheckTimer then
        RangeState.ZoneCheckTimer:Stop()
        RangeState.ZoneCheckTimer = nil
        env.info(RANGE.Name .. ": Zone check timer stopped")
    end
end

-- Client Position Check Functions

function RangeTimers.CheckClientPositions()
    local currentState = RangeFSM:GetState()
    
    local clients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    clients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if not clientName then return end
            
            local unit = client:GetClientGroupUnit()
            if not unit then return end
            
            local group = client:GetGroup()
            
            local inHold = RangeZones.HOLD and unit:IsInZone(RangeZones.HOLD)
            local inIP = RangeZones.IP and unit:IsInZone(RangeZones.IP)
            local inArea = RangeZones.AREA and unit:IsInZone(RangeZones.AREA)
            
            -- V10: Solo piloti registrati possono interagire col range
            local isRegistered = RangePilots.IsPilotRegistered(clientName)
            
            -- STATO: GREEN/INIT/ABORT - Range non attivo
            if currentState == "GREEN" or currentState == "INIT" or currentState == "ABORT" then
                if (inHold or inIP or inArea) and isRegistered then
                    if group then
                        RangeMessages.SendMessageToGroup("RANGE_STAY_CLEAR", group, 5, "(" .. currentState .. ")", clientName)
                    end
                end
            
            -- STATO: HOT - Range attivo, in attesa di client
            elseif currentState == "HOT" then
                if inHold then
                    if isRegistered and not RangeStack.IsPilotInHolding(clientName) then
                        if RangeState.CanReattackDirectly == clientName then
                            RangeState.CanReattackDirectly = nil
                            env.info(RANGE.Name .. ": " .. clientName .. " entered HOLD, reattack authorization cleared")
                        end
                    elseif not isRegistered then
                        -- V10 FIX: Cooldown per evitare spam del messaggio
                        local currentTime = timer.getTime()
                        local lastWarning = RangeState.HoldNotRegisteredCooldown[clientName] or 0
                        
                        if currentTime - lastWarning >= RANGE.Timers.HOLD_NOT_REGISTERED_COOLDOWN then
                            RangeState.HoldNotRegisteredCooldown[clientName] = currentTime
                            RangeMessages.SendMessageToGroup("HOLD_NOT_REGISTERED", group, 10, nil, clientName)
                            env.info(RANGE.Name .. ": " .. clientName .. " in HOLD without check-in")
                        end
                    end
                end
                
                if inIP and isRegistered then
                    local nextPilot = RangeStack.GetNextPilotInStack()
                    
                    if RangeState.CanReattackDirectly == clientName then
                        env.info(RANGE.Name .. ": " .. clientName .. " at IP - REATTACK authorized")
                        RangeMessages.SendComposedMessageToAll(clientName, "IP_CLEARED", nil, 10)
                        RangeState.CanReattackDirectly = nil
                        RangeState.ActiveClient = clientName
                        RangeState.ActiveClientEnteredArea = false
                        RangeFSM:ClientEntersRun()
                    
                    elseif nextPilot == clientName then
                        env.info(RANGE.Name .. ": " .. clientName .. " at IP - starting run")
                        RangeMessages.SendComposedMessageToAll(clientName, "IP_CLEARED", nil, 10)
                        RangeStack.RemovePilotFromStack(clientName)
                        RangeStack.ShiftStacksDown()
                        RangeState.ActiveClient = clientName
                        RangeState.ActiveClientEnteredArea = false
                        RangeFSM:ClientEntersRun()
                    
                    elseif not RangeStack.IsPilotInHolding(clientName) then
                        if group then
                            RangeMessages.SendMessageToGroup("IP_NOT_IN_QUEUE", group, 10, nil, clientName)
                        end
                    
                    else
                        if group then
                            RangeMessages.SendMessageToGroup("IP_NOT_YOUR_TURN", group, 10, nil, clientName)
                        end
                    end
                end
            
            -- STATO: OCCUPIED - Un client sta attaccando
            elseif currentState == "OCCUPIED" then
                if inHold then
                    if isRegistered and not RangeStack.IsPilotInHolding(clientName) then
                        if clientName ~= RangeState.ActiveClient then
                            -- Stack già assegnato al CHECK-IN
                        end
                    elseif not isRegistered then
                        -- V10 FIX: Cooldown per evitare spam del messaggio
                        local currentTime = timer.getTime()
                        local lastWarning = RangeState.HoldNotRegisteredCooldown[clientName] or 0
                        
                        if currentTime - lastWarning >= RANGE.Timers.HOLD_NOT_REGISTERED_COOLDOWN then
                            RangeState.HoldNotRegisteredCooldown[clientName] = currentTime
                            RangeMessages.SendMessageToGroup("HOLD_NOT_REGISTERED", group, 10, nil, clientName)
                            env.info(RANGE.Name .. ": " .. clientName .. " in HOLD without check-in (OCCUPIED)")
                        end
                    end
                end
                
                if inIP and clientName ~= RangeState.ActiveClient and isRegistered then
                    if group then
                        RangeMessages.SendMessageToGroup("IP_OCCUPIED", group, 10, nil, clientName)
                    end
                end
                
                -- AREA ENTERED - con suono diretto
                if clientName == RangeState.ActiveClient then
                    if inArea and not RangeState.ActiveClientEnteredArea then
                        RangeState.ActiveClientEnteredArea = true
                        env.info(RANGE.Name .. ": " .. clientName .. " entered target area - PLAYING SOUND")
                        
                        -- Suono diretto (no coda per questo evento importante)
                        RangeMessages.PlaySoundDirect("area_entered.ogg")
                        
                        -- V10 FIX: Messaggio usando ForEachRegisteredClient
                        local pilotInArea = clientName
                        RangePilots.ForEachRegisteredClient(function(regClient)
                            local regGroup = regClient:GetGroup()
                            if regGroup then
                                MESSAGE:New(RANGE.Name .. ": " .. pilotInArea .. " - " .. RANGE.Messages.AREA_ENTERED.text, 10):ToGroup(regGroup)
                            end
                        end)
                    end
                end
            end  -- end elseif OCCUPIED
        end  -- end if client:IsAlive()
    end)  -- end ForEachClient
end

function RangeTimers.StartClientCheckTimer()
    if RangeState.ClientCheckTimer then
        RangeState.ClientCheckTimer:Stop()
    end
    
    RangeState.ClientCheckTimer = TIMER:New(function()
        RangeTimers.CheckClientPositions()
    end):Start(1, RANGE.Timers.CLIENT_CHECK_INTERVAL)
    
    env.info(RANGE.Name .. ": Client position check timer started")
end

function RangeTimers.StopClientCheckTimer()
    if RangeState.ClientCheckTimer then
        RangeState.ClientCheckTimer:Stop()
        RangeState.ClientCheckTimer = nil
        env.info(RANGE.Name .. ": Client position check timer stopped")
    end
end

return RangeTimers
