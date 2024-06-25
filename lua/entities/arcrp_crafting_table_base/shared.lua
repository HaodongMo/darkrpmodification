ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base Crafting Bench"
ENT.Author = "Arctic"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.CraftingRecipeType = "guns"

// ENT.contextHint = "Crafting Bench"

function ENT:contextHint()
    local has_ingredients = IsValid(self:GetIngredient1()) or IsValid(self:GetIngredient2()) or IsValid(self:GetIngredient3())

    if !has_ingredients then
        return "Crafting Bench"
    else
        local str = ""

        str = str .. self:GetIngredient1().PrintName

        if IsValid(self:GetIngredient2()) then
            str = str .. ", " .. self:GetIngredient2().PrintName
        end

        if IsValid(self:GetIngredient3()) then
            str = str .. ", " .. self:GetIngredient3().PrintName
        end

        return str
    end
end

function ENT:GetContextMenu(player)
    local has_ingredients = IsValid(self:GetIngredient1()) or IsValid(self:GetIngredient2()) or IsValid(self:GetIngredient3())

    local tbl = {}

    if self:GetRecipeOutput() != 0 then
        local recipename = GAMEMODE.Config.craftingRecipes[self.CraftingRecipeType][self:GetRecipeOutput()].name or "??"
        table.insert(tbl, {
            message = "Craft " .. recipename,
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:Craft()
            end,
        })
    end

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
    self:NetworkVar("Entity", 3, "owning_ent")
    self:NetworkVar("Int", 0, "RecipeOutput")
end
