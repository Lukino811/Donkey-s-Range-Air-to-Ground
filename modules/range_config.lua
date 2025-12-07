-- =============================================================================
-- RANGE CONFIGURATION MODULE
-- All constants, setup values, mappings, zone names, presets, lookup tables
-- =============================================================================

local RangeConfig = {}

RangeConfig.RANGE = {
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
            sound = "init.ogg"
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
            text = "!!! ABORT DI EMERGENZA !!! - Tutti gli aerei sganciate e uscite IMMEDIATAMENTE!",
            sound = "abort.ogg"
        },
        
        -- V10: Messaggi CHECK-IN/CHECK-OUT
        CHECKIN_SUCCESS = {
            text = "CHECK-IN confermato, benvenuto al range!",
            sound = "checkin_success.ogg"
        },
        CHECKIN_OUTSIDE_ZONE = {
            text = "Devi essere nell'area training per fare CHECK-IN!",
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
            text = "Devi fare CHECK-IN al range prima di entrare in HOLD! (F10 menu)",
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
            text = "HOLDING PIENO! Massimo 6 aerei. Rimani fuori dalla zona e attendi.",
            sound = "stack_full.ogg"
        },
        STACK_ALTITUDE_WARNING = {
            text = "EHI! Mantieni la tua quota assegnata! Dovresti essere a FL",
            sound = "stack_altitude_warning.ogg"
        },
        STACK_DESCEND = {
            text = "Scendi al nuovo stack! Ora sei Stack",
            sound = "stack_descend.ogg"
        },
        STACK_YOU_ARE_NEXT = {
            text = "Sei al primo stack - procedi all'IP quando pronto!",
            sound = "stack_you_are_next.ogg"
        },
        
        IP_CLEARED = {
            text = "AUTORIZZATO HOT! Buon divertimento!",
            sound = "ip_cleared.ogg"
        },
        IP_NOT_IN_QUEUE = {
            text = "Ehi! Prima entra in HOLD, non fare il furbo!",
            sound = "ip_not_in_queue.ogg"
        },
        IP_NOT_YOUR_TURN = {
            text = "Calma cowboy! Non e' il tuo turno!",
            sound = "ip_not_your_turn.ogg"
        },
        IP_OCCUPIED = {
            text = "Range OCCUPATO! Torna in HOLD!",
            sound = "ip_occupied.ogg"
        },
        
        AREA_ENTERED = {
            text = "Nell'area target - WEAPONS FREE!",
            sound = "area_entered.ogg"
        },
        
        EGRESS_SUCCESS = {
            text = "EGRESS confermato. Ottimo lavoro!",
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
            text = "Stai calmo, non stai sganciando niente! Non sei tu il pilota attivo.",
            sound = "egress_wrong.ogg"
        },
        EGRESS_NOT_OCCUPIED = {
            text = "Ma che egress vuoi fare? Il range non e' nemmeno occupato!",
            sound = "egress_not_occupied.ogg"
        },
        
        RANGE_NOT_ACTIVE = {
            text = "Il range e' in stato",
            sound = nil
        },
        RANGE_STAY_CLEAR = {
            text = "Stai alla larga!",
            sound = "range_stay_clear.ogg"
        },
        
        CONFIG_COMPLETE = {
            text = "Configurazione completata - Attivazione range...",
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
            text = "Reset del range a VERDE...",
            sound = "config_reset.ogg"
        },
        CONFIG_ALREADY_GREEN = {
            text = "Il range e' gia' VERDE, rilassati!",
            sound = "config_already_green.ogg"
        },
        CONFIG_CHANGE_HOT = {
            text = "Riconfigurazione - Prima torno a VERDE...",
            sound = "config_reset.ogg"
        },
        
        PILOTS_AHEAD = {
            text = "Aerei davanti a te:",
            sound = "pilots_ahead.ogg"
        }
    }
}

RangeConfig.ModuleToPrefixMap = {
    [RangeConfig.RANGE.TrainingModules.STATIC_BOMBING] = RangeConfig.RANGE.GroupPrefixes.TARGET_STATIC,
    [RangeConfig.RANGE.TrainingModules.CONVOY] = RangeConfig.RANGE.GroupPrefixes.TARGET_CONVOY,
    [RangeConfig.RANGE.TrainingModules.POPUP] = RangeConfig.RANGE.GroupPrefixes.TARGET_POPUP,
    [RangeConfig.RANGE.TrainingModules.URBAN] = RangeConfig.RANGE.GroupPrefixes.TARGET_URBAN
}

RangeConfig.DefenseToPrefixMap = {
    [RangeConfig.RANGE.DefenseLevels.NONE] = {},
    [RangeConfig.RANGE.DefenseLevels.LOW] = { RangeConfig.RANGE.GroupPrefixes.DEFENSE_LOW },
    [RangeConfig.RANGE.DefenseLevels.MEDIUM] = { RangeConfig.RANGE.GroupPrefixes.DEFENSE_MED },
    [RangeConfig.RANGE.DefenseLevels.HIGH] = { RangeConfig.RANGE.GroupPrefixes.DEFENSE_HIGH }
}

return RangeConfig
