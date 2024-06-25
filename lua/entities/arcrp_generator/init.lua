--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.bountyAmount = 0

function ENT:Initialize()
    self:SetModel("models/props_vehicles/generatortrailer01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.sparking = false
    self:SetHealth(400)

    self:SetTrigger(true)

    self.bountyAmount = 200
end

function ENT:StartSound()
    if !self.Sound then
        self:EmitSound("ambient/machines/spinup.wav")
    else
        self:EmitSound("buttons/lever5.wav")
    end
    self.Sound = CreateSound(self, Sound("ambient/machines/machine3.wav"))
    self.Sound:SetSoundLevel(60)
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
    if entity.isFuel then
        self:SetFuelExpireTime(CurTime() + math.min(self:GetFuelTime() + (60 * 10), self:GetCapacity()))
        SafeRemoveEntity(entity)

        self:StartSound()
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

    if self:GetFuelExpireTime() < CurTime() then
        self:SoundStop()
    end

    if not self.sparking then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
    self:SoundStop()
end