ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Laundry"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.isMoneyLaundry = true

ENT.interactionHint = "Retrieve Laundered Money"

function ENT:GetContextMenu(player)
    return {
        {
            message = "Retrieve Laundered Money",
            callback = function(ent, ply)
                ent:GetMoney(ply, ply)
            end,
        }
    }
end