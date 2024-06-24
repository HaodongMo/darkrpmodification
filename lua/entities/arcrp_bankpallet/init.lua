AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NextRobberyTime = 0

function ENT:Initialize()
    self:SetModel("models/props/cs_assault/MoneyPallet.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:SetTrigger(true)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    self.NextRobberyTime = 0
end

function ENT:canUse(owner, activator)
    return true
end

ENT.RobberyInterval = 600
ENT.CanReturnTime = 0
ENT.SpawnOffset = Vector(64, 0, 32)

function ENT:Use(activator, caller)
    if #player.GetAll() <= 2 then
        DarkRP.notify(activator, 1, 3, "There aren't enough players for a bank robbery!")
        return
    end

    if self.NextRobberyTime > CurTime() then
        DarkRP.notify(activator, 1, 3, "The bank has no money for you to take right now!")
        return
    end

    DarkRP.notify(activator, 3, 10, "Take the briefcase to the underground money laundry to cash out!")
    activator:wanted(activator, "Bank Robbery", 600)

    for _, ply in ipairs(player.GetAll()) do
        if !ply:isCP() then continue end

        DarkRP.notify(ply, 3, 10, "The bank is being robbed by " .. activator:Nick() .. "! Stop him!")
    end

    local briefcase = ents.Create("arcrp_bankbriefcase")

    if !IsValid(briefcase) then return end
    local newpos = self:GetPos()
    newpos = newpos + self:GetForward() * self.SpawnOffset.x
    newpos = newpos + self:GetRight() * self.SpawnOffset.y
    newpos = newpos + self:GetUp() * self.SpawnOffset.z
    briefcase:SetPos(newpos)
    briefcase.nodupe = true
    briefcase.spawnedBy = activator
    briefcase:Spawn()

    self.NextRobberyTime = CurTime() + self.RobberyInterval
    self.CanReturnTime = CurTime() + 15
end

function ENT:Touch(entity)
    if self.CanReturnTime < CurTime() and entity.isBankBriefcase then
        SafeRemoveEntity(entity)

        for _, ply in ipairs(player.GetAll()) do
            if !ply:isCP() then continue end

            DarkRP.notify(ply, 3, 10, "The bank robbery has been ended!")
        end
    end
end