--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.bountyAmount = 200
ENT.PoweredSound = "ambient/machines/machine3.wav"
ENT.Model = "models/props_vehicles/generatortrailer01.mdl"
ENT.PowerCablePos = Vector(-64, 0, 24)
ENT.NextUse = 0

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.sparking = false
    self:SetHealth(400)

    self:SetTrigger(true)
end

function ENT:PowerOn()
    self:StartSound()

    self:UpdatePowerState()

    for i, ent in pairs(self.ConnectedEntities) do
        ent:UpdatePowerState()
    end
end

function ENT:PowerOff()
    self:SoundStop()

    self:UpdatePowerState()

    for i, ent in pairs(self.ConnectedEntities) do
        ent:UpdatePowerState()
    end
end

function ENT:UpdatePowerState()
    self:SetConnectedEntityAmount(#self.ConnectedEntities)
end

function ENT:Disconnect(entity)
    table.RemoveByValue(self.ConnectedEntities, entity)
    self:UpdatePowerState()

    SafeRemoveEntity(entity.PowerCable)
end

function ENT:DisconnectAll()
    local entstodisconnect = table.Copy(self.ConnectedEntities)
    for _, ent in pairs(entstodisconnect) do
        ent:Disconnect(self)
        self:Disconnect(ent)
    end
end

function ENT:Connect(entity)
    table.insert(self.ConnectedEntities, entity)
    self:UpdatePowerState()

    SafeRemoveEntity(entity.PowerCable)
    entity.PowerCable = constraint.Rope(self, entity, 0, 0, self.PowerCablePos, Vector(0, 0, 0), 512, 0, 64, 2, "cable/cable2", false)
end

function ENT:StartSound()
    if !self.Sound then
        self:EmitSound("ambient/machines/spinup.wav")
    end
    self.Sound = CreateSound(self, Sound(self.PoweredSound))
    self.Sound:SetSoundLevel(self.SoundLevel)
    self.Sound:PlayEx(0, 100)
    self.Sound:ChangeVolume(1, 2)
end

function ENT:SoundStop()
    if self.Sound then
        self.Sound:Stop()
        self:EmitSound("ambient/machines/spindown.wav")
        self.Sound = nil
    end
end

function ENT:Touch(entity)
    if entity.USED then return end
    if entity.craftingIngredient == "fuel" and self:GetFuel() < self:GetCapacity() then
        entity.USED = true
        self:SetFuel(math.min(self:GetCapacity(), self:GetFuel() + 300))
        SafeRemoveEntity(entity)
        if self:GetSwitchedOn() then
            self:PowerOn()
        end
    elseif entity.upgradeType == "generator_cap" and self:GetCapacityUpgrades() < self.MaxCapacityUpgrades then
        entity.USED = true
        self:SetCapacityUpgrades(self:GetCapacityUpgrades() + 1)
        SafeRemoveEntity(entity)
        self:EmitSound("buttons/lever4.wav")
    elseif entity.upgradeType == "generator_conn" and self:GetConnectionUpgrades() < self.MaxConnectionUpgrades then
        entity.USED = true
        self:SetConnectionUpgrades(self:GetConnectionUpgrades() + 1)
        SafeRemoveEntity(entity)
        self:EmitSound("buttons/button6.wav")
    end
end

function ENT:OnTakeDamage(dmg)
    self:SetHealth(self:Health() - dmg:GetDamage())
    if self:Health() <= 0 then
        self:Destruct()
        self:Remove()
    end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
    DarkRP.notify(self:Getowning_ent(), 1, 4, "A generator was destroyed!")

    if IsValid(attacker) and attacker:IsPlayer() then
        attacker:addMoney(self.bountyAmount)
        DarkRP.notify(attacker, 0, 3, "You received a bounty of " .. DarkRP.formatMoney(self.bountyAmount) .. "!")
    end
end

function ENT:Think()

    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
        return
    end

    if self:GetSwitchedOn() and (self.NextFuelTick or 0) <= CurTime() then
        self:SetFuel(math.max(0, self:GetFuel() - 1))
        self.NextFuelTick = CurTime() + 1
    end

    if self:GetFuel() <= 0 then
        self:PowerOff()
    end

    if !self.sparking then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
    self:PowerOff()
end

function ENT:GetPreferredCarryAngles(ply)
    return Angle(0, 180, 0)
end