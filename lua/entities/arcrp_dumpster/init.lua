AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/TrashDumpster01a.mdl")
    self:SetMaterial("binaknife")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:canUse(owner, activator)
    return true
end

function ENT:Use(activator, caller)
    local wep = activator:GetActiveWeapon()

    if !IsValid(wep) then return end

    if weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        activator:StripWeapon(wep:GetClass())
        DarkRP.notify(activator, 1, 4, "Thank you for keeping the streets clean!")
    end
end
