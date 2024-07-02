AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_trainstation/payphone001a.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:PlaceHit(ply, victim)
end

net.Receive("arcrp_placehit", function(len, ply)
    local ent = net.ReadEntity()
    local victim = net.ReadEntity()

    if !IsValid(ent) then return end

    if ent:GetPos():DistToSqr(ply:GetPos()) > 128 * 128 then return end
    if !ply:Alive() then return end

    if !IsValid(victim) then return end
    if !victim:IsPlayer() then return end

    if victim == ply then return end
    if victim:Team() == TEAM_CITIZEN then return end

    local cost = ArcRP_GetHitCost(victim)

    if ply:getDarkRPVar("money") < cost then return end

    local hitman = ArcRP_FindFreeHitman(victim)

    if !hitman then
        DarkRP.notify(ply, 1, 3, "There are no hitmen available to service your request!")
        return
    end

    hitman:placeHit(ply, victim, cost)
    hitman.ArcRP_HitCustomer = ply
    hitman.ArcRP_HitPrice = cost
    if TabPhone then
        TabPhone.SendNPCMessage(ply, "assassins", "An agent has been dispatched to eliminate " .. victim:GetName() .. ". Expect results soon.")
        TabPhone.SendNPCMessage(hitman, "assassins", "Kill " .. victim:GetName() .. ".")
    else
        DarkRP.notify(ply, 0, 3, "A Hitman has been assigned to your request...")
    end
end)