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

ENT.DefaultCapacity = 15
ENT.DefaultConnections = 4

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "FuelExpireTime")
    self:NetworkVar("Int", 0, "ConnectedEntityAmount")
    self:NetworkVar("Int", 1, "CapacityUpgrades")
    self:NetworkVar("Int", 2, "ConnectionUpgrades")
    self:NetworkVar("Entity", 0, "owning_ent")

    self:SetFuelExpireTime(0)
end

function ENT:IsPowered()
    return self:GetFuelExpireTime() > CurTime()
end

function ENT:GetMaxConnectedEntities()
    return self.DefaultConnections + (2 * self:GetConnectionUpgrades())
end

function ENT:GetCapacity()
    return 60 * (self.DefaultCapacity + (5 * self:GetCapacityUpgrades()))
end

function ENT:GetFuelTime()
    return math.max(0, self:GetFuelExpireTime() - CurTime())
end

function ENT:contextHint()
    local fueltime = self:GetFuelTime()
    local maxfueltime = self:GetCapacity()

    return "FUEL " .. string.FormattedTime( fueltime, "%02i:%02i" ) .. "/" .. string.FormattedTime( maxfueltime, "%02i:%02i" ) .. " | " .. tostring(self:GetConnectedEntityAmount()) .. "/" .. self:GetMaxConnectedEntities() .. " CONN" 
end


function ENT:GetContextMenu(player)
    local tbl = {}

    if self:GetConnectedEntityAmount() > 0 then
        table.insert(tbl, {
            message = "Disconnect",
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:EmitSound("ambient/machines/keyboard7_clicks_enter.wav")
                ent:DisconnectAll()
            end,
        })
    end

    return tbl
end