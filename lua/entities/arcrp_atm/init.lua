AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/arcrp/ATM01.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:MakeWithdrawal(ply, amt)
    amt = math.min(amt, ply:getDarkRPVar("bank"))

    ply:setDarkRPVar("bank", ply:getDarkRPVar("bank") - amt)
    ply:addMoney(amt)
    DarkRP.notify(ply, 0, 3, "Successfully withdrawn " .. DarkRP.formatMoney(amt) .. "!")
end

function ENT:MakeDeposit(ply, amt)
    amt = math.min(amt, ply:getDarkRPVar("money"))

    ply:addMoney(-amt)
    ply:setDarkRPVar("bank", ply:getDarkRPVar("bank") + amt)
    DarkRP.notify(ply, 0, 3, "Successfully deposited " .. DarkRP.formatMoney(amt) .. "!")
end

net.Receive("arcrp_banking", function(len, ply)
    local ent = net.ReadEntity()
    local is_withdrawal = net.ReadBool()
    local amount = net.ReadUInt(32)

    if ent:GetPos():DistToSqr(ply:GetPos()) > 128 * 128 then return end

    if is_withdrawal then
        ent:MakeWithdrawal(ply, amount)
    else
        ent:MakeDeposit(ply, amount)
    end
end)