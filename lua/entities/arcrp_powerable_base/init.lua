--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.PoweredSound = false

function ENT:Initialize()
end

function ENT:StartSound()
    if self.PoweredSound then
        self.Sound = CreateSound(self, Sound(self.PoweredSound))
        self.Sound:SetSoundLevel(60)
        self.Sound:PlayEx(0, 100)
        self.Sound:ChangeVolume(1, 2)
    end
end

function ENT:SoundStop()
    if self.Sound then
        self.Sound:Stop()
        self.Sound = nil
    end
end

function ENT:CreateMoneybag()
    if !IsValid(self) or self:IsOnFire() then return end

    if !self:IsPowered() then self:SoundStop() return end
    if self:GetPaper() <= 0 then self:SoundStop() return end

    local amount = 100

    // DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
    self:SetMoney(self:GetMoney() + amount)
    self:SetPaper(self:GetPaper() - 1)

    if self:GetPaper() <= 0 then self:SoundStop() return end
end

function ENT:Think()
    if IsValid(self:GetGenerator()) and !IsValid(self.PowerCable) then
        self:Disconnect()
    end
end

function ENT:OnRemove()
    self:SoundStop()
    self:Disconnect()
end

ENT.NextConnectTime = 0

function ENT:ConnectPower()
    if self.NextConnectTime > CurTime() then return end

    self:Disconnect()

    local best_generator_has_power = false
    local best_generator = nil
    local best_generator_dist = 0

    for i, ent in ipairs(ents.FindInSphere(self:GetPos(), 256)) do
        if ent.IsGenerator then
            if ent:GetConnectedEntityAmount() >= ent.MaxConnectedEntities then continue end
            if !best_generator then
                best_generator = ent
                best_generator_dist = ent:GetPos():Distance(self:GetPos())
                best_generator_has_power = ent:IsPowered()
            else
                if best_generator_has_power and !ent:IsPowered() then continue end
                if !best_generator_has_power and ent:IsPowered() then
                    best_generator = ent
                    best_generator_dist = ent:GetPos():Distance(self:GetPos())
                    best_generator_has_power = ent:IsPowered()
                    continue
                end
                local dist = ent:GetPos():Distance(self:GetPos())

                if dist <= best_generator_dist then
                    best_generator = ent
                    best_generator_dist = ent:GetPos():Distance(self:GetPos())
                    best_generator_has_power = ent:IsPowered()
                end
            end
        end
    end

    self:Connect(best_generator)

    self.NextConnectTime = CurTime() + 1
end

function ENT:CanPowerOn()
    return true
end

function ENT:Connect(gen)
    self:SetGenerator(gen)

    if gen then
        self:GetGenerator():Connect(self)
    end

    self:UpdatePowerState()
end

function ENT:Disconnect()
    if IsValid(self:GetGenerator()) then
        self:GetGenerator():Disconnect(self)
        self:SetGenerator(NULL)
    end

    self:UpdatePowerState()
end

function ENT:UpdatePowerState()
    if self:IsPowered() and self:CanPowerOn() then
        self:StartSound()
    else
        self:SoundStop()
    end
end