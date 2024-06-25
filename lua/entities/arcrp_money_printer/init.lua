--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.bountyAmount = 0

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

function ENT:StartSound()
    self.Sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
    self.Sound:SetSoundLevel(60)
    self.Sound:PlayEx(0, 100)
    self.Sound:ChangeVolume(1, 2)
end

function ENT:SoundStop()
    if self.Sound then
        self.Sound:Stop()
        self.Sound = nil
    end
end

function ENT:Touch(entity)
    if entity.craftingIngredient == "paper" then
        self:EmitSound("buttons/button6.wav")
        self:SetPaper(self:GetCapacity())
        SafeRemoveEntity(entity)
        self:UpdateConnections()
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

    if !self:IsPowered() then self:SoundStop() return end
    if self:GetPaper() <= 0 then self:SoundStop() return end

    local amount = 100

    // DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
    self:SetMoney(self:GetMoney() + amount)
    self:SetPaper(self:GetPaper() - 1)

    if self:GetPaper() <= 0 then self:SoundStop() return end
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

    if IsValid(self:GetGenerator()) and !IsValid(self.PowerCable) then
        self:Disconnect()
    end
end

function ENT:OnRemove()
    self:SoundStop()
end

function ENT:TakeMoney(ply)
    if self:GetMoney() > 0 then
        ply:addMoney(self:GetMoney())

        DarkRP.notify(ply, 0, 4, "You got " .. DarkRP.formatMoney(self:GetMoney()) .. " from the money printer!")

        self:SetMoney(0)
    end
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

function ENT:Connect(gen)
    self:SetGenerator(gen)

    if gen then
        self:GetGenerator():Connect(self)
    end

    self:UpdateConnections()
end

function ENT:Disconnect()
    if IsValid(self:GetGenerator()) then
        self:GetGenerator():Disconnect(self)
    end

    self:SetGenerator(NULL)

    self:UpdateConnections()
end

function ENT:UpdateConnections()
    if self:IsPowered() and self:GetPaper() > 0 then
        if !self.Sound then
            self:StartSound()
        end
    else
        self:SoundStop()
    end
end

function ENT:PowerOn(entity)
    self:UpdateConnections()
end

function ENT:PowerOff(entity)
    self:UpdateConnections()
end