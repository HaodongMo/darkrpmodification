ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dumpster"
ENT.Author = "Arctic"
ENT.Category = "ArcRP - World"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.isGunDumpster = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "NextScavengeTime")
    self:SetNextScavengeTime(0)
end

function ENT:GetContextMenu(player)
    return {
        {
            message = "Scavenge",
            callback = self.Scavenge or true
        },
        {
            message = "Dispose of Weapon",
            callback = self.DisposeWeapon or true
        }
    }
end