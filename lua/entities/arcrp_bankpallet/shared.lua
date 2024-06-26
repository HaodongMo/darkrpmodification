ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bank Money Pallet"
ENT.Category = "ArcRP - World"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.isBankPallet = true

function ENT:contextHint()
    if ArcRP_BankRob.IsRobberyActive() then
        return math.Round((1 - self:GetGreedProgress() / ArcRP_BankRob.GreedTime) * 100, 1) .. "% Full - Stay near to steal more!"
    end
end

ENT.interactionHint = function(self)
    if ArcRP_BankRob.IsRobberyActive() then
        if LocalPlayer():isCP() then
            return "Return Briefcase"
        end
    elseif !LocalPlayer():isCP() then
        return "Rob"
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "GreedProgress")
end