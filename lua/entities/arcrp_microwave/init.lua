--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.bountyAmount = 10
ENT.PoweredSound = false

DEFINE_BASECLASS(ENT.Base)

function ENT:Initialize()
    self:SetModel("models/props/cs_office/microwave.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.Cooking = false

    self:SetHealth(100)

    self:SetTrigger(true)
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

    if IsValid(attacker) and attacker:IsPlayer() then
        attacker:addMoney(self.bountyAmount)
        DarkRP.notify(attacker, 0, 3, "You received a bounty of " .. DarkRP.formatMoney(self.bountyAmount) .. "!")
    end
end

ENT.NextCookThinkTime = 0

function ENT:Think()

    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
        return
    end

    if self:IsPowered() and self:GetHasCook() and self.NextCookThinkTime <= CurTime() then
        self:SetCookTime(self:GetCookTime() - 1)
        if self:GetCookTime() <= 0 then
            self:StopCookSound()
            self:CookDone()
        end
        self.NextCookThinkTime = CurTime() + 1
    end

    BaseClass.Think(self)
end

function ENT:StartCookSound()
    self.Sound = CreateSound(self, Sound("ambient/machines/lab_loop1.wav"))
    self.Sound:SetSoundLevel(60)
    self.Sound:PlayEx(1, 100)
end

function ENT:StopCookSound()
    if self.Sound then
        self.Sound:Stop()
        self.Sound = nil
    end
end

function ENT:PowerOn()
    if self:GetHasCook() then
        self:StartCookSound()
    end
end

function ENT:PowerOff()
    self:StopCookSound()
end

function ENT:CookDone()
    self:EmitSound("garrysmod/content_downloaded.wav") -- Need to replace this with BEEP. BEEP. BEEP
end

function ENT:Cook(ply, index)
    local cookitem = self.CookItems[index]

    if !cookitem then return end

    if ply:getDarkRPVar("money") < cookitem.price then
        DarkRP.notify(ply, 1, 3, "You can't afford food? How broke are you?")
        return
    end

    DarkRP.notify(ply, 0, 3, "You bought " .. cookitem.name .. " and started cooking it.")
    ply:addMoney(-cookitem.price)
    self:SetCookTime(cookitem.cookTime)
    self:SetCookItem(index)
    self:SetHasCook(true)
    self:StartCookSound()
end

function ENT:Eat(ply)
    if !self:GetHasCook() then return end
    if self:GetCookTime() > 0 then return end
    if self:GetCookItem() == 0 then return end

    local cookitem = self.CookItems[self:GetCookItem()]

    ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + cookitem.healAmount))
    DarkRP.notify(ply, 0, 3, "You have eaten " .. cookitem.name .. ".")
    self:SetHasCook(false)
    self:SetCookItem(0)
end