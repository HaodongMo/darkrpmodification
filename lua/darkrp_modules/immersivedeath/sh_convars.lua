-- #NoSimplerr#

CreateConVar("imde_enabled", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_recover", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Rate of stamina recovery, higher is faster. Affected by balance.", 0)
CreateConVar("imde_recover_down", "0.5", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Rate of stamina recovery while down, higher is faster. Being down for longer increases recovery rate.", 0)
CreateConVar("imde_recover_balance", "0.5", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Rate of balance recovery after taking damage, higher is faster.", 0)

CreateConVar("imde_oneshot_protection", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Get knocked down on a lethal hit instead of dying. 0 - Disabled. 1 - Chance to survive non-headshot hit. 2 - Always survive non-headshot hit. 3 - Always survive.", 0, 3)

CreateConVar("imde_wake_threshold", "0.8", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Amount of stamina needed to get up again.", 0, 1)
CreateConVar("imde_wake_healthaffects", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Lower health will increase stamina required to wake up.", 0, 1)
CreateConVar("imde_wake_mintime", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum amount of time to wake up.", 0)

CreateConVar("imde_charge", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_charge_downed", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_charge_spend", "5", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_spend_downed", "3", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_mult", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_mult_downed", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
