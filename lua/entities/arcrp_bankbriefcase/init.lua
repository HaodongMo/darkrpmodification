AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/SuitCase001a.mdl")
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
    if activator:isCP() then
        for _, ply in ipairs(player.GetAll()) do
            DarkRP.notify(ply, 0, 10, "The bank robbery has been ended by " .. activator:GetName() .. "!")
            self:Remove()
        end
    end
end
