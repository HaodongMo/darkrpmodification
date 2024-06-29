ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Vending Machine"
ENT.Category = "ArcRP - World"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.isVendingMachine = true

ENT.ScopeOutHint = "Vending Machine"

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