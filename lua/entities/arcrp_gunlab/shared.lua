ENT.Base = "arcrp_lab_base"
ENT.PrintName = "Gun Lab"
ENT.craftTime = 10

ENT.interactionHint = "Craft random weapon"

function ENT:initVars()
    self.model = "models/props_c17/TrapPropeller_Engine.mdl"
    self.initialPrice = GAMEMODE.Config.gunlabguncost
    self.labPhrase = DarkRP.getPhrase("gun_lab")
    self.itemPhrase = DarkRP.getPhrase("gun")
    self.bountyAmount = 1000 * 0.9

    self:SetMaterial("phoenix_storms/wire/pcb_green")
end
