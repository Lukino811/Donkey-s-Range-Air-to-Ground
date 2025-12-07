-- =============================================================================
-- DCS MOOSE AIR-TO-GROUND TRAINING RANGE
-- DONKEY'S RANGE - VERSIONE 10
-- Sistema CHECK-IN/CHECK-OUT esplicito + messaggi filtrati
-- =============================================================================

-- -----------------------------------------------------------------------------
-- COSTANTI E CONFIGURAZIONE
-- -----------------------------------------------------------------------------

RANGE = {
    Name = "DONKEY'S RANGE",
    
    TrainingModules = {
        NONE = "None",
        STATIC_BOMBING = "Static Bombing",
        CONVOY = "Convoy",
        POPUP = "Pop-Up",
        URBAN = "Urban"
    },
    
    DefenseLevels = {
        NONE = "None",
        LOW = "Low",
        MEDIUM = "Medium",
        HIGH = "High"
    },
    
    Timers = {
        ABORT_TO_GREEN_DELAY = 5,
        CLIENT_CHECK_INTERVAL = 10,
        ALTITUDE_CHECK_INTERVAL = 10,
        SOUND_DELAY = 8,
        ALTITUDE_WARNING_COOLDOWN = 30,
		HOLD_NOT_REGISTERED_COOLDOWN = 15,
        ZONE_CHECK_INTERVAL = 10,       -- V10: Controllo zona training area
        AUTO_CHECKOUT_DELAY = 180       -- V10: 3 minuti fuori zona = auto-checkout
    },
    
    GroupPrefixes = {
        TARGET_STATIC = "RANGE_TGT_STATIC",
        TARGET_CONVOY = "RANGE_TGT_CONVOY",
        TARGET_POPUP = "RANGE_TGT_POPUP",
        TARGET_URBAN = "RANGE_TGT_URBAN",
        DEFENSE_LOW = "RANGE_DEF_LOW",
        DEFENSE_MED = "RANGE_DEF_MED",
        DEFENSE_HIGH = "RANGE_DEF_HIGH"
    },
    
    ZoneNames = {
        HOLD = "RANGE_ZONE_HOLD",
        IP = "RANGE_ZONE_IP",
        AREA = "RANGE_ZONE_AREA",
        TRAINING_AREA = "RANGE_ZONE_TRAINING_AREA"  -- V10: Nuova zona ampia
    },
    
    Stack = {
        BaseFL = 160,
        Separation = 10,
        MaxStacks = 6,
        ToleranceFt = 500
    },
    
    SoundPath = "Sounds/DonkeyRange/",
    
    Messages = {
        INIT = {
            text = "Inizializzazione in corso...",
            sound = "init. ogg"
        },
        GREEN = {
            text = "RANGE VERDE - Sicuro/Reset",
            sound = "range_green.ogg"
        },
        HOT = {
            text = "RANGE ATTIVO - In attesa di piloti",
            sound = "range_hot.ogg"
        },
        OCCUPIED = {
            text = "RANGE OCCUPATO",
            sound = "range_occupied.ogg"
        },
        ABORT = {
            text = "! !! ABORT DI EMERGENZA ! !! - Tutti gli aerei sganciate e uscite IMMEDIATAMENTE! ",
            sound = "abort.ogg"
        },
        
        -- V10: Messaggi CHECK-IN/CHECK-OUT
        CHECKIN_SUCCESS = {
            text = "CHECK-IN confermato, benvenuto al range!",
            sound = "checkin_success.ogg"
        },
        CHECKIN_OUTSIDE_ZONE = {
            text = "Devi essere nell'area training per fare CHECK-IN! ",
            sound = "checkin_outside.ogg"
        },
        CHECKIN_ALREADY = {
            text = "Sei gia' registrato al range!",
            sound = nil
        },
        CHECKOUT_SUCCESS = {
            text = "CHECK-OUT confermato, arrivederci!",
            sound = "checkout_success.ogg"
        },
        CHECKOUT_NOT_REGISTERED = {
            text = "Non sei registrato al range!",
            sound = nil
        },
        AUTO_CHECKOUT = {
            text = "Auto-checkout per uscita prolungata dalla training area",
            sound = "auto_checkout.ogg"
        },
        HOLD_NOT_REGISTERED = {
            text = "Devi fare CHECK-IN al range prima di entrare in HOLD!  (F10 menu)",
            sound = "hold_not_registered.ogg"
        },
        TRAINING_AREA_MISSING = {
            text = "Training Area non configurata, check-in disponibile ovunque",
            sound = nil
        },
        
        STACK_ASSIGNED = {
            text = "HOLD assegnato: Stack",
            sound = "stack_assigned.ogg"
        },
        STACK_AT_FL = {
            text = "a FL",
            sound = nil
        },
        STACK_FULL = {
            text = "HOLDING PIENO!  Massimo 6 aerei.  Rimani fuori dalla zona e attendi.",
            sound = "stack_full.ogg"
        },
        STACK_ALTITUDE_WARNING = {
            text = "EHI! Mantieni la tua quota assegnata!  Dovresti essere a FL",
            sound = "stack_altitude_warning.ogg"
        },
        STACK_DESCEND = {
            text = "Scendi al nuovo stack!  Ora sei Stack",
            sound = "stack_descend.ogg"
        },
        STACK_YOU_ARE_NEXT = {
            text = "Sei al primo stack - procedi all'IP quando pronto! ",
            sound = "stack_you_are_next.ogg"
        },
        
        IP_CLEARED = {
            text = "AUTORIZZATO HOT!  Buon divertimento!",
            sound = "ip_cleared.ogg"
        },
        IP_NOT_IN_QUEUE = {
            text = "Ehi! Prima entra in HOLD, non fare il furbo!",
            sound = "ip_not_in_queue. ogg"
        },
        IP_NOT_YOUR_TURN = {
            text = "Calma cowboy! Non e' il tuo turno!",
            sound = "ip_not_your_turn.ogg"
        },
        IP_OCCUPIED = {
            text = "Range OCCUPATO! Torna in HOLD! ",
            sound = "ip_occupied.ogg"
        },
        
        AREA_ENTERED = {
            text = "Nell'area target - WEAPONS FREE!",
            sound = "area_entered.ogg"
        },
        
        EGRESS_SUCCESS = {
            text = "EGRESS confermato.  Ottimo lavoro!",
            sound = "egress_success.ogg"
        },
        EGRESS_REATTACK = {
            text = "Nessuno in coda - puoi tornare all'IP per un altro passaggio!",
            sound = "egress_reattack.ogg"
        },
        EGRESS_BACK_TO_HOLD = {
            text = "Altri piloti in attesa - torna in HOLD per un altro giro.",
            sound = "egress_back_to_hold.ogg"
        },
        EGRESS_WRONG = {
            text = "Stai calmo, non stai sganciando niente!  Non sei tu il pilota attivo.",
            sound = "egress_wrong.ogg"
        },
        EGRESS_NOT_OCCUPIED = {
            text = "Ma che egress vuoi fare?  Il range non e' nemmeno occupato!",
            sound = "egress_not_occupied.ogg"
        },
        
        RANGE_NOT_ACTIVE = {
            text = "Il range e' in stato",
            sound = nil
        },
        RANGE_STAY_CLEAR = {
            text = "Stai alla larga! ",
            sound = "range_stay_clear.ogg"
        },
        
        CONFIG_COMPLETE = {
            text = "Configurazione completata - Attivazione range.. .",
            sound = "config_complete.ogg"
        },
        CONFIG_MODULE = {
            text = "Modulo impostato:",
            sound = "config_module.ogg"
        },
        CONFIG_DEFENSE = {
            text = "Livello difese impostato:",
            sound = "config_defense.ogg"
        },
        CONFIG_RESET = {
            text = "Reset del range a VERDE.. .",
            sound = "config_reset.ogg"
        },
        CONFIG_ALREADY_GREEN = {
            text = "Il range e' gia' VERDE, rilassati!",
            sound = "config_already_green.ogg"
        },
        CONFIG_CHANGE_HOT = {
            text = "Riconfigurazione - Prima torno a VERDE.. .",
            sound = "config_reset.ogg"
        },
        
        PILOTS_AHEAD = {
            text = "Aerei davanti a te:",
            sound = "pilots_ahead.ogg"
        }
    }
}

