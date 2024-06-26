ENT.Base = "arcrp_lab_base"
ENT.PrintName = "Explosives Lab"
ENT.craftTime = 5

ENT.interactionHint = "Craft random explosive"

ENT.ScopeOutHint = "Bomb Lab"

function ENT:initVars()
    self.model = "models/props_c17/TrapPropeller_Engine.mdl"
    self.initialPrice = GAMEMODE.Config.bomblabbombcost
    self.labPhrase = DarkRP.getPhrase("explosive_lab")
    self.bountyAmount = 800 * 0.9

    self:SetMaterial("phoenix_storms/wire/pcb_red")
end
