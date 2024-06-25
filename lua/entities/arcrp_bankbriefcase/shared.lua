ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Briefcase"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.isBankBriefcase = true
ENT.amount = 0

ENT.interactionHint = function()
    if LocalPlayer():isCP() then
        return "Return to bank"
    end
end

ENT.contextHint = function()
    if !LocalPlayer():isCP() then
        return "Cash out at a Money Laundry"
    end
end