local ModuleToPrefixMap = {
    [RANGE.TrainingModules. STATIC_BOMBING] = RANGE.GroupPrefixes.TARGET_STATIC,
    [RANGE.TrainingModules. CONVOY] = RANGE.GroupPrefixes.TARGET_CONVOY,
    [RANGE.TrainingModules.POPUP] = RANGE.GroupPrefixes.TARGET_POPUP,
    [RANGE.TrainingModules. URBAN] = RANGE.GroupPrefixes.TARGET_URBAN
}

local DefenseToPrefixMap = {
    [RANGE.DefenseLevels.NONE] = {},
    [RANGE.DefenseLevels.LOW] = { RANGE.GroupPrefixes. DEFENSE_LOW },
    [RANGE.DefenseLevels.MEDIUM] = { RANGE.GroupPrefixes.DEFENSE_MED },
    [RANGE.DefenseLevels. HIGH] = { RANGE.GroupPrefixes.DEFENSE_HIGH }
}

-- -----------------------------------------------------------------------------
-- STATO RUNTIME DEL RANGE
-- -----------------------------------------------------------------------------

RangeState = {
    SelectedModule = RANGE.TrainingModules.NONE,
    SelectedDefense = RANGE. DefenseLevels.NONE,
    
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

for i = 1, RANGE.Stack.MaxStacks do
    RangeState.HoldingStack[i] = nil
end

-- -----------------------------------------------------------------------------
-- ZONE OBJECTS
-- -----------------------------------------------------------------------------

RangeZones = {
    HOLD = nil,
    IP = nil,
    AREA = nil,
    TRAINING_AREA = nil  -- V10: Zona training area
}

-- -----------------------------------------------------------------------------
-- SPAWN TEMPLATES
-- -----------------------------------------------------------------------------

SpawnTemplates = {
    Targets = {},
    Defenses = {}
}

-- -----------------------------------------------------------------------------
-- V10: SISTEMA REGISTRAZIONE PILOTI (CORRETTO)
-- -----------------------------------------------------------------------------

function RegisterPilot(pilotName)
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

function UnregisterPilot(pilotName)
    if not pilotName then return false end
    
    if not RangeState.RegisteredPilots[pilotName] then
        env.info(RANGE.Name .. ": " ..  pilotName .. " not registered, cannot unregister")
        return false
    end
    
    -- Rimuovi da stack se presente
    if IsPilotInHolding(pilotName) then
        local removedStack = RemovePilotFromStack(pilotName)
        if removedStack then
            ShiftStacksDown()
        end
    end
    
    -- Se era il pilota attivo, gestisci egress forzato
    if RangeState.ActiveClient == pilotName then
        RangeState.ActiveClient = nil
        RangeState.ActiveClientEnteredArea = false
        local currentState = RangeFSM:GetState()
        if currentState == "OCCUPIED" then
            if GetHoldingCount() > 0 then
                RangeFSM:EgressWithQueue()
            else
                RangeFSM:EgressNoQueue()
            end
        end
    end
    
    RangeState.RegisteredPilots[pilotName] = nil
    RangeState.CheckoutTimers[pilotName] = nil
    RangeState.AltitudeWarningCooldown[pilotName] = nil
    
    -- Pulisci anche reattack se era lui
    if RangeState. CanReattackDirectly == pilotName then
        RangeState.CanReattackDirectly = nil
    end
    
    env.info(RANGE.Name .. ": " .. pilotName .. " checked out from range")
    return true
end

function IsPilotRegistered(pilotName)
    if not pilotName then return false end
    return RangeState.RegisteredPilots[pilotName] == true
end

function GetRegisteredCount()
    local count = 0
    for _ in pairs(RangeState. RegisteredPilots) do
        count = count + 1
    end
    return count
end

function GetRegisteredPilotsList()
    local list = {}
    for pilotName, _ in pairs(RangeState.RegisteredPilots) do
        table.insert(list, pilotName)
    end
    return list
end

function ClearAllRegistrations()
    RangeState.RegisteredPilots = {}
    RangeState.CheckoutTimers = {}
    env.info(RANGE.Name ..  ": All registrations cleared")
end

-- V10: CORRETTO - Itera sui client registrati e esegue azione
function ForEachRegisteredClient(actionFunc)
    local allClients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    allClients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if clientName and IsPilotRegistered(clientName) then
                actionFunc(client)
            end
        end
    end)
end

-- V10: CORRETTO - Itera sui client nella Training Area e esegue azione
function ForEachClientInTrainingArea(actionFunc)
    if not RangeZones. TRAINING_AREA then
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
            if unit and unit:IsInZone(RangeZones. TRAINING_AREA) then
                actionFunc(client)
            end
        end
    end)
end

-- -----------------------------------------------------------------------------
-- V10: AUDIO FUNCTIONS CON FILTRO REGISTRATI (CORRETTO)
-- -----------------------------------------------------------------------------

function PlaySoundToRegistered(soundFile)
    if not soundFile then 
        env.info(RANGE.Name .. ": PlaySoundToRegistered - no sound file provided")
        return 
    end
    
    local fullPath = RANGE.SoundPath .. soundFile
    local currentTime = timer.getTime()
    
    local playTime = math.max(currentTime, RangeState.NextSoundTime)
    local delay = playTime - currentTime
    
    RangeState.NextSoundTime = playTime + RANGE. Timers. SOUND_DELAY
    
    env.info(RANGE.Name .. ": Queued sound to registered: " .. fullPath ..  " (delay: " .. string.format("%.1f", delay) .. "s)")
    
    if delay > 0.1 then
        TIMER:New(function()
            ForEachRegisteredClient(function(client)
                local group = client:GetGroup()
                if group then
                    USERSOUND:New(fullPath):ToGroup(group)
                end
            end)
            env.info(RANGE.Name ..  ": Playing sound NOW to registered: " .. fullPath)
        end):Start(delay)
    else
        ForEachRegisteredClient(function(client)
            local group = client:GetGroup()
            if group then
                USERSOUND:New(fullPath):ToGroup(group)
            end
        end)
        env.info(RANGE.Name .. ": Playing sound NOW to registered: " .. fullPath)
    end
end

