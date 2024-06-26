AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    if IsValid(ArcRP_BankRob.GetBriefcase()) then
        print("Hey there's already a briefcase!")
        self:Remove()
        return
    end
    self:SetModel("models/weapons/tacint/props_misc/briefcase_bomb-1.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(50)
    end

    SetGlobalEntity("ArcRP_BankBriefcase", self)
end

function ENT:Think()
    if self:GetTimeoutEnd() > 0 and self:GetTimeoutEnd() < CurTime() then
        ArcRP_BankRob.EndRobbery(self, true)
    end
end

function ENT:Use(activator, caller)
    if activator:isCP() then
        DarkRP.notify(activator, 0, 5, "This is the stolen money from the bank. Bring this back to the pallet to return the money.")
    else
        DarkRP.notify(activator, 0, 5, "This is the stolen money from the bank. Bring it to a money laundry to secure the loot!")
    end
end
