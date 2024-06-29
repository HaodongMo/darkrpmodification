AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "arcrp_drug_base"
ENT.PrintName = "Bottle of Beer"
ENT.Author = "Arctic"
ENT.Spawnable = true
ENT.Category = "ArcRP - Drugs"
ENT.craftingIngredient = "beer"

ENT.Model = "models/props_junk/garbage_glassbottle001a.mdl"

function ENT:TakeDrug(ply)
    if ply:Health() < ply:GetMaxHealth() + 10 then
        local newhp = ply:Health() + 50
        newhp = math.Clamp(newhp, 0, ply:GetMaxHealth() + 10)
        ply:SetHealth(newhp)
    end
end

ENT.ScopeOutHint = "Beer"