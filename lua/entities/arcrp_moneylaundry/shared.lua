ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Laundry"
ENT.Category = "ArcRP - World"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.isMoneyLaundry = true

ENT.ScopeOutHint = "Money Laundry"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Reward")
end

ENT.contextHint = ENT.PrintName