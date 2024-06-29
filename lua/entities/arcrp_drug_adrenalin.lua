AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "arcrp_drug_base"
ENT.PrintName = "Adrenalin"
ENT.Author = "Arctic"
ENT.Spawnable = true
ENT.Category = "ArcRP - Drugs"
ENT.craftingIngredient = "adrenalin"

ENT.Model = "models/props_lab/jar01b.mdl"

function ENT:TakeDrug(ply)
    if ply:Health() < ply:GetMaxHealth() + 25 then
        local newhp = ply:Health() + 50
        newhp = math.Clamp(newhp, 0, ply:GetMaxHealth() + 25)
        ply:SetHealth(newhp)
    end
end

ENT.ScopeOutHint = "Adrenalin"