-- V10: CORRETTO - Suono broadcast a TUTTI nella Training Area (per ABORT)
function PlaySoundToTrainingArea(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath ..  soundFile
    
    ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound to training area: " .. fullPath)
end

function PlaySoundToGroup(soundFile, group)
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

function PlaySoundDirect(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath ..  soundFile
    
 -- V10: Suono diretto solo ai registrati
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound DIRECT to registered: " .. fullPath)
end

-- V10: CORRETTO - Messaggio a tutti i registrati
function SendMessageToRegistered(messageKey, duration, extraText)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = msgData.text
    if extraText then
        text = text ..  " " .. extraText
    end
    
    if msgData.sound then
        PlaySoundToRegistered(msgData.sound)
    end
    

    -- Messaggio solo ai registrati
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

-- V10: CORRETTO - Broadcast a tutti nella Training Area (per ABORT e messaggi critici)
function SendBroadcastToTrainingArea(messageKey, duration, extraText)
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
        PlaySoundToTrainingArea(msgData.sound)
    end
    
    ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name ..  ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

-- V10: MODIFICATO - SendMessageToAll ora invia solo ai registrati
function SendMessageToAll(messageKey, duration, extraText)
    SendMessageToRegistered(messageKey, duration, extraText)
end

function SendMessageToGroup(messageKey, group, duration, extraText, prefix)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " ..  tostring(messageKey))
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
        PlaySoundToGroup(msgData.sound, group)
    end
    
    if group then
        MESSAGE:New(text, duration or 10):ToGroup(group)
    end
end

-- V10: MODIFICATO - SendMessageToAll ora invia solo ai registrati
function SendMessageToAll(messageKey, duration, extraText)
    SendMessageToRegistered(messageKey, duration, extraText)
end

function SendMessageToGroup(messageKey, group, duration, extraText, prefix)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " ..  tostring(messageKey))
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
        PlaySoundToGroup(msgData.sound, group)
    end
    
    if group then
        MESSAGE:New(text, duration or 10):ToGroup(group)
    end
end

-- V10: CORRETTO - SendComposedMessageToAll ora invia solo ai registrati
function SendComposedMessageToAll(prefix, messageKey, extraText, duration)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE. Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
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
        PlaySoundToRegistered(msgData.sound)
    end
    
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " ..  text, duration or 10):ToGroup(group)
        end
    end)
end
-- -----------------------------------------------------------------------------
-- SPAWN TEMPLATES INITIALIZATION
-- -----------------------------------------------------------------------------

function InitializeSpawnTemplates()
    env.info(RANGE.Name ..  ": Initializing SPAWN templates...")
    
    local allPrefixes = {
        { prefix = RANGE.GroupPrefixes.TARGET_STATIC, isTarget = true },
        { prefix = RANGE.GroupPrefixes. TARGET_CONVOY, isTarget = true },
        { prefix = RANGE.GroupPrefixes.TARGET_POPUP, isTarget = true },
        { prefix = RANGE.GroupPrefixes.TARGET_URBAN, isTarget = true },
        { prefix = RANGE. GroupPrefixes. DEFENSE_LOW, isTarget = false },
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
                    env.info(RANGE.Name ..  ": Created TARGET spawn template: " .. groupName)
                else
                    SpawnTemplates.Defenses[groupName] = spawn
                    env.info(RANGE.Name .. ": Created DEFENSE spawn template: " ..  groupName)
                end
                
                totalFound = totalFound + 1
            end
        end
    end
    
    env.info(RANGE.Name .. ": SPAWN templates initialized.  Total groups found: " .. totalFound)
end

-- -----------------------------------------------------------------------------
-- ZONE INITIALIZATION
-- -----------------------------------------------------------------------------

function InitializeZones()
    env.info(RANGE.Name ..  ": Initializing zones...")
    
    local zonesOK = true
    
    RangeZones.HOLD = ZONE:FindByName(RANGE.ZoneNames.HOLD)
    if RangeZones.HOLD then
        env.info(RANGE.Name ..  ": HOLD zone found: " .. RANGE.ZoneNames.HOLD)
    else
        env.info(RANGE.Name .. ": WARNING - HOLD zone NOT found: " .. RANGE.ZoneNames.HOLD)
        zonesOK = false
    end
    
    RangeZones.IP = ZONE:FindByName(RANGE.ZoneNames.IP)
    if RangeZones.IP then
        env.info(RANGE.Name .. ": IP zone found: " .. RANGE.ZoneNames.IP)
    else
        env.info(RANGE. Name .. ": WARNING - IP zone NOT found: " .. RANGE. ZoneNames.IP)
        zonesOK = false
    end
    
    RangeZones.AREA = ZONE:FindByName(RANGE.ZoneNames. AREA)
    if RangeZones.AREA then
        env.info(RANGE.Name .. ": AREA zone found: " .. RANGE.ZoneNames.AREA)
    else
        env.info(RANGE. Name .. ": WARNING - AREA zone NOT found: " .. RANGE.ZoneNames.AREA)
        zonesOK = false
    end
    
    -- V10: Training Area zone
    RangeZones. TRAINING_AREA = ZONE:FindByName(RANGE. ZoneNames.TRAINING_AREA)
    if RangeZones.TRAINING_AREA then
        env.info(RANGE.Name .. ": TRAINING_AREA zone found: " ..  RANGE.ZoneNames. TRAINING_AREA)
        RangeState.TrainingAreaAvailable = true
    else
        env.info(RANGE.Name .. ": WARNING - TRAINING_AREA zone NOT found: " ..  RANGE.ZoneNames. TRAINING_AREA)
        env.info(RANGE.Name ..  ": CHECK-IN will be available everywhere (graceful fallback)")
        RangeState.TrainingAreaAvailable = false
    end
    
    if zonesOK then
        env.info(RANGE.Name ..  ": Core zones initialized successfully")
    else
        MESSAGE:New(RANGE.Name ..  ": ATTENZIONE - Alcune zone mancano!  Controlla il Mission Editor.", 30):ToAll()
    end
    
    return zonesOK
end

-- -----------------------------------------------------------------------------
-- STACK HOLDING FUNCTIONS
-- -----------------------------------------------------------------------------

function GetStackFL(stackNum)
    return RANGE.Stack. BaseFL + ((stackNum - 1) * RANGE.Stack. Separation)
end

function GetStackAltitudeFt(stackNum)
    return GetStackFL(stackNum) * 100
end

function GetHoldingCount()
    local count = 0
    for i = 1, RANGE.Stack.MaxStacks do
        if RangeState.HoldingStack[i] then
            count = count + 1
        end
    end
    return count
end

function GetFirstFreeStack()
    for i = 1, RANGE.Stack. MaxStacks do
        if not RangeState.HoldingStack[i] then
            return i
        end
    end
    return nil
end

function IsPilotInHolding(pilotName)
    return RangeState.PilotStack[pilotName] ~= nil
end

function GetPilotStack(pilotName)
    return RangeState.PilotStack[pilotName]
end

function GetNextPilotInStack()
    return RangeState.HoldingStack[1]
end

-- V10: MODIFICATO - Verifica registrazione prima di aggiungere allo stack
function AddPilotToStack(pilotName, callerGroup)
    -- V10: Verifica registrazione
    if not IsPilotRegistered(pilotName) then
        env.info(RANGE. Name .. ": " .. pilotName .. " tried to enter HOLD without check-in")
        if callerGroup then
            SendMessageToGroup("HOLD_NOT_REGISTERED", callerGroup, 10, nil, pilotName)
        end
        return false
    end
    
    if IsPilotInHolding(pilotName) then
        env.info(RANGE.Name ..  ": " .. pilotName ..  " already in holding")
        return false
    end
    
    local freeStack = GetFirstFreeStack()
    
    if not freeStack then
        env.info(RANGE. Name .. ": Holding full, cannot add " .. pilotName)
        SendComposedMessageToAll(pilotName, "STACK_FULL", nil, 15)
        return false
    end
    
    RangeState.HoldingStack[freeStack] = pilotName
    RangeState.PilotStack[pilotName] = freeStack
    
    local assignedFL = GetStackFL(freeStack)
    
    env.info(RANGE.Name ..  ": " .. pilotName .. " assigned to Stack " .. freeStack ..  " at FL" .. assignedFL)
    
    SendComposedMessageToAll(pilotName, "STACK_ASSIGNED", freeStack ..  " " ..  RANGE.Messages.STACK_AT_FL. text ..  " " .. assignedFL, 10)
    
    if freeStack == 1 then
        TIMER:New(function()
            SendComposedMessageToAll(pilotName, "STACK_YOU_ARE_NEXT", nil, 10)
        end):Start(6)
    else
        local pilotsAhead = freeStack - 1
        TIMER:New(function()
            SendComposedMessageToAll(pilotName, "PILOTS_AHEAD", tostring(pilotsAhead), 10)
        end):Start(6)
    end
    
    return true
end

function RemovePilotFromStack(pilotName)
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

function ShiftStacksDown()
    env.info(RANGE.Name ..  ": Shifting all stacks down...")
    
    local delayCounter = 0
    
    for i = 1, RANGE. Stack.MaxStacks - 1 do
        local pilotAbove = RangeState.HoldingStack[i + 1]
        
        if pilotAbove then
            RangeState.HoldingStack[i] = pilotAbove
            RangeState.HoldingStack[i + 1] = nil
            RangeState.PilotStack[pilotAbove] = i
            
            local newFL = GetStackFL(i)
            local pilot = pilotAbove
            local newStack = i
            
            env.info(RANGE.Name ..  ": " .. pilotAbove .. " moved to Stack " .. i .. " at FL" .. newFL)
            
            TIMER:New(function()
                SendComposedMessageToAll(pilot, "STACK_DESCEND", newStack .. " " .. RANGE. Messages.STACK_AT_FL.text .. " " .. GetStackFL(newStack), 10)
            end):Start(delayCounter * 6 + 2)
            
            if i == 1 then
                TIMER:New(function()
                    SendComposedMessageToAll(pilot, "STACK_YOU_ARE_NEXT", nil, 10)
                end):Start(delayCounter * 6 + 8)
            end
            
            delayCounter = delayCounter + 1
        end
    end
    
    RangeState.HoldingStack[RANGE.Stack.MaxStacks] = nil
end

function ClearAllStacks()
    for i = 1, RANGE.Stack. MaxStacks do
        RangeState.HoldingStack[i] = nil
    end
    RangeState. PilotStack = {}
    RangeState.AltitudeWarningCooldown = {}
    env.info(RANGE.Name ..  ": All stacks cleared")
end

function NotifyNextPilotInStack()
    local nextPilot = GetNextPilotInStack()
    if nextPilot then
        SendComposedMessageToAll(nextPilot, "STACK_YOU_ARE_NEXT", nil, 15)
        env.info(RANGE.Name .. ": Notified " .. nextPilot .. " - first in stack")
    end
end

-- -----------------------------------------------------------------------------
-- ALTITUDE CHECK FUNCTIONS
-- -----------------------------------------------------------------------------

function CheckHoldingAltitudes()
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
            if not IsPilotRegistered(clientName) then return end
            
            local assignedStack = GetPilotStack(clientName)
            if not assignedStack then return end
            
            local unit = client:GetClientGroupUnit()
            if not unit then return end
            
            local inHold = RangeZones.HOLD and unit:IsInZone(RangeZones. HOLD)
            if not inHold then return end
            
            local currentAltFt = unit:GetAltitude() * 3.28084
            local assignedAltFt = GetStackAltitudeFt(assignedStack)
            local tolerance = RANGE.Stack.ToleranceFt
            
            local altDiff = math.abs(currentAltFt - assignedAltFt)
            
            if altDiff > tolerance then
                local lastWarning = RangeState.AltitudeWarningCooldown[clientName] or 0
                
                if currentTime - lastWarning >= RANGE. Timers. ALTITUDE_WARNING_COOLDOWN then
                    RangeState.AltitudeWarningCooldown[clientName] = currentTime
                    
                    local assignedFL = GetStackFL(assignedStack)
                    local currentFL = math.floor(currentAltFt / 100)
                    
                    env.info(RANGE.Name ..  ": " .. clientName .. " altitude warning - assigned FL" .. 
                             assignedFL .. ", current FL" .. currentFL .. " (diff: " .. math.floor(altDiff) .. " ft)")
                    
                    local group = client:GetGroup()
                    if group then
                        SendMessageToGroup("STACK_ALTITUDE_WARNING", group, 10, assignedFL ..  "!  (Sei a FL" .. currentFL .. ")", clientName)
                    end
                end
            end
        end
    end)
end

function StartAltitudeCheckTimer()
    if RangeState.AltitudeCheckTimer then
        RangeState.AltitudeCheckTimer:Stop()
    end
    
    RangeState.AltitudeCheckTimer = TIMER:New(function()
        CheckHoldingAltitudes()
    end):Start(5, RANGE.Timers.ALTITUDE_CHECK_INTERVAL)
    
    env.info(RANGE.Name ..  ": Altitude check timer started (every " .. RANGE.Timers. ALTITUDE_CHECK_INTERVAL ..  " sec)")
end

function StopAltitudeCheckTimer()
    if RangeState. AltitudeCheckTimer then
        RangeState.AltitudeCheckTimer:Stop()
        RangeState.AltitudeCheckTimer = nil
        env.info(RANGE.Name .. ": Altitude check timer stopped")
    end
end

-- -----------------------------------------------------------------------------
-- V10: ZONE CHECK FUNCTIONS (Auto-checkout)
-- -----------------------------------------------------------------------------

function CheckTrainingAreaPresence()
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
            if not IsPilotRegistered(clientName) then return end
            
            local unit = client:GetClientGroupUnit()
            if not unit then return end
            
            local inTrainingArea = RangeZones. TRAINING_AREA and unit:IsInZone(RangeZones.TRAINING_AREA)
            
            if inTrainingArea then
                -- Dentro zona: reset timer
                if RangeState.CheckoutTimers[clientName] then
                    RangeState.CheckoutTimers[clientName] = nil
                    env.info(RANGE.Name .. ": " .. clientName ..  " returned to training area, checkout timer reset")
                end
            else
                -- Fuori zona: avvia o controlla timer
                if not RangeState.CheckoutTimers[clientName] then
                    RangeState.CheckoutTimers[clientName] = currentTime
                    env.info(RANGE.Name .. ": " .. clientName .. " left training area, starting checkout timer")
                else
                    local timeOutside = currentTime - RangeState.CheckoutTimers[clientName]
                    
                    if timeOutside >= RANGE.Timers.AUTO_CHECKOUT_DELAY then
                        env.info(RANGE.Name ..  ": " .. clientName .. " auto-checked out (3 min outside area)")
                        
                        local group = client:GetGroup()
                        if group then
                            SendMessageToGroup("AUTO_CHECKOUT", group, 15, nil, clientName)
                        end
                        
                        UnregisterPilot(clientName)
                    end
                end
            end
        end
    end)
