-- =============================================================================
-- RANGE MESSAGES MODULE
-- All messaging and audio functions
-- =============================================================================

local RangeMessages = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangePilots = nil

function RangeMessages.init(config, state, pilots)
    RANGE = config.RANGE
    RangeState = state.State
    RangePilots = pilots
end

-- Audio Functions

function RangeMessages.PlaySoundToRegistered(soundFile)
    if not soundFile then 
        env.info(RANGE.Name .. ": PlaySoundToRegistered - no sound file provided")
        return 
    end
    
    local fullPath = RANGE.SoundPath .. soundFile
    local currentTime = timer.getTime()
    
    local playTime = math.max(currentTime, RangeState.NextSoundTime)
    local delay = playTime - currentTime
    
    RangeState.NextSoundTime = playTime + RANGE.Timers.SOUND_DELAY
    
    env.info(RANGE.Name .. ": Queued sound to registered: " .. fullPath .. " (delay: " .. string.format("%.1f", delay) .. "s)")
    
    if delay > 0.1 then
        TIMER:New(function()
            RangePilots.ForEachRegisteredClient(function(client)
                local group = client:GetGroup()
                if group then
                    USERSOUND:New(fullPath):ToGroup(group)
                end
            end)
            env.info(RANGE.Name .. ": Playing sound NOW to registered: " .. fullPath)
        end):Start(delay)
    else
        RangePilots.ForEachRegisteredClient(function(client)
            local group = client:GetGroup()
            if group then
                USERSOUND:New(fullPath):ToGroup(group)
            end
        end)
        env.info(RANGE.Name .. ": Playing sound NOW to registered: " .. fullPath)
    end
end

function RangeMessages.PlaySoundToTrainingArea(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath .. soundFile
    
    RangePilots.ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound to training area: " .. fullPath)
end

function RangeMessages.PlaySoundToGroup(soundFile, group)
    if not soundFile then 
        env.info(RANGE.Name .. ": PlaySoundToGroup - no sound file provided")
        return 
    end
    if not group then 
        env.info(RANGE.Name .. ": PlaySoundToGroup - no group provided")
        return 
    end
    
    local fullPath = RANGE.SoundPath .. soundFile
    USERSOUND:New(fullPath):ToGroup(group)
    env.info(RANGE.Name .. ": Playing sound to group: " .. fullPath)
end

function RangeMessages.PlaySoundDirect(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath .. soundFile
    
    -- V10: Suono diretto solo ai registrati
    RangePilots.ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound DIRECT to registered: " .. fullPath)
end

-- Message Functions

function RangeMessages.SendMessageToRegistered(messageKey, duration, extraText)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = msgData.text
    if extraText then
        text = text .. " " .. extraText
    end
    
    if msgData.sound then
        RangeMessages.PlaySoundToRegistered(msgData.sound)
    end
    
    -- Messaggio solo ai registrati
    RangePilots.ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

function RangeMessages.SendBroadcastToTrainingArea(messageKey, duration, extraText)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = msgData.text
    if extraText then
        text = text .. " " .. extraText
    end
    
    if msgData.sound then
        RangeMessages.PlaySoundToTrainingArea(msgData.sound)
    end
    
    RangePilots.ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

function RangeMessages.SendMessageToAll(messageKey, duration, extraText)
    RangeMessages.SendMessageToRegistered(messageKey, duration, extraText)
end

function RangeMessages.SendMessageToGroup(messageKey, group, duration, extraText, prefix)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = msgData.text
    if extraText then
        text = text .. " " .. extraText
    end
    
    if prefix then
        text = prefix .. ": " .. text
    end
    
    if msgData.sound and group then
        RangeMessages.PlaySoundToGroup(msgData.sound, group)
    end
    
    if group then
        MESSAGE:New(text, duration or 10):ToGroup(group)
    end
end

function RangeMessages.SendComposedMessageToAll(prefix, messageKey, extraText, duration)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = ""
    if prefix then
        text = prefix .. " - "
    end
    text = text .. msgData.text
    if extraText then
        text = text .. " " .. extraText
    end
    
    if msgData.sound then
        RangeMessages.PlaySoundToRegistered(msgData.sound)
    end
    
    RangePilots.ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

return RangeMessages
