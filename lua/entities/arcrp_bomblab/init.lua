AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.SpawnOffset = Vector(0, 0, 27)

function ENT:createItem()
    // pick a random weapon, weighted, from GAMEMODE.Config.gunlabWeaponsCumulative
    local gun = table.Random(GAMEMODE.Config.bomblabWeapons)

    if gun then
        local newgun = ents.Create(gun)

        if !IsValid(newgun) then print("Invalid entity: " .. gun) return end
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z
        newgun:SetPos(newpos)
        newgun.nodupe = true
        newgun.spawnedBy = self:Getowning_ent()
        newgun:Spawn()
    end
end
