ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Briefcase"
ENT.Author = "Arctic"
ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.isBankBriefcase = true
ENT.amount = 0
ENT.unPocketAble = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Reward")
    self:NetworkVar("Float", 1, "TimeoutEnd")
end

ENT.contextHint = function(self)
    if !LocalPlayer():isCP() then
        return DarkRP.formatMoney(math.ceil(self:GetReward())) .. " (" .. string.ToMinutesSeconds(self:GetTimeoutEnd() - CurTime()) .. " until Expiry)"
    else
        return "Return to bank"
    end
end