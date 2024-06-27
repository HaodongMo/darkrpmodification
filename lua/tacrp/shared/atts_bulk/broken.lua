
------------------------------
-- #region optic_broken
------------------------------
ATT = {}

ATT.PrintName = "Busted"
ATT.Icon = Material("entities/tacrp_att_optic_rds2.png", "mips smooth")
ATT.Description = "Reflex sight that seems to be out of power."

ATT.Model = "models/weapons/tacint/addons/rds2.mdl"
ATT.Scale = 1.1
ATT.ModelOffset = Vector(0, 0, -0.5)

ATT.Category = {"optic_cqb", "optic_cqb_nookp7"}

ATT.SortOrder = 999

ATT.Override_Scope = true
ATT.Override_ScopeOverlay = false
ATT.Override_ScopeFOV = 90 / 1.25
ATT.Override_ScopeLevels = 1
ATT.Override_ScopeHideWeapon = false

ATT.SightPos = Vector(0.2, -15, 1.4)
ATT.SightAng = Angle(0, 0, 0)

TacRP.LoadAtt(ATT, "optic_broken")
-- #endregion


------------------------------
-- #region optic_rmr_broken
------------------------------
ATT = {}

ATT.PrintName = "Busted"
ATT.Icon = Material("entities/tacrp_att_optic_rmr.png", "mips smooth")
ATT.Description = "Reflex sight that seems to be out of power."

ATT.Model = "models/weapons/tacint/addons/optic_rmr_hq.mdl"
ATT.Scale =  1

ATT.Category = "optic_pistol"

ATT.SortOrder = 999

ATT.Override_Scope = true
ATT.Override_ScopeOverlay = false
ATT.Override_ScopeFOV = 90 / 1.1
ATT.Override_ScopeLevels = 1
ATT.Override_ScopeHideWeapon = false

ATT.SightPos = Vector(-0.1, -10, 0.520837)
ATT.SightAng = Angle(0, 0, 0)

TacRP.LoadAtt(ATT, "optic_broken2")
-- #endregion

------------------------------
-- #region muzz_rusted
------------------------------
ATT = {}

ATT.PrintName = "Rusted Barrel"
ATT.Icon = Material("entities/tacrp_att_muzz_lbar.png", "mips smooth")
ATT.Description = "Poorly maintained barrel. You need to clean this thing."
ATT.Cons = {"stat.spread", "stat.range_max", "stat.range_min"}

ATT.Category = {"silencer", "barrel"}

ATT.SortOrder = 999

ATT.Mult_Spread = 1.25
ATT.Mult_Range_Min = 0.75
ATT.Mult_Range_Max = 0.75

TacRP.LoadAtt(ATT, "muzz_rusted")
-- #endregion

------------------------------
-- #region tac_broken
------------------------------
ATT = {}

ATT.PrintName = "Broken"
ATT.Icon = Material("entities/tacrp_att_tac_flashlight.png", "mips smooth")
ATT.Description = "Flashlight that doesn't seem to work."

ATT.Model = "models/weapons/tacint/addons/flashlight_mounted.mdl"
ATT.Scale = 1

ATT.Category = "tactical"

ATT.SortOrder = 999

TacRP.LoadAtt(ATT, "tac_broken")
-- #endregion

------------------------------
-- #region perk_untrained
------------------------------
ATT = {}

ATT.PrintName = "Untrained"
ATT.Icon = Material("entities/tacrp_att_acc_grenade.png", "mips smooth")
ATT.Description = "You've only ever seen a gun in a shitty action movie before."
ATT.Cons = {"stat.recoil", "stat.sway", "stat.hipfirespread"}

ATT.Category = "perk"

ATT.SortOrder = 999

ATT.Mult_Sway = 2
ATT.Mult_RecoilKick = 2
ATT.Mult_HipFireSpreadPenalty = 1.75

TacRP.LoadAtt(ATT, "perk_untrained")
-- #endregion

------------------------------
-- #region acc_pinnedmag
------------------------------
ATT = {}

ATT.PrintName = "Pinned"
ATT.FullName = "Pinned Mag"
ATT.Icon = Material("entities/tacrp_att_acc_extmag_rifle.png", "mips smooth")
ATT.Description = "Pinned magazines reduce capacity for legal reasons."
ATT.Cons = {"stat.clipsize"}

ATT.Category = {"perk_extendedmag", "acc_extmag_rifle2", "extendedbelt", "acc_extmag_dual", "acc_extmag_dual2", "acc_extmag_dualsmg", "acc_extmag_pistol", "acc_extmag_pistol2", "acc_extmag_shotgun", "acc_extmag_smg", "acc_extmag_sniper"}

ATT.SortOrder = 999

ATT.Mult_ClipSize = 0.5

TacRP.LoadAtt(ATT, "acc_pinnedmag")
-- #endregion

------------------------------
-- #region trigger_stuck
------------------------------
ATT = {}

ATT.PrintName = "Stuck"
ATT.FullName = "Stuck Trigger"

ATT.Icon = Material("entities/tacrp_att_trigger_semi.png", "mips smooth")
ATT.Description = "Unreliable trigger that feels pretty lousy."
ATT.Cons = {"att.procon.unreliable", "stat.recoilstability", "stat.recoilkick", "stat.bloomintensity"}

ATT.Category = {"trigger_auto", "trigger_burst", "trigger_akimbo", "trigger_burstauto", "trigger_semi", "trigger_4pos"}

ATT.SortOrder = 999

ATT.Mult_RecoilSpreadPenalty = 2
ATT.Mult_RecoilKick = 1.2
ATT.Mult_RecoilVisualKick = 2
ATT.Mult_RecoilStability = 0.6
ATT.Mult_RPM = 0.9

ATT.Add_JamFactor = 0.4

TacRP.LoadAtt(ATT, "trigger_stuck")
-- #endregion