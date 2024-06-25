ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base Crafting Bench"
ENT.Author = "Arctic"
ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = "models/props_wasteland/laundry_washer003.mdl"
ENT.CraftingRecipeType = "guns"

ENT.MaxIngredientTypes = 5

function ENT:contextHint()
    local has_ingredients = self:HasIngredients()

    if !has_ingredients then
        return self.PrintName
    else
        local str = ""

        for i = 1, self.MaxIngredientTypes do
            local ingid = self["GetIngredientID" .. i](self)
            if ingid <= 0 then break end
            local ing = ArcRP_Craft.Items[ArcRP_Craft.ItemsID[ingid]]
            local amt = self["GetIngredientCount" .. i](self)
            if i > 1 then i = i .. ", " end
            str = str .. ing.name .. "x" .. amt
        end

        return str
    end
end

function ENT:HasIngredients()
    for i = 1, self.MaxIngredientTypes do
        if self["GetIngredientID" .. i](self) > 0 and self["GetIngredientCount" .. i](self) > 0 then return true end
    end
    return false
end

function ENT:GetContextMenu(player)
    local has_ingredients = self:HasIngredients()

    local tbl = {}

    if self:GetRecipeOutput() != 0 then
        local recipename = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()].name or "??"
        table.insert(tbl, {
            message = "Craft " .. recipename,
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:Craft(ply)
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

    table.insert(tbl, {
        message = "Next Recipe",
        cl_callback = function(ent, ply)
            local recipe_total = #ArcRP_Craft.Recipes[ent.CraftingRecipeType]
            if ent.SelectedRecipeIndex + 1 > recipe_total then
                ent.SelectedRecipeIndex = 1
            else
                ent.SelectedRecipeIndex = ent.SelectedRecipeIndex + 1
            end
        end,
    })
    table.insert(tbl, {
        message = "Previous Recipe",
        cl_callback = function(ent, ply)
            if ent.SelectedRecipeIndex == 1 then
                ent.SelectedRecipeIndex = #ArcRP_Craft.Recipes[ent.CraftingRecipeType]
            else
                ent.SelectedRecipeIndex = ent.SelectedRecipeIndex - 1
            end
        end,
    })


    return tbl
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Int", 0, "RecipeOutput")
    self:NetworkVar("Bool", 0, "IsCrafting")
    self:NetworkVar("Float", 0, "CraftingEndTime")

    local start_index = 1
    for i = 1, self.MaxIngredientTypes do
        self:NetworkVar("Int", start_index + i * 2 - 1, "IngredientID" .. i)
        self:NetworkVar("Int", start_index + i * 2 , "IngredientCount" .. i)
    end
end
