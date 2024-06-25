ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base Crafting Bench"
ENT.Author = "Arctic"
ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.CraftingRecipeType = ""

function ENT:GetContextMenu(player)
    local has_ingredients = IsValid(self:GetIngredient1()) or IsValid(self:GetIngredient2()) or IsValid(self:GetIngredient3())

    local tbl = {}

    if has_ingredients then
        table.insert(tbl, {
            message = "Eject Ingredients",
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:EjectIngredients()
            end,
        })
    end

    return tbl
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Ingredient1")
    self:NetworkVar("Entity", 1, "Ingredient2")
    self:NetworkVar("Entity", 2, "Ingredient3")
end