end

function StartZoneCheckTimer()
    if RangeState.ZoneCheckTimer then
        RangeState. ZoneCheckTimer:Stop()
    end
    
    RangeState.ZoneCheckTimer = TIMER:New(function()
        CheckTrainingAreaPresence()
    end):Start(5, RANGE.Timers. ZONE_CHECK_INTERVAL)
    
    env.info(RANGE.Name .. ": Zone check timer started (every " .. RANGE.Timers.ZONE_CHECK_INTERVAL .. " sec)")
end

function StopZoneCheckTimer()
    if RangeState.ZoneCheckTimer then
        RangeState.ZoneCheckTimer:Stop()
        RangeState.ZoneCheckTimer = nil
        env.info(RANGE.Name .. ": Zone check timer stopped")
    end
end

-- -----------------------------------------------------------------------------
-- EGRESS FUNCTION
-- -----------------------------------------------------------------------------

function ClientCallEgress()
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
        env. info(RANGE.Name .. ": EGRESS called but no client found")
        return
    end
    
    env.info(RANGE.Name ..  ": EGRESS called by " .. callerName)
    
    if currentState ~= "OCCUPIED" then
        SendMessageToGroup("EGRESS_NOT_OCCUPIED", callerGroup, 10, nil, callerName)
        env.info(RANGE.Name ..  ": EGRESS rejected - range not occupied")
        return
    end
    
    if RangeState.ActiveClient ~= callerName then
        SendMessageToGroup("EGRESS_WRONG", callerGroup, 10, nil, callerName)
        env.info(RANGE.Name ..  ": EGRESS rejected - " .. callerName .. " is not the active client")
        return
    end
    
    env.info(RANGE.Name ..  ": EGRESS accepted from " .. callerName)
    SendComposedMessageToAll(callerName, "EGRESS_SUCCESS", nil, 10)
    
    local previousClient = RangeState.ActiveClient
    
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    
    if GetHoldingCount() > 0 then
        TIMER:New(function()
            SendComposedMessageToAll(previousClient, "EGRESS_BACK_TO_HOLD", nil, 10)
        end):Start(6)
        RangeState. CanReattackDirectly = nil
        RangeFSM:EgressWithQueue()
    else
        TIMER:New(function()
            SendComposedMessageToAll(previousClient, "EGRESS_REATTACK", nil, 10)
        end):Start(6)
        RangeState. CanReattackDirectly = previousClient
        RangeFSM:EgressNoQueue()
    end
end

-- -----------------------------------------------------------------------------
-- V10: SISTEMA REGISTRAZIONE PILOTI (CORRETTO)
-- -----------------------------------------------------------------------------

function RegisterPilot(pilotName)
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

function UnregisterPilot(pilotName)
    if not pilotName then return false end
    
    if not RangeState.RegisteredPilots[pilotName] then
        env.info(RANGE.Name .. ": " ..  pilotName .. " not registered, cannot unregister")
        return false
    end
    
    -- Rimuovi da stack se presente
    if IsPilotInHolding(pilotName) then
        local removedStack = RemovePilotFromStack(pilotName)
        if removedStack then
            ShiftStacksDown()
        end
    end
    
    -- Se era il pilota attivo, gestisci egress forzato
    if RangeState.ActiveClient == pilotName then
        RangeState.ActiveClient = nil
        RangeState.ActiveClientEnteredArea = false
        local currentState = RangeFSM:GetState()
        if currentState == "OCCUPIED" then
            if GetHoldingCount() > 0 then
                RangeFSM:EgressWithQueue()
            else
                RangeFSM:EgressNoQueue()
            end
        end
    end
    
    RangeState.RegisteredPilots[pilotName] = nil
    RangeState.CheckoutTimers[pilotName] = nil
    RangeState.AltitudeWarningCooldown[pilotName] = nil
    
    -- Pulisci anche reattack se era lui
    if RangeState. CanReattackDirectly == pilotName then
        RangeState.CanReattackDirectly = nil
    end
    
    env.info(RANGE.Name .. ": " .. pilotName .. " checked out from range")
    return true
end

function IsPilotRegistered(pilotName)
    if not pilotName then return false end
    return RangeState.RegisteredPilots[pilotName] == true
end

