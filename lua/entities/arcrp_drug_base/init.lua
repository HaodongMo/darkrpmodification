AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(5)
    end
end

function ENT:TakeDrug(ply)
end

function ENT:Use(activator, caller)
    if self.USED then return end
    self:TakeDrug(activator)
    self.USED = true
    SafeRemoveEntity(self)
    self:EmitSound("items/medshot4.wav")
end
