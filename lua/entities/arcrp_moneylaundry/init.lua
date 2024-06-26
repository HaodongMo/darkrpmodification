AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:SetTrigger(true)
    self:UseTriggerBounds(true, 16)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

ENT.SpawnOffset = Vector(32, 0, 0)
ENT.OutputForce = Vector(50, 0, 75)
ENT.Debounce = 0
function ENT:Touch(entity)
    if entity == ArcRP_BankRob.GetBriefcase() and self.Debounce < CurTime() then
        -- Can't secure if a cop is nearby
        local notifyply = {}
        local blocked = false
        local can = false
        for _, ply in pairs(player.GetAll()) do
            if ply:Alive() and ply:GetPos():DistToSqr(self:GetPos()) <= 107584 then
                if ply:isCP() then
                    blocked = true
                else
                    can = true
                    table.insert(notifyply, ply)
                end
            end
        end
        if blocked or !can then
            if !can and #notifyply > 0 then
                DarkRP.notify(notifyply, 3, 3, "Cannot deposit - there are police nearby!")
            end
            self:EmitSound("buttons/button2.wav")
            self.Debounce = CurTime() + 1.5
            return
        end
        self.Debounce = CurTime() + 5.5
        self:SetReward(math.Round(entity:GetReward()))
        self.MoneyBagValue = 30 + self:GetReward() / 100
        ArcRP_BankRob.WonRobbery()

        if not self.HereComesTheMoney then
            self.HereComesTheMoney = CreateSound(self, "arcrp/herecomesthemoney.mp3")
            self.HereComesTheMoney:SetSoundLevel(100)
        end
        self.HereComesTheMoney:Stop()
        self.HereComesTheMoney:Play()

    end
end

function ENT:OnRemove()
    if self.HereComesTheMoney then
        self.HereComesTheMoney:Stop()
    end
end

function ENT:Think()
    if self:GetReward() > 0 and self.Debounce < CurTime() then
        local amt = math.Clamp(math.ceil(self.MoneyBagValue * math.Rand(0.8, 1.2)), 0, self:GetReward())
        local pos = self:GetPos()
                + self:GetForward() * self.SpawnOffset.x
                + self:GetRight() * self.SpawnOffset.y
                + self:GetUp() * self.SpawnOffset.z
        local moneybag = DarkRP.createMoneyBag(pos, amt)
        moneybag:SetAngles(AngleRand())
        moneybag:GetPhysicsObject():SetVelocity(
            self:GetForward() * self.OutputForce.x
            + self:GetRight() * self.OutputForce.y
            + self:GetUp() * self.OutputForce.z
            + VectorRand(50))
        moneybag:GetPhysicsObject():ApplyTorqueCenter(VectorRand() * 200)

        self:SetReward(self:GetReward() - amt)

        if self:GetReward() <= 0 then
            if self.HereComesTheMoney then
                self.HereComesTheMoney:FadeOut(5)
            end
        end

        self:NextThink(CurTime() + 1 / 3)
        return true
    end
end