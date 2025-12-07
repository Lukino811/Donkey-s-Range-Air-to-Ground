-- =============================================================================
-- RANGE TARGETS MODULE
-- Target and defense spawning
-- =============================================================================

local RangeTargets = {}

-- Dependencies (injected via init)
local RANGE = nil
local RangeState = nil
local RangeZones = nil
local SpawnTemplates = nil
local ModuleToPrefixMap = nil
local DefenseToPrefixMap = nil
local RangeMessages = nil

function RangeTargets.init(config, state, zones, messages)
    RANGE = config.RANGE
    RangeState = state.State
    RangeZones = zones
    SpawnTemplates = state.SpawnTemplates
    ModuleToPrefixMap = config.ModuleToPrefixMap
    DefenseToPrefixMap = config.DefenseToPrefixMap
    RangeMessages = messages
end

function RangeTargets.InitializeSpawnTemplates()
    env.info(RANGE.Name .. ": Initializing SPAWN templates...")
    
    local allPrefixes = {
        { prefix = RANGE.GroupPrefixes.TARGET_STATIC, isTarget = true },
        { prefix = RANGE.GroupPrefixes.TARGET_CONVOY, isTarget = true },
        { prefix = RANGE.GroupPrefixes.TARGET_POPUP, isTarget = true },
        { prefix = RANGE.GroupPrefixes.TARGET_URBAN, isTarget = true },
        { prefix = RANGE.GroupPrefixes.DEFENSE_LOW, isTarget = false },
        { prefix = RANGE.GroupPrefixes.DEFENSE_MED, isTarget = false },
        { prefix = RANGE.GroupPrefixes.DEFENSE_HIGH, isTarget = false }
    }
    
    local totalFound = 0
    
    for _, prefixData in ipairs(allPrefixes) do
        local prefix = prefixData.prefix
        local isTarget = prefixData.isTarget
        
        for i = 1, 20 do
            local groupName = prefix .. "_" .. i
            local testGroup = GROUP:FindByName(groupName)
            
            if testGroup then
                local spawn = SPAWN:New(groupName):InitDelayOff()
                
                if isTarget then
                    SpawnTemplates.Targets[groupName] = spawn
                    env.info(RANGE.Name .. ": Created TARGET spawn template: " .. groupName)
                else
                    SpawnTemplates.Defenses[groupName] = spawn
                    env.info(RANGE.Name .. ": Created DEFENSE spawn template: " .. groupName)
                end
                
                totalFound = totalFound + 1
            end
        end
    end
    
    env.info(RANGE.Name .. ": SPAWN templates initialized. Total groups found: " .. totalFound)
end

function RangeTargets.InitializeZones()
    env.info(RANGE.Name .. ": Initializing zones...")
    
    local zonesOK = true
    
    RangeZones.HOLD = ZONE:FindByName(RANGE.ZoneNames.HOLD)
    if RangeZones.HOLD then
        env.info(RANGE.Name .. ": HOLD zone found: " .. RANGE.ZoneNames.HOLD)
    else
        env.info(RANGE.Name .. ": WARNING - HOLD zone NOT found: " .. RANGE.ZoneNames.HOLD)
        zonesOK = false
    end
    
    RangeZones.IP = ZONE:FindByName(RANGE.ZoneNames.IP)
    if RangeZones.IP then
        env.info(RANGE.Name .. ": IP zone found: " .. RANGE.ZoneNames.IP)
    else
        env.info(RANGE.Name .. ": WARNING - IP zone NOT found: " .. RANGE.ZoneNames.IP)
        zonesOK = false
    end
    
    RangeZones.AREA = ZONE:FindByName(RANGE.ZoneNames.AREA)
    if RangeZones.AREA then
        env.info(RANGE.Name .. ": AREA zone found: " .. RANGE.ZoneNames.AREA)
    else
        env.info(RANGE.Name .. ": WARNING - AREA zone NOT found: " .. RANGE.ZoneNames.AREA)
        zonesOK = false
    end
    
    -- V10: Training Area zone
    RangeZones.TRAINING_AREA = ZONE:FindByName(RANGE.ZoneNames.TRAINING_AREA)
    if RangeZones.TRAINING_AREA then
        env.info(RANGE.Name .. ": TRAINING_AREA zone found: " .. RANGE.ZoneNames.TRAINING_AREA)
        RangeState.TrainingAreaAvailable = true
    else
        env.info(RANGE.Name .. ": WARNING - TRAINING_AREA zone NOT found: " .. RANGE.ZoneNames.TRAINING_AREA)
        env.info(RANGE.Name .. ": CHECK-IN will be available everywhere (graceful fallback)")
        RangeState.TrainingAreaAvailable = false
    end
    
    if zonesOK then
        env.info(RANGE.Name .. ": Core zones initialized successfully")
    else
        MESSAGE:New(RANGE.Name .. ": ATTENZIONE - Alcune zone mancano! Controlla il Mission Editor.", 30):ToAll()
    end
    
    return zonesOK
