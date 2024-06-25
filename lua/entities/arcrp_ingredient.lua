AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Crafting Ingredient"
ENT.Category = "Crafting Materials"

ENT.isCraftingIngredient = true

ENT.craftingIngredient = ""
ENT.Model = ""

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:DrawShadow(true)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
        self:GetPhysicsObject():SetMass(15)
    end

    function ENT:Use(ply)
        ply:PickupObject(self)
    end
elseif CLIENT then
    function ENT:Initialize()
        // self.contextHint = self.PrintName .. " (Ingredient)"
    end

    function ENT:contextHint()
        return self.PrintName .. " (Ingredient)"
    end

    function ENT:Draw()
        self:DrawModel()
    end
end