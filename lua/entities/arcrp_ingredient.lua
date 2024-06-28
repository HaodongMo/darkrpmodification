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
        self:SetHealth(15)
    end

    function ENT:OnTakeDamage(dmg)
        self:SetHealth(self:Health() - dmg:GetDamage())
        if self:Health() <= 0 then
            self:Destruct()
            SafeRemoveEntity(self)
        end
    end

    function ENT:Destruct()
        local vPoint = self:GetPos()
        local effectdata = EffectData()
        effectdata:SetStart(vPoint)
        effectdata:SetOrigin(vPoint)
        effectdata:SetScale(1)
        util.Effect("ManhackSparks", effectdata)
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

function ENT:GetPreferredCarryAngles(ply)
    return Angle(0, 0, 0)
end