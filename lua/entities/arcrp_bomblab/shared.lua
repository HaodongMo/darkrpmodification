ENT.Base = "arcrp_lab_base"
ENT.PrintName = "Explosives Lab"
ENT.craftTime = 1

ENT.interactionHint = "Craft random explosive"

function ENT:initVars()
    self.model = "models/props_c17/TrapPropeller_Engine.mdl"
    self.initialPrice = GAMEMODE.Config.bomblabbombcost
    self.labPhrase = DarkRP.getPhrase("explosive_lab")
    self.bountyAmount = 16000

    self:SetMaterial("phoenix_storms/wire/pcb_red")
end
