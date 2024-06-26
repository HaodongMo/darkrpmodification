--[[---------------------------------------------------------------------------
Base power-receiving entity that others can derive from.
---------------------------------------------------------------------------]]
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base Powerable"
ENT.Author = "arctic arc9"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Entity", 1, "Generator")

    self:SetupOtherDataTables()
end

function ENT:SetupOtherDataTables()
end

function ENT:IsPowered()
    if !IsValid(self:GetGenerator()) then return false end

    return self:GetGenerator():IsPowered()
end