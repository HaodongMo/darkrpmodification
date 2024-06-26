--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.bountyAmount = 0
ENT.PoweredSound = "ambient/levels/labs/equipment_printer_loop1.wav"

DEFINE_BASECLASS(ENT.Base)

function ENT:Initialize()
    self:SetModel("models/props_c17/consolebox05a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.sparking = false
    self:SetHealth(100)
    self.IsMoneyPrinter = true

    self:SetTrigger(true)

    self.LastPrintTime = CurTime()

    self.bountyAmount = 400
end

function ENT:Touch(entity)
    if entity.craftingIngredient == "paper" then
        self:EmitSound("buttons/button6.wav")
        self:SetPaper(self:GetCapacity())
        SafeRemoveEntity(entity)
        self:UpdatePowerState()
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
    DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))

    if IsValid(attacker) and attacker:IsPlayer() then
        attacker:addMoney(self.bountyAmount)
        DarkRP.notify(attacker, 0, 3, "You received a bounty of " .. DarkRP.formatMoney(self.bountyAmount) .. "!")
    end
end

function ENT:CreateMoneybag()
    if !IsValid(self) or self:IsOnFire() then return end

    if !self:IsPowered() then self:UpdatePowerState() return end
    if self:GetPaper() <= 0 then self:UpdatePowerState() return end

    local amount = 100

    // DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
    self:SetMoney(self:GetMoney() + amount)
    self:SetPaper(self:GetPaper() - 1)

    self:UpdatePowerState()
end

function ENT:CanPowerOn()
    return self:GetPaper() > 0
end

function ENT:Think()

    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
        return
    end

    if self.LastPrintTime + self:GetPrintInterval() < CurTime() then
        self:CreateMoneybag()
        self.LastPrintTime = CurTime()
    end

    BaseClass.Think(self)
end

function ENT:TakeMoney(ply)
    if self:GetMoney() > 0 then
        ply:addMoney(self:GetMoney())

        DarkRP.notify(ply, 0, 4, "You got " .. DarkRP.formatMoney(self:GetMoney()) .. " from the money printer!")

        self:SetMoney(0)
    end
end