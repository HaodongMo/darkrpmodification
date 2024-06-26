ENT.Type = "anim"
ENT.Base = "arcrp_powerable_base"
ENT.PrintName = "Base Crafting Bench"
ENT.Author = "Arctic"
ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = "models/props_wasteland/laundry_washer003.mdl"
ENT.CraftingRecipeType = "guns"

ENT.MaxIngredientTypes = 5
ENT.MaxIngredientCount = 5

ENT.UpgradeSpeedMult = 0.7
ENT.UpgradeCapacity = 20

ENT.Upgrades = {
    [1] = {
        name = "SelfCycle",
        ent = "crafter_auto",
    },
    [2] = {
        name = "ConrCttr",
        ent = "crafter_eco",
    },
    [3] = {
        name = "TurboGear",
        ent = "crafter_speed",
    },
    [4] = {
        name = "BigBins",
        ent = "crafter_capacity",
    },
    [5] = {
        name = "XpertCraft",
        ent = "crafter_rarity",
    },
}
ENT.UpgradeIndex = {}
for i = 1, #ENT.Upgrades do
    ENT.UpgradeIndex[ENT.Upgrades[i].ent] = i
end

function ENT:contextHint()
    local has_ingredients = self:HasIngredients()

    if !self:IsPowered() then
        return "NO POWER"
    end

    if self:GetIsCrafting() then
        local recipename = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()].name or "??"
        return "Crafting " .. recipename .. " - " .. math.ceil(self:GetCraftingEndTime() - CurTime()) .. "s"
    elseif !has_ingredients then
        return self.PrintName
    else
        local str = ""

        for i = 1, self.MaxIngredientTypes do
            local ingid = self["GetIngredientID" .. i](self)
            if ingid <= 0 then continue end
            local ing = ArcRP_Craft.Items[ArcRP_Craft.ItemsID[ingid]]
            local amt = self["GetIngredientCount" .. i](self)
            if i > 1 then str = str .. ", " end
            str = str .. ing.name .. " x" .. amt
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

    if self:GetIsCrafting() then
        table.insert(tbl, {
            message = "Cancel Crafting",
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:Craft(ply)
            end,
        })
    end

    if self:GetRecipeOutput() != 0 and !self:GetIsCrafting() then
        local recipename = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()].name or "??"
        table.insert(tbl, {
            message = "Craft " .. recipename,
            callback = function(ent, ply)
                if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

                ent:Craft(ply)
            end,
        })
    end

    if has_ingredients and !self:GetIsCrafting() then
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
        callback = function(ent, ply)
            if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

            local recipe_total = #ArcRP_Craft.Recipes[ent.CraftingRecipeType]
            if ent:GetSelectedRecipeIndex() + 1 > recipe_total then
                ent:SetSelectedRecipeIndex(1)
            else
                ent:SetSelectedRecipeIndex(ent:GetSelectedRecipeIndex() + 1)
            end
            ent:CheckRecipe()
        end,
    })
    table.insert(tbl, {
        message = "Previous Recipe",
        callback = function(ent, ply)
            if ent:GetPos():DistToSqr(ply:GetPos()) > 256 * 256 then return end

            if ent:GetSelectedRecipeIndex() == 1 then
                ent:SetSelectedRecipeIndex(#ArcRP_Craft.Recipes[ent.CraftingRecipeType])
            else
                ent:SetSelectedRecipeIndex(ent:GetSelectedRecipeIndex() - 1)
            end
            ent:CheckRecipe()
        end,
    })

    table.insert(tbl,
        {
            message = "Reconnect Power",
            callback = function(ent2, ply2)
                ent2:ConnectPower()
            end,
        }
    )

    return tbl
end

function ENT:GetMaxIngredientCount()
    return self:HasUpgrade("crafter_capacity") and self.UpgradeCapacity or self.MaxIngredientCount
end

function ENT:HasUpgrade(i)
    i = self.UpgradeIndex[i] or i
    local b = 2 ^ i
    return bit.band(self:GetUpgradeFlags(), b) == b
end

function ENT:InstallUpgrade(i)
    i = self.UpgradeIndex[i] or i
    self:SetUpgradeFlags(bit.bor(self:GetUpgradeFlags(), 2 ^ i))
end

function ENT:SetupOtherDataTables()
    self:NetworkVar("Int", 0, "RecipeOutput")
    self:NetworkVar("Int", 1, "SelectedRecipeIndex")
    self:NetworkVar("Int", 2, "UpgradeFlags")
    self:NetworkVar("Bool", 0, "IsCrafting")
    self:NetworkVar("Float", 0, "CraftingEndTime")
    self:SetSelectedRecipeIndex(1)

    local start_index = 2
    for i = 1, self.MaxIngredientTypes do
        self:NetworkVar("Int", start_index + i * 2 - 1, "IngredientID" .. i)
        self:NetworkVar("Int", start_index + i * 2 , "IngredientCount" .. i)
    end
end