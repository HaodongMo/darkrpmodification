AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_cart001.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    self:SetTrigger(true)
end

function ENT:Touch(entity)
    if entity.recyclable then
        self:EmitSound("buttons/button6.wav")
        SafeRemoveEntity(entity)
    end
end

function ENT:TakeMoney(ply)
    if self:GetMoney() > 0 then
        ply:addMoney(self:GetMoney())

        DarkRP.notify(ply, 0, 4, "You got " .. DarkRP.formatMoney(self:GetMoney()) .. " from the recycling bin!")

        self:SetMoney(0)
    end
end