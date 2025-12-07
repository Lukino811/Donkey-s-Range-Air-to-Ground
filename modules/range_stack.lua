-- =============================================================================
-- RANGE STACK MODULE
-- All holding/stack management
-- =============================================================================

local RangeStack = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangePilots = nil
local RangeMessages = nil

function RangeStack.init(config, state, pilots, messages)
    RANGE = config.RANGE
    RangeState = state.State
    RangePilots = pilots
    RangeMessages = messages
end

function RangeStack.GetStackFL(stackNum)
    return RANGE.Stack.BaseFL + ((stackNum - 1) * RANGE.Stack.Separation)
end

function RangeStack.GetStackAltitudeFt(stackNum)
    return RangeStack.GetStackFL(stackNum) * 100
end

function RangeStack.GetHoldingCount()
    local count = 0
    for i = 1, RANGE.Stack.MaxStacks do
        if RangeState.HoldingStack[i] then
            count = count + 1
        end
    end
    return count
end

function RangeStack.GetFirstFreeStack()
    for i = 1, RANGE.Stack.MaxStacks do
        if not RangeState.HoldingStack[i] then
            return i
        end
    end
    return nil
end

function RangeStack.IsPilotInHolding(pilotName)
    return RangeState.PilotStack[pilotName] ~= nil
end

function RangeStack.GetPilotStack(pilotName)
    return RangeState.PilotStack[pilotName]
end

function RangeStack.GetNextPilotInStack()
    return RangeState.HoldingStack[1]
end

-- V10: Verifica registrazione prima di aggiungere allo stack
function RangeStack.AddPilotToStack(pilotName, callerGroup)
    -- V10: Verifica registrazione
    if not RangePilots.IsPilotRegistered(pilotName) then
        env.info(RANGE.Name .. ": " .. pilotName .. " tried to enter HOLD without check-in")
        if callerGroup then
            RangeMessages.SendMessageToGroup("HOLD_NOT_REGISTERED", callerGroup, 10, nil, pilotName)
        end
        return false
    end
    
    if RangeStack.IsPilotInHolding(pilotName) then
        env.info(RANGE.Name .. ": " .. pilotName .. " already in holding")
        return false
    end
    
    local freeStack = RangeStack.GetFirstFreeStack()
    
    if not freeStack then
        env.info(RANGE.Name .. ": Holding full, cannot add " .. pilotName)
        RangeMessages.SendComposedMessageToAll(pilotName, "STACK_FULL", nil, 15)
        return false
    end
    
    RangeState.HoldingStack[freeStack] = pilotName
    RangeState.PilotStack[pilotName] = freeStack
    
    local assignedFL = RangeStack.GetStackFL(freeStack)
    
    env.info(RANGE.Name .. ": " .. pilotName .. " assigned to Stack " .. freeStack .. " at FL" .. assignedFL)
    
    RangeMessages.SendComposedMessageToAll(pilotName, "STACK_ASSIGNED", freeStack .. " " .. RANGE.Messages.STACK_AT_FL.text .. " " .. assignedFL, 10)
    
    if freeStack == 1 then
        TIMER:New(function()
            RangeMessages.SendComposedMessageToAll(pilotName, "STACK_YOU_ARE_NEXT", nil, 10)
        end):Start(6)
    else
        local pilotsAhead = freeStack - 1
        TIMER:New(function()
            RangeMessages.SendComposedMessageToAll(pilotName, "PILOTS_AHEAD", tostring(pilotsAhead), 10)
        end):Start(6)
    end
    
    return true
end

function RangeStack.RemovePilotFromStack(pilotName)
    local stackNum = RangeState.PilotStack[pilotName]
    
    if not stackNum then
        env.info(RANGE.Name .. ": " .. pilotName .. " not in holding, cannot remove")
        return false
    end
    
    RangeState.HoldingStack[stackNum] = nil
    RangeState.PilotStack[pilotName] = nil
    RangeState.AltitudeWarningCooldown[pilotName] = nil
    
    env.info(RANGE.Name .. ": " .. pilotName .. " removed from Stack " .. stackNum)
    
    return stackNum
end

function RangeStack.ShiftStacksDown()
    env.info(RANGE.Name .. ": Shifting all stacks down...")
    
    local delayCounter = 0
    
    for i = 1, RANGE.Stack.MaxStacks - 1 do
        local pilotAbove = RangeState.HoldingStack[i + 1]
        
        if pilotAbove then
            RangeState.HoldingStack[i] = pilotAbove
            RangeState.HoldingStack[i + 1] = nil
            RangeState.PilotStack[pilotAbove] = i
            
            local newFL = RangeStack.GetStackFL(i)
            local pilot = pilotAbove
            local newStack = i
            
            env.info(RANGE.Name .. ": " .. pilotAbove .. " moved to Stack " .. i .. " at FL" .. newFL)
            
            TIMER:New(function()
                RangeMessages.SendComposedMessageToAll(pilot, "STACK_DESCEND", newStack .. " " .. RANGE.Messages.STACK_AT_FL.text .. " " .. RangeStack.GetStackFL(newStack), 10)
            end):Start(delayCounter * 6 + 2)
            
            if i == 1 then
                TIMER:New(function()
                    RangeMessages.SendComposedMessageToAll(pilot, "STACK_YOU_ARE_NEXT", nil, 10)
                end):Start(delayCounter * 6 + 8)
            end
            
            delayCounter = delayCounter + 1
        end
    end
    
    RangeState.HoldingStack[RANGE.Stack.MaxStacks] = nil
end

function RangeStack.ClearAllStacks()
    for i = 1, RANGE.Stack.MaxStacks do
        RangeState.HoldingStack[i] = nil
    end
    RangeState.PilotStack = {}
    RangeState.AltitudeWarningCooldown = {}
    env.info(RANGE.Name .. ": All stacks cleared")
end

function RangeStack.NotifyNextPilotInStack()
    local nextPilot = RangeStack.GetNextPilotInStack()
    if nextPilot then
        RangeMessages.SendComposedMessageToAll(nextPilot, "STACK_YOU_ARE_NEXT", nil, 15)
        env.info(RANGE.Name .. ": Notified " .. nextPilot .. " - first in stack")
    end
end

return RangeStack
