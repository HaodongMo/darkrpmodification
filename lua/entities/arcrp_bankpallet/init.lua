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

    local curBriefcase = ArcRP_BankRob.GetBriefcase()
    if IsValid(curBriefcase) then
        if activator:isCP() then
            if curBriefcase:GetPos():DistToSqr(self:GetPos()) <= 16384 then
                ArcRP_BankRob.EndRobbery()
            else
                DarkRP.notify(activator, 3, 3, "Return the briefcase here and interact with the pallet to end the bank robbery.")
            end
            return
        end
        DarkRP.notify(activator, 3, 3, "There is an ongoing robbery!")
        return
    end

    if activator:isCP() then
        DarkRP.notify(activator, 3, 8, "This is the bank pallet. If someone tries to rob the bank, you must return the money briefcase here to secure it again.")
        return
    end

    if #player.GetAll() <= ArcRP_BankRob.MinPlayers then
        DarkRP.notify(activator, 3, 3, "There aren't enough players for a bank robbery!")
        return
    end
    local cd = ArcRP_BankRob.GetCooldown()
    if ArcRP_BankRob.GetCooldown() > 0 then
        DarkRP.notify(activator, 3, 5, "The bank was recently robbed, try again in " .. math.ceil(cd) .. "s.")
        return
    end

    DarkRP.notify(activator, 1, 30, "Take the briefcase to the underground money laundry to cash out!")
    activator:wanted(activator, "Bank Robbery", 600)

    DarkRP.notifyAll(3, 30, "The bank is being robbed by " .. activator:Nick() .. "! Stop him!")

    self:SetGreedProgress(0)

    -- Just in case wacky things happen
    ArcRP_BankRob.PutOnCooldown(ArcRP_BankRob.CooldownAttempt)

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
    briefcase:SetReward(ArcRP_BankRob.BaseAmount + ArcRP_BankRob.BaseAmountPerPlayer * player.GetCount())
    briefcase:SetTimeoutEnd(CurTime() + ArcRP_BankRob.Timeout)
end

local interval = 0.5
function ENT:Think()
    local briefcase = ArcRP_BankRob.GetBriefcase()
    if IsValid(briefcase) and self:GetGreedProgress() <= ArcRP_BankRob.GreedTime
            and briefcase:GetPos():DistToSqr(self:GetPos()) <= 16384 then

        -- At least 1 player must be nearby to greed.
        -- Each nearby non-cop increases rate 1x, up to 3x.
        local rate = 0
        for _, ply in pairs(player.GetAll()) do
            if !ply:isCP() and ply:Alive() and ply:GetPos():DistToSqr(self:GetPos()) <= 65536 then
                rate = rate + 1
                if rate >= 3 then break end
            end
        end

        if rate > 0 then
            local progress = math.min(interval * rate, ArcRP_BankRob.GreedTime - self:GetGreedProgress())
            local reward = progress * (ArcRP_BankRob.GreedAmountFlat + ArcRP_BankRob.GreedAmountPerPlayer * player.GetCount()) / ArcRP_BankRob.GreedTime
            briefcase:SetReward(briefcase:GetReward() + reward)
            self:SetGreedProgress(self:GetGreedProgress() + progress)
        end

        self:NextThink(CurTime() + interval)
        return true
    end
end