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

ENT.SpawnOffset = Vector(0, 0, 64)
ENT.Money = 0

function ENT:Touch(entity)
    if entity.isBankBriefcase then
        SafeRemoveEntity(entity)

        DarkRP.notifyAll(0, 5, "The bank has been robbed! There is no money to pay your salary!")
        SetGlobalFloat("SalarySuppressionEndTime", CurTime() + 300)

        self.Money = 0
        for _, ply in ipairs(player.GetAll()) do
            self.Money = self.Money + math.min(math.floor(ply:getDarkRPVar("money") * 0.1), 1000)
        end
    end
end

function ENT:GetMoney(activator, caller)
    if self.Money <= 0 then
        DarkRP.notify(activator, 1, 4, "No money in the laundry! Bring bank briefcases to launder them!")
    else
        activator:addMoney(self.Money)
        DarkRP.notify(activator, 0, 4, "You have successfully laundered " .. DarkRP.formatMoney(self.Money) .. "!")
        self.Money = 0
    end
end