function GetRegisteredCount()
    local count = 0
    for _ in pairs(RangeState. RegisteredPilots) do
        count = count + 1
    end
    return count
end

function GetRegisteredPilotsList()
    local list = {}
    for pilotName, _ in pairs(RangeState.RegisteredPilots) do
        table.insert(list, pilotName)
    end
    return list
end

function ClearAllRegistrations()
    RangeState.RegisteredPilots = {}
    RangeState.CheckoutTimers = {}
    env.info(RANGE.Name ..  ": All registrations cleared")
end

-- V10: CORRETTO - Itera sui client registrati e esegue azione
function ForEachRegisteredClient(actionFunc)
    local allClients = SET_CLIENT:New():FilterActive():FilterCoalitions("blue"):FilterStart()
    
    allClients:ForEachClient(function(client)
        if client and client:IsAlive() then
            local clientName = client:GetPlayerName()
            if clientName and IsPilotRegistered(clientName) then
                actionFunc(client)
            end
        end
    end)
end

-- V10: CORRETTO - Itera sui client nella Training Area e esegue azione
function ForEachClientInTrainingArea(actionFunc)
    if not RangeZones. TRAINING_AREA then
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
            if unit and unit:IsInZone(RangeZones. TRAINING_AREA) then
                actionFunc(client)
            end
        end
    end)
end

-- -----------------------------------------------------------------------------
-- V10: AUDIO FUNCTIONS CON FILTRO REGISTRATI (CORRETTO)
-- -----------------------------------------------------------------------------

function PlaySoundToRegistered(soundFile)
    if not soundFile then 
        env.info(RANGE.Name .. ": PlaySoundToRegistered - no sound file provided")
        return 
    end
    
    local fullPath = RANGE.SoundPath .. soundFile
    local currentTime = timer.getTime()
    
    local playTime = math.max(currentTime, RangeState.NextSoundTime)
    local delay = playTime - currentTime
    
    RangeState.NextSoundTime = playTime + RANGE. Timers. SOUND_DELAY
    
    env.info(RANGE.Name .. ": Queued sound to registered: " .. fullPath ..  " (delay: " .. string.format("%.1f", delay) .. "s)")
    
    if delay > 0.1 then
        TIMER:New(function()
            ForEachRegisteredClient(function(client)
                local group = client:GetGroup()
                if group then
                    USERSOUND:New(fullPath):ToGroup(group)
                end
            end)
            env.info(RANGE.Name ..  ": Playing sound NOW to registered: " .. fullPath)
        end):Start(delay)
    else
        ForEachRegisteredClient(function(client)
            local group = client:GetGroup()
            if group then
                USERSOUND:New(fullPath):ToGroup(group)
            end
        end)
        env.info(RANGE.Name .. ": Playing sound NOW to registered: " .. fullPath)
    end
end

-- V10: CORRETTO - Suono broadcast a TUTTI nella Training Area (per ABORT)
function PlaySoundToTrainingArea(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath ..  soundFile
    
    ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound to training area: " .. fullPath)
end

function PlaySoundToGroup(soundFile, group)
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

function PlaySoundDirect(soundFile)
    if not soundFile then return end
    
    local fullPath = RANGE.SoundPath ..  soundFile
    
    -- V10: Suono diretto solo ai registrati
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            USERSOUND:New(fullPath):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. ": Playing sound DIRECT to registered: " .. fullPath)
end

-- V10: CORRETTO - Messaggio a tutti i registrati
function SendMessageToRegistered(messageKey, duration, extraText)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
        return
    end
    
    local text = msgData.text
    if extraText then
        text = text ..  " " .. extraText
    end
    
    if msgData.sound then
        PlaySoundToRegistered(msgData.sound)
    end
    
    -- Messaggio solo ai registrati
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

-- V10: CORRETTO - Broadcast a tutti nella Training Area (per ABORT e messaggi critici)
function SendBroadcastToTrainingArea(messageKey, duration, extraText)
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
        PlaySoundToTrainingArea(msgData.sound)
    end
    
    ForEachClientInTrainingArea(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name ..  ": " .. text, duration or 10):ToGroup(group)
        end
    end)
end

-- V10: MODIFICATO - SendMessageToAll ora invia solo ai registrati
function SendMessageToAll(messageKey, duration, extraText)
    SendMessageToRegistered(messageKey, duration, extraText)
end

function SendMessageToGroup(messageKey, group, duration, extraText, prefix)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE.Name .. ": WARNING - Message key not found: " ..  tostring(messageKey))
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
        PlaySoundToGroup(msgData.sound, group)
    end
    
    if group then
        MESSAGE:New(text, duration or 10):ToGroup(group)
    end
end

-- V10: CORRETTO - SendComposedMessageToAll ora invia solo ai registrati
function SendComposedMessageToAll(prefix, messageKey, extraText, duration)
    local msgData = RANGE.Messages[messageKey]
    if not msgData then
        env.info(RANGE. Name .. ": WARNING - Message key not found: " .. tostring(messageKey))
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
        PlaySoundToRegistered(msgData.sound)
    end
    
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name .. ": " ..  text, duration or 10):ToGroup(group)
        end
    end)
end

-- -----------------------------------------------------------------------------
-- CLIENT ZONE DETECTION
-- -----------------------------------------------------------------------------

function CheckClientPositions()
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
            local inArea = RangeZones. AREA and unit:IsInZone(RangeZones. AREA)
            
            -- V10: Solo piloti registrati possono interagire col range
            local isRegistered = IsPilotRegistered(clientName)
            
            -- STATO: GREEN/INIT/ABORT - Range non attivo
            if currentState == "GREEN" or currentState == "INIT" or currentState == "ABORT" then
                if (inHold or inIP or inArea) and isRegistered then
                    if group then
                        SendMessageToGroup("RANGE_STAY_CLEAR", group, 5, "(" ..  currentState .. ")", clientName)
                    end
                end
            
            -- STATO: HOT - Range attivo, in attesa di client
            elseif currentState == "HOT" then
                if inHold then
                    if isRegistered and not IsPilotInHolding(clientName) then
                        if RangeState.CanReattackDirectly == clientName then
                            RangeState.CanReattackDirectly = nil
                            env.info(RANGE.Name ..  ": " .. clientName .. " entered HOLD, reattack authorization cleared")
                        end
                        -- V10: Stack già assegnato al CHECK-IN, non aggiungere qui
                    elseif not isRegistered then
                        -- V10 FIX: Cooldown per evitare spam del messaggio
                        local currentTime = timer.getTime()
                        local lastWarning = RangeState.HoldNotRegisteredCooldown[clientName] or 0
                        
                        if currentTime - lastWarning >= RANGE. Timers.HOLD_NOT_REGISTERED_COOLDOWN then
                            RangeState.HoldNotRegisteredCooldown[clientName] = currentTime
                            SendMessageToGroup("HOLD_NOT_REGISTERED", group, 10, nil, clientName)
                            env.info(RANGE.Name .. ": " ..  clientName .. " in HOLD without check-in")
                        end
                    end
                end
                
                if inIP and isRegistered then
                    local nextPilot = GetNextPilotInStack()
                    
                    if RangeState. CanReattackDirectly == clientName then
                        env. info(RANGE.Name .. ": " .. clientName .. " at IP - REATTACK authorized")
                        SendComposedMessageToAll(clientName, "IP_CLEARED", nil, 10)
                        RangeState.CanReattackDirectly = nil
                        RangeState.ActiveClient = clientName
                        RangeState.ActiveClientEnteredArea = false
                        RangeFSM:ClientEntersRun()
                    
                    elseif nextPilot == clientName then
                        env.info(RANGE. Name .. ": " .. clientName .. " at IP - starting run")
                        SendComposedMessageToAll(clientName, "IP_CLEARED", nil, 10)
                        RemovePilotFromStack(clientName)
                        ShiftStacksDown()
                        RangeState. ActiveClient = clientName
                        RangeState.ActiveClientEnteredArea = false
                        RangeFSM:ClientEntersRun()
                    
                    elseif not IsPilotInHolding(clientName) then
                        if group then
                            SendMessageToGroup("IP_NOT_IN_QUEUE", group, 10, nil, clientName)
                        end
                    
                    else
                        if group then
                            SendMessageToGroup("IP_NOT_YOUR_TURN", group, 10, nil, clientName)
                        end
                    end
                end
            
            -- STATO: OCCUPIED - Un client sta attaccando
            elseif currentState == "OCCUPIED" then
                if inHold then
                    if isRegistered and not IsPilotInHolding(clientName) then
                        if clientName ~= RangeState.ActiveClient then
                            -- V10: Stack già assegnato al CHECK-IN, non aggiungere qui
                        end
                    elseif not isRegistered then
                        -- V10 FIX: Cooldown per evitare spam del messaggio
                        local currentTime = timer.getTime()
                        local lastWarning = RangeState.HoldNotRegisteredCooldown[clientName] or 0
                        
                        if currentTime - lastWarning >= RANGE.Timers.HOLD_NOT_REGISTERED_COOLDOWN then
                            RangeState.HoldNotRegisteredCooldown[clientName] = currentTime
                            SendMessageToGroup("HOLD_NOT_REGISTERED", group, 10, nil, clientName)
                            env. info(RANGE.Name .. ": " .. clientName .. " in HOLD without check-in (OCCUPIED)")
                        end
                    end
                end
                
                if inIP and clientName ~= RangeState.ActiveClient and isRegistered then
                    if group then
                        SendMessageToGroup("IP_OCCUPIED", group, 10, nil, clientName)
                    end
                end
                
                -- AREA ENTERED - con suono diretto
                if clientName == RangeState.ActiveClient then
                    if inArea and not RangeState.ActiveClientEnteredArea then
                        RangeState.ActiveClientEnteredArea = true
                        env.info(RANGE.Name .. ": " ..  clientName .. " entered target area - PLAYING SOUND")
                        
                        -- Suono diretto (no coda per questo evento importante)
                        PlaySoundDirect("area_entered. ogg")
                        
                        -- V10 FIX: Messaggio usando ForEachRegisteredClient
                        local pilotInArea = clientName
                        ForEachRegisteredClient(function(regClient)
                            local regGroup = regClient:GetGroup()
                            if regGroup then
                                MESSAGE:New(RANGE.Name .. ": " .. pilotInArea .. " - " .. RANGE.Messages. AREA_ENTERED. text, 10):ToGroup(regGroup)
                            end
                        end)
                    end
                end
            end  -- end elseif OCCUPIED
        end  -- end if client:IsAlive()
    end)  -- end ForEachClient
