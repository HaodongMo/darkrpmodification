-- #NoSimplerr#

CreateConVar("imde_enabled", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_recover", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)

CreateConVar("imde_wake_threshold", "0.8", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_wake_healthaffects", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_wake_mintime", "3", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)

CreateConVar("imde_charge", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_charge_downed", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0, 1)
CreateConVar("imde_charge_spend", "5", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_spend_downed", "3", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_mult", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
CreateConVar("imde_charge_mult_downed", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "", 0)
