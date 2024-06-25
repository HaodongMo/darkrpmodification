--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Power Generator"
ENT.Author = "arctic arc9"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.IsGenerator = true

ENT.ConnectedEntities = {}

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "FuelExpireTime")
    self:NetworkVar("Int", 0, "ConnectedEntityAmount")
    self:NetworkVar("Int", 1, "CapacityUpgrades")
    self:NetworkVar("Entity", 0, "owning_ent")

    self:SetFuelExpireTime(0)
end

function ENT:IsPowered()
    return self:GetFuelExpireTime() > CurTime()
end

function ENT:GetCapacity()
    return 60 * 15
end

function ENT:GetFuelTime()
    return math.max(0, self:GetFuelExpireTime() - CurTime())
end

function ENT:contextHint()
    local fueltime = self:GetFuelTime()
    local maxfueltime = self:GetCapacity()

    return "FUEL " .. string.FormattedTime( fueltime, "%02i:%02i" ) .. "/" .. string.FormattedTime( maxfueltime, "%02i:%02i" )
end