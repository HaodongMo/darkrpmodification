ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Vending Machine"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.isVendingMachine = true

function ENT:GetContextMenu(player)
    return {
        {
            message = "Buy Weapons",
            cl_callback = function(ent2, ply2)
                ArcRP_OpenVendingMachine()
            end,
        }
    }
end