end  -- end function CheckClientPositions

function StartClientCheckTimer()
    if RangeState.ClientCheckTimer then
        RangeState.ClientCheckTimer:Stop()
    end
    
    RangeState.ClientCheckTimer = TIMER:New(function()
        CheckClientPositions()
    end):Start(1, RANGE. Timers.CLIENT_CHECK_INTERVAL)
    
    env.info(RANGE.Name ..  ": Client position check timer started")
end

function StopClientCheckTimer()
    if RangeState.ClientCheckTimer then
        RangeState.ClientCheckTimer:Stop()
        RangeState.ClientCheckTimer = nil
        env.info(RANGE. Name .. ": Client position check timer stopped")
    end
end-- -----------------------------------------------------------------------------
-- TARGET & DEFENSE MANAGEMENT
-- -----------------------------------------------------------------------------

function ActivateTargets(moduleType)
    env.info(RANGE.Name ..  ": ActivateTargets called for module: " .. moduleType)
    
    if moduleType == RANGE.TrainingModules.NONE then
        env.info(RANGE.Name ..  ": No module selected, skipping target activation")
        return
    end
    
    local prefix = ModuleToPrefixMap[moduleType]
    if not prefix then
        env.info(RANGE.Name .. ": WARNING - No prefix mapping for module: " .. moduleType)
        return
    end
    
    -- V10 FIX: Pulisci la lista PRIMA di aggiungere nuovi gruppi
    -- (evita duplicati quando si riattiva dopo egress)
    RangeState.ActiveTargetGroups = {}
    
    local activatedCount = 0
    for groupName, spawnTemplate in pairs(SpawnTemplates. Targets) do
        if string.find(groupName, prefix, 1, true) == 1 then
            local spawnedGroup = spawnTemplate:ReSpawn()
            if spawnedGroup then
                table.insert(RangeState. ActiveTargetGroups, spawnedGroup)
                activatedCount = activatedCount + 1
                env.info(RANGE.Name ..  ": Spawned target group: " .. spawnedGroup:GetName())
            end
        end
    end
    
    if activatedCount > 0 then
        SendMessageToRegistered("CONFIG_MODULE", 10, moduleType ..  " - " .. activatedCount .. " gruppi attivati")
    else
        MESSAGE:New(RANGE.Name ..  ": ATTENZIONE - Nessun target trovato per " .. moduleType, 10):ToAll()
    end
end

function DeactivateAllTargets()
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

function ActivateDefenses(defenseLevel)
    env.info(RANGE.Name .. ": ActivateDefenses called for level: " .. defenseLevel)
    
    if defenseLevel == RANGE.DefenseLevels.NONE then
        env.info(RANGE. Name .. ": Defense level NONE - no defenses will be activated")
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
        for groupName, spawnTemplate in pairs(SpawnTemplates. Defenses) do
            if string.find(groupName, prefix, 1, true) == 1 then
                local spawnedGroup = spawnTemplate:ReSpawn()
                if spawnedGroup then
                    table.insert(RangeState.ActiveDefenseGroups, spawnedGroup)
                    activatedCount = activatedCount + 1
                    env.info(RANGE. Name .. ": Spawned defense group: " .. spawnedGroup:GetName())
                end
            end
        end
    end
    
    if activatedCount > 0 then
        SendMessageToRegistered("CONFIG_DEFENSE", 10, defenseLevel .. " - " .. activatedCount .. " gruppi attivati")
    end
end

function DeactivateAllDefenses()
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

-- -----------------------------------------------------------------------------
-- FSM DEFINITION
-- -----------------------------------------------------------------------------

RangeFSM = FSM:New()
RangeFSM:SetStartState("INIT")

RangeFSM:AddTransition("INIT", "Initialize", "GREEN")
RangeFSM:AddTransition("GREEN", "GoHot", "HOT")
RangeFSM:AddTransition("HOT", "ClientEntersRun", "OCCUPIED")
RangeFSM:AddTransition("HOT", "Reset", "GREEN")
RangeFSM:AddTransition("OCCUPIED", "EgressWithQueue", "HOT")
RangeFSM:AddTransition("OCCUPIED", "EgressNoQueue", "HOT")
RangeFSM:AddTransition("OCCUPIED", "Reset", "GREEN")
RangeFSM:AddTransition("*", "Abort", "ABORT")
RangeFSM:AddTransition("ABORT", "AbortComplete", "GREEN")

-- -----------------------------------------------------------------------------
-- FSM EVENT HANDLERS
-- -----------------------------------------------------------------------------

function RangeFSM:OnEnterINIT()
    -- V10: INIT message to all (broadcast)
    MESSAGE:New(RANGE.Name .. ": " .. RANGE.Messages.INIT.text, 10):ToAll()
    env.info(RANGE.Name ..  " FSM: Entered INIT state")
end

function RangeFSM:OnEnterGREEN()
    -- V10: GREEN broadcast to training area
    SendBroadcastToTrainingArea("GREEN", 15)
    env.info(RANGE.Name ..  " FSM: Entered GREEN state")
    
    ClearAllStacks()
    ClearAllRegistrations()  -- V10: Pulisci registrazioni
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    RangeState.CanReattackDirectly = nil
    RangeState.NextSoundTime = 0
    RangeState.CheckoutTimers = {}  -- V10: Reset checkout timers
    
    if RangeState.AbortTimer then
        RangeState. AbortTimer:Stop()
        RangeState.AbortTimer = nil
    end
    
    StopClientCheckTimer()
    StopAltitudeCheckTimer()
    StopZoneCheckTimer()  -- V10
    DeactivateAllTargets()
    DeactivateAllDefenses()
    
    TIMER:New(function()
        CheckAutoHot()
    end):Start(1)
end

function RangeFSM:OnEnterHOT()
    SendBroadcastToTrainingArea("HOT", 15)
    env.info(RANGE.Name ..  " FSM: Entered HOT state")
    
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    
    ActivateTargets(RangeState. SelectedModule)
    ActivateDefenses(RangeState.SelectedDefense)
    
    StartClientCheckTimer()
    StartAltitudeCheckTimer()
    StartZoneCheckTimer()
    
    -- V10: Assegna stack a tutti i piloti registrati che non sono ancora in holding
    TIMER:New(function()
        for pilotName, _ in pairs(RangeState.RegisteredPilots) do
            if not IsPilotInHolding(pilotName) then
                AddPilotToStack(pilotName, nil)
            end
        end
    end):Start(3)
    
    NotifyNextPilotInStack()