end

function RangeTargets.ActivateTargets(moduleType)
    env.info(RANGE.Name .. ": ActivateTargets called for module: " .. moduleType)
    
    if moduleType == RANGE.TrainingModules.NONE then
        env.info(RANGE.Name .. ": No module selected, skipping target activation")
        return
    end
    
    local prefix = ModuleToPrefixMap[moduleType]
    if not prefix then
        env.info(RANGE.Name .. ": WARNING - No prefix mapping for module: " .. moduleType)
        return
    end
    
    -- V10 FIX: Pulisci la lista PRIMA di aggiungere nuovi gruppi
    RangeState.ActiveTargetGroups = {}
    
    local activatedCount = 0
    for groupName, spawnTemplate in pairs(SpawnTemplates.Targets) do
        if string.find(groupName, prefix, 1, true) == 1 then
            local spawnedGroup = spawnTemplate:ReSpawn()
            if spawnedGroup then
                table.insert(RangeState.ActiveTargetGroups, spawnedGroup)
                activatedCount = activatedCount + 1
                env.info(RANGE.Name .. ": Spawned target group: " .. spawnedGroup:GetName())
            end
        end
    end
    
    if activatedCount > 0 then
        RangeMessages.SendMessageToRegistered("CONFIG_MODULE", 10, moduleType .. " - " .. activatedCount .. " gruppi attivati")
    else
        MESSAGE:New(RANGE.Name .. ": ATTENZIONE - Nessun target trovato per " .. moduleType, 10):ToAll()
    end
end

function RangeTargets.DeactivateAllTargets()
    env.info(RANGE.Name .. ": DeactivateAllTargets called")
    
    local deactivatedCount = 0
    for _, group in ipairs(RangeState.ActiveTargetGroups) do
        if group then
            local isAlive = false
            pcall(function() isAlive = group:IsAlive() end)
            if isAlive then
                group:Destroy()
                deactivatedCount = deactivatedCount + 1
            end
        end
    end
    
    RangeState.ActiveTargetGroups = {}
    env.info(RANGE.Name .. ": Deactivated " .. deactivatedCount .. " target group(s)")
end

function RangeTargets.ActivateDefenses(defenseLevel)
    env.info(RANGE.Name .. ": ActivateDefenses called for level: " .. defenseLevel)
    
    if defenseLevel == RANGE.DefenseLevels.NONE then
        env.info(RANGE.Name .. ": Defense level NONE - no defenses will be activated")
        return
    end
    
    local prefixes = DefenseToPrefixMap[defenseLevel]
    if not prefixes or #prefixes == 0 then
        return
    end
    
    -- V10 FIX: Pulisci la lista PRIMA di aggiungere nuovi gruppi
    RangeState.ActiveDefenseGroups = {}
    
    local activatedCount = 0
    for _, prefix in ipairs(prefixes) do
        for groupName, spawnTemplate in pairs(SpawnTemplates.Defenses) do
            if string.find(groupName, prefix, 1, true) == 1 then
                local spawnedGroup = spawnTemplate:ReSpawn()
                if spawnedGroup then
                    table.insert(RangeState.ActiveDefenseGroups, spawnedGroup)
                    activatedCount = activatedCount + 1
                    env.info(RANGE.Name .. ": Spawned defense group: " .. spawnedGroup:GetName())
                end
            end
        end
    end
    
    if activatedCount > 0 then
        RangeMessages.SendMessageToRegistered("CONFIG_DEFENSE", 10, defenseLevel .. " - " .. activatedCount .. " gruppi attivati")
    end
end

function RangeTargets.DeactivateAllDefenses()
    env.info(RANGE.Name .. ": DeactivateAllDefenses called")
    
    local deactivatedCount = 0
    for _, group in ipairs(RangeState.ActiveDefenseGroups) do
        if group then
            local isAlive = false
            pcall(function() isAlive = group:IsAlive() end)
            if isAlive then
                group:Destroy()
                deactivatedCount = deactivatedCount + 1
            end
        end
    end
    
    RangeState.ActiveDefenseGroups = {}
    env.info(RANGE.Name .. ": Deactivated " .. deactivatedCount .. " defense group(s)")
end

return RangeTargets
