AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Insurance"

ENT.Model = "models/props_lab/clipboard.mdl"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:DrawShadow(true)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)
        self:SetColor(Color(0,255,255))
        self:PhysWake()
    end

    function ENT:Use(activator, caller)
        if activator:IsPlayer() then
            if activator:GetNWBool("Insurance", false) == true then
                DarkRP.notify(activator, 1, 5, "You already have insurance!")
                return
            else
                activator:SetNWBool("Insurance", true)
                DarkRP.notify(activator, 3, 10, "You got insurance! The next time you die, you won't drop any money.")
                self:Remove()
            end
        end
    end
end
