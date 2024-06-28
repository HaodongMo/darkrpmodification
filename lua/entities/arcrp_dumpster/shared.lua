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
    local tbl = {
        {
            message = "Scavenge",
            callback = self.Scavenge or true,
            interacttime = 2.5,
        },
    }

    local wep = player:GetActiveWeapon()

    if IsValid(wep) and weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        table.insert(tbl, {
            message = "Dispose of Weapon",
            callback = self.DisposeWeapon or true,
            interacttime = 1,
        })
    end

    return tbl
end