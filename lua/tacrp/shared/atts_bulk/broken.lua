------------------------------
-- #region blocker
------------------------------
ATT = {}

ATT.PrintName = "Broken"
ATT.Icon = Material("entities/tacrp_att_blocker.png", "mips smooth")
ATT.Description = "This slot has been permanently damaged."

ATT.Category = "*"

ATT.Hidden = true

ATT.Compatibility = function(slot, att)
    return false
end

ATT.SortOrder = 999

ATT.Add_JamFactor = 0.15

ATT.Mult_Spread = 1.1
ATT.Mult_Damage_Max = 0.95
ATT.Mult_Damage_Min = 0.95
ATT.Mult_RecoilKick = 1.05
ATT.Mult_ClipSize = 0.95

ATT.IsBlocker = true

TacRP.LoadAtt(ATT, "blocker")
-- #endregion

------------------------------
-- #region irons_blocker
------------------------------
ATT = {}

ATT.PrintName = "Broken"
ATT.Icon = Material("entities/tacrp_att_blocker.png", "mips smooth")
ATT.Description = "This slot has been permanently damaged."

ATT.Category = "*"

ATT.Compatibility = function(slot, att)
    return false
end

ATT.Hidden = true

ATT.SortOrder = 999

ATT.Add_JamFactor = 0.15

ATT.Mult_Spread = 1.1
ATT.Mult_Damage_Max = 0.95
ATT.Mult_Damage_Min = 0.95
ATT.Mult_RecoilKick = 1.05
ATT.Mult_ClipSize = 0.95

ATT.Override_ScopeHideWeapon = false
ATT.Override_ScopeOverlay = false
ATT.Override_ScopeFOV = 90 / 1.1
ATT.Override_ScopeLevels = 1

ATT.IsBlocker = true

TacRP.LoadAtt(ATT, "irons_blocker")
-- #endregion