end

function RangeFSM:OnEnterOCCUPIED()
    local clientName = RangeState. ActiveClient or "UNKNOWN"
    
    PlaySoundToRegistered(RANGE.Messages. OCCUPIED.sound)
    
    -- V10 FIX: Usa ForEachRegisteredClient invece di GetRegisteredClients()
    ForEachRegisteredClient(function(client)
        local group = client:GetGroup()
        if group then
            MESSAGE:New(RANGE.Name ..  ": " ..  RANGE.Messages.OCCUPIED. text .. " - " .. clientName .. " sul target!", 10):ToGroup(group)
        end
    end)
    
    env.info(RANGE.Name .. " FSM: Entered OCCUPIED state, client: " .. clientName)
end

function RangeFSM:OnEnterABORT()
    -- V10: ABORT broadcast a TUTTI nella training area (anche non registrati)
    SendBroadcastToTrainingArea("ABORT", 20)
    env.info(RANGE.Name .. " FSM: Entered ABORT state")
    
    ClearAllStacks()
    RangeState.ActiveClient = nil
    RangeState.ActiveClientEnteredArea = false
    RangeState.CanReattackDirectly = nil
    -- V10: NON pulire registrazioni dopo abort
    
    StopClientCheckTimer()
    StopAltitudeCheckTimer()
    StopZoneCheckTimer()  -- V10
    DeactivateAllTargets()
    DeactivateAllDefenses()
    
    RangeState.AbortTimer = TIMER:New(function()
        RangeState. SelectedModule = RANGE.TrainingModules. NONE
        RangeState. SelectedDefense = RANGE. DefenseLevels.NONE
        env.info(RANGE.Name ..  ": Abort complete, transitioning to GREEN")
        RangeFSM:AbortComplete()
    end):Start(RANGE.Timers.ABORT_TO_GREEN_DELAY)
end

function RangeFSM:OnAfterEgressWithQueue()
    env.info(RANGE.Name .. " FSM: EgressWithQueue - notifying next pilot")
    TIMER:New(function()
        NotifyNextPilotInStack()
    end):Start(8)
end

function RangeFSM:OnAfterEgressNoQueue()
    env.info(RANGE.Name .. " FSM: EgressNoQueue - pilot can reattack directly")
end

-- -----------------------------------------------------------------------------
-- AUTO-HOT CHECK
-- -----------------------------------------------------------------------------

function CheckAutoHot()
    local currentState = RangeFSM:GetState()
    
    env.info(RANGE. Name ..  " CheckAutoHot: State=" .. currentState ..  
             ", Module=" .. RangeState. SelectedModule .. 
             ", Defense=" .. RangeState. SelectedDefense)
    
    local hasModule = RangeState.SelectedModule ~= RANGE.TrainingModules. NONE
    local hasDefense = RangeState.SelectedDefense ~= RANGE.DefenseLevels.NONE
    
    if currentState == "GREEN" and (hasModule or hasDefense) then
        env.info(RANGE.Name .. " CheckAutoHot: Conditions MET, transitioning to HOT")
        
        local configMsg = ""
        if hasModule and hasDefense then
            configMsg = "Modulo: " .. RangeState.SelectedModule .. " + Difese: " .. RangeState.SelectedDefense
        elseif hasModule then
            configMsg = "Modulo: " ..  RangeState.SelectedModule .. " (Senza difese)"
        else
            configMsg = "Solo difese: " ..  RangeState.SelectedDefense ..  " (Senza target)"
        end
        
        -- V10: Config complete broadcast a tutti
        MESSAGE:New(RANGE.Name .. ": " ..  RANGE.Messages.CONFIG_COMPLETE.text .. " - " .. configMsg, 5):ToAll()
        RangeFSM:GoHot()
    else
        env.info(RANGE. Name .. " CheckAutoHot: Conditions not met")
    end
end

-- -----------------------------------------------------------------------------
-- V10: CHECK-IN / CHECK-OUT HANDLERS
-- -----------------------------------------------------------------------------

function MenuCheckIn()
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
    
    env. info(RANGE.Name ..   ": CHECK-IN requested by " .. callerName)
    
    -- Verifica se già registrato
    if IsPilotRegistered(callerName) then
        if callerGroup then
            SendMessageToGroup("CHECKIN_ALREADY", callerGroup, 10, nil, callerName)
        end
        env.info(RANGE.Name ..  ": " .. callerName ..  " already registered")
        return
    end
    
    -- V10: Verifica se nella Training Area (se esiste)
    if RangeState.TrainingAreaAvailable and callerUnit then
        local inTrainingArea = RangeZones.TRAINING_AREA and callerUnit:IsInZone(RangeZones.TRAINING_AREA)
        
        if not inTrainingArea then
            if callerGroup then
                SendMessageToGroup("CHECKIN_OUTSIDE_ZONE", callerGroup, 10, nil, callerName)
            end
            env. info(RANGE.Name .. ": " .. callerName .. " tried to check-in from outside training area")
            return
        end
    else
        -- Training area non configurata - check-in disponibile ovunque
        if not RangeState.TrainingAreaAvailable then
            env.info(RANGE.Name .. ": Training area not available, allowing check-in from anywhere")
        end
    end
    
    -- Registra il pilota
    if RegisterPilot(callerName) then
        if callerGroup then
            SendMessageToGroup("CHECKIN_SUCCESS", callerGroup, 10, nil, callerName)
        end
        
        -- V10: Aggiungi automaticamente allo stack se il range è HOT o OCCUPIED
        local currentState = RangeFSM:GetState()
        if currentState == "HOT" or currentState == "OCCUPIED" then
            TIMER:New(function()
                if IsPilotRegistered(callerName) and not IsPilotInHolding(callerName) then
                    AddPilotToStack(callerName, callerGroup)
                end
            end):Start(2)
        end
        
        -- Notifica agli altri registrati
        local newPilot = callerName
        ForEachRegisteredClient(function(client)
            local clientName = client:GetPlayerName()
            if clientName and clientName ~= newPilot then
                local group = client:GetGroup()
                if group then
                    MESSAGE:New(RANGE.Name ..  ": " .. newPilot .. " si e' registrato al range", 5):ToGroup(group)
                end
            end
        end)
    end
end

function MenuCheckOut()
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
    if not IsPilotRegistered(callerName) then
        if callerGroup then
            SendMessageToGroup("CHECKOUT_NOT_REGISTERED", callerGroup, 10, nil, callerName)
        end
        env. info(RANGE.Name .. ": " .. callerName .. " not registered, cannot check-out")
        return
    end
    
    -- Deregistra il pilota
    if UnregisterPilot(callerName) then
        if callerGroup then
            SendMessageToGroup("CHECKOUT_SUCCESS", callerGroup, 10, nil, callerName)
        end
        
        -- V10 FIX: Notifica agli altri registrati usando ForEachRegisteredClient
        local leavingPilot = callerName  -- Salva per la closure
        ForEachRegisteredClient(function(client)
            local clientName = client:GetPlayerName()
            if clientName and clientName ~= leavingPilot then
                local group = client:GetGroup()
                if group then
                    MESSAGE:New(RANGE.Name ..  ": " ..  leavingPilot .. " ha lasciato il range", 5):ToGroup(group)
                end
            end
        end)
    end
end
-- -----------------------------------------------------------------------------
-- MENU HANDLERS
-- -----------------------------------------------------------------------------

function MenuSelectModule(moduleType)
    local currentState = RangeFSM:GetState()
    local previousModule = RangeState.SelectedModule
    
    if currentState == "HOT" and previousModule ~= moduleType then
        env.info(RANGE.Name ..  " Menu: Module change while HOT - forcing reset")
        SendBroadcastToTrainingArea("CONFIG_CHANGE_HOT", 5)
        RangeState. SelectedModule = moduleType
        RangeFSM:Reset()
        return
    end
    
    RangeState.SelectedModule = moduleType
    env.info(RANGE.Name ..  " Menu: Module selected: " ..  moduleType)
    
    -- V10: Config message broadcast
    MESSAGE:New(RANGE.Name .. ": " ..  RANGE.Messages.CONFIG_MODULE.text .. " " .. moduleType, 10):ToAll()
    
    CheckAutoHot()
