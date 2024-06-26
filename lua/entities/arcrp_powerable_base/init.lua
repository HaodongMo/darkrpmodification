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

    self:EmitSound("ambient/machines/keyboard7_clicks_enter.wav")

    self:UpdatePowerState()
end

function ENT:Disconnect()
    if IsValid(self:GetGenerator()) then
        self:GetGenerator():Disconnect(self)
        self:SetGenerator(NULL)
        self:EmitSound("ambient/machines/keyboard2_clicks.wav")
    end

    self:UpdatePowerState()
end

function ENT:PowerOn()
end

function ENT:PowerOff()
end

function ENT:UpdatePowerState()
    if self:IsPowered() and self:CanPowerOn() then
        self:StartSound()
        self:PowerOn()
    else
        self:SoundStop()
        self:PowerOff()
    end
end