end

function MenuSelectDefense(defenseLevel)
    local currentState = RangeFSM:GetState()
    local previousDefense = RangeState.SelectedDefense
    
    if currentState == "HOT" and previousDefense ~= defenseLevel then
        env.info(RANGE.Name .. " Menu: Defense change while HOT - forcing reset")
        SendBroadcastToTrainingArea("CONFIG_CHANGE_HOT", 5)
        RangeState.SelectedDefense = defenseLevel
        RangeFSM:Reset()
        return
    end
    
    RangeState.SelectedDefense = defenseLevel
    env. info(RANGE.Name .. " Menu: Defense selected: " .. defenseLevel)
    
    -- V10: Config message broadcast
    MESSAGE:New(RANGE.Name .. ": " .. RANGE. Messages.CONFIG_DEFENSE.text .. " " .. defenseLevel, 10):ToAll()
    
    CheckAutoHot()
end

function MenuSetGreen()
    env.info(RANGE.Name ..  " Menu: SET GREEN requested")
    
    RangeState.SelectedModule = RANGE.TrainingModules. NONE
    RangeState. SelectedDefense = RANGE. DefenseLevels.NONE
    
    local currentState = RangeFSM:GetState()
    
    if currentState ~= "GREEN" and currentState ~= "INIT" then
        SendBroadcastToTrainingArea("CONFIG_RESET", 5)
        RangeFSM:Reset()
    else
        MESSAGE:New(RANGE.Name ..  ": " .. RANGE.Messages.CONFIG_ALREADY_GREEN.text, 5):ToAll()
    end
end

function MenuShowStatus()
    local status = GetRangeStatusString()
    env.info(RANGE.Name .. " Menu: Status requested")
    MESSAGE:New(status, 20):ToAll()
end

function MenuEmergencyAbort()
    env.info(RANGE.Name .. " Menu: EMERGENCY ABORT requested")
    RangeFSM:Abort()
end

-- -----------------------------------------------------------------------------
-- UTILITY
-- -----------------------------------------------------------------------------

function GetRangeStatusString()
    local status = "====== " .. RANGE.Name .. " STATUS ======\n"
    status = status .. "Stato: " .. RangeFSM:GetState() ..  "\n"
    status = status .. "Modulo: " ..  RangeState.SelectedModule .. "\n"
    status = status ..  "Difese: " .. RangeState.SelectedDefense .. "\n"
    status = status .. "Target attivi: " .. #RangeState.ActiveTargetGroups .. "\n"
    status = status .. "Difese attive: " .. #RangeState.ActiveDefenseGroups .. "\n"
    
    -- V10: Sezione piloti registrati
    local registeredCount = GetRegisteredCount()
    status = status .. "Piloti registrati: " .. registeredCount ..  "\n"
    
    if registeredCount > 0 then
        status = status .. "--- REGISTRAZIONI ---\n"
        for pilotName, _ in pairs(RangeState. RegisteredPilots) do
            local pilotStatus = "in attesa"
            local stackNum = GetPilotStack(pilotName)
            
            if pilotName == RangeState.ActiveClient then
                pilotStatus = "ATTIVO sul target"
            elseif stackNum then
                local fl = GetStackFL(stackNum)
                pilotStatus = "Stack " .. stackNum .. ", FL" .. fl
            elseif pilotName == RangeState. CanReattackDirectly then
                pilotStatus = "reattack autorizzato"
            end
            
            status = status .. "  - " .. pilotName .. " (" .. pilotStatus .. ")\n"
        end
    end
    
    local holdingCount = GetHoldingCount()
    status = status .. "Piloti in HOLD: " .. holdingCount .. "/" ..  RANGE.Stack.MaxStacks .. "\n"
    
    if holdingCount > 0 then
        status = status .. "--- STACK HOLDING ---\n"
        for i = 1, RANGE.Stack.MaxStacks do
            local pilot = RangeState.HoldingStack[i]
            if pilot then
                local fl = GetStackFL(i)
                status = status .. "  Stack " .. i .. " (FL" .. fl .. "): " .. pilot ..  "\n"
            end
        end
    end
    
    status = status .. "Pilota attivo: " .. (RangeState.ActiveClient or "Nessuno") .. "\n"
    
    if RangeState.ActiveClient then
        status = status .. "Nell'area target: " .. (RangeState.ActiveClientEnteredArea and "Si" or "No") .. "\n"
    end
    
    if RangeState. CanReattackDirectly then
        status = status .. "Reattack autorizzato: " ..  RangeState.CanReattackDirectly .. "\n"
    end
    
    -- V10: Training Area status
    status = status .. "Training Area: " .. (RangeState.TrainingAreaAvailable and "Configurata" or "NON configurata") .. "\n"
    
    status = status .. "================================"
    return status
end

-- -----------------------------------------------------------------------------
-- MENU CREATION
-- -----------------------------------------------------------------------------

function CreateRangeMenu()
    env. info(RANGE.Name .. ": Creating F10 menu...")
    
    local mainMenu = MENU_MISSION:New(RANGE.Name)
    
    -- V10: Sottomenu configurazione
    local configMenu = MENU_MISSION:New("CONFIGURA IL RANGE", mainMenu)
    
    local moduleMenu = MENU_MISSION:New("Seleziona Modulo", configMenu)
    MENU_MISSION_COMMAND:New("Static Bombing", moduleMenu, MenuSelectModule, RANGE.TrainingModules.STATIC_BOMBING)
    MENU_MISSION_COMMAND:New("Convoy", moduleMenu, MenuSelectModule, RANGE.TrainingModules. CONVOY)
    MENU_MISSION_COMMAND:New("Pop-Up", moduleMenu, MenuSelectModule, RANGE.TrainingModules. POPUP)
    MENU_MISSION_COMMAND:New("Urban", moduleMenu, MenuSelectModule, RANGE.TrainingModules. URBAN)
    
    local defenseMenu = MENU_MISSION:New("Seleziona Difese", configMenu)
    MENU_MISSION_COMMAND:New("Nessuna", defenseMenu, MenuSelectDefense, RANGE.DefenseLevels.NONE)
    MENU_MISSION_COMMAND:New("Basse", defenseMenu, MenuSelectDefense, RANGE.DefenseLevels.LOW)
    MENU_MISSION_COMMAND:New("Medie", defenseMenu, MenuSelectDefense, RANGE.DefenseLevels.MEDIUM)
    MENU_MISSION_COMMAND:New("Alte", defenseMenu, MenuSelectDefense, RANGE.DefenseLevels.HIGH)
    
    -- V10: CHECK-IN / CHECK-OUT
    MENU_MISSION_COMMAND:New(">>> CHECK-IN RANGE <<<", mainMenu, MenuCheckIn)
    MENU_MISSION_COMMAND:New(">>> CHECK-OUT RANGE <<<", mainMenu, MenuCheckOut)
    
    -- Egress
    MENU_MISSION_COMMAND:New(">>> CHIAMA EGRESS <<<", mainMenu, ClientCallEgress)
    
    -- Altre opzioni
    MENU_MISSION_COMMAND:New("RANGE VERDE (Reset)", mainMenu, MenuSetGreen)
    MENU_MISSION_COMMAND:New("Mostra Stato", mainMenu, MenuShowStatus)
    MENU_MISSION_COMMAND:New("! !!  ABORT EMERGENZA !!!", mainMenu, MenuEmergencyAbort)
    
    env.info(RANGE.Name .. ": F10 menu created successfully")
end

-- -----------------------------------------------------------------------------
-- INITIALIZATION
-- -----------------------------------------------------------------------------

function InitializeRange()
    env.info(RANGE.Name .. ": Starting initialization V10...")
    
    InitializeZones()
    InitializeSpawnTemplates()
    CreateRangeMenu()
    
    -- V10: Avviso se Training Area manca
    if not RangeState.TrainingAreaAvailable then
        MESSAGE:New(RANGE.Name ..  ": " .. RANGE.Messages.TRAINING_AREA_MISSING.text, 15):ToAll()
        env. info(RANGE.Name .. ": WARNING - Training Area not configured, check-in available everywhere")
    end
    
    RangeFSM:Initialize()
    
    env.info(RANGE. Name .. ": Initialization complete V10, current state: " .. RangeFSM:GetState())
end

TIMER:New(function()
    InitializeRange()
end):Start(1)

-- =============================================================================
-- FINE DONKEY'S RANGE V10
-- =============================================================================