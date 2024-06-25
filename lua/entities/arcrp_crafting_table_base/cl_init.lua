include("shared.lua")

ENT.SelectedRecipeIndex = 1

function ENT:Initialize()
end

function ENT:DrawTranslucent()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    local has_ingredients = IsValid(self:GetIngredient1()) or IsValid(self:GetIngredient2()) or IsValid(self:GetIngredient3())
    local text2 = ""

    if has_ingredients then
        text2 = text2 .. (self:GetIngredient1().PrintName or "")

        if IsValid(self:GetIngredient2()) then
            text2 = text2 .. ", " .. self:GetIngredient2().PrintName
        end

        if IsValid(self:GetIngredient3()) then
            text2 = text2 .. ", " .. self:GetIngredient3().PrintName
        end
    end

    surface.SetFont("HUDNumber5")
    local text = self.PrintName
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(text2)

    Ang:RotateAroundAxis(Ang:Up(), 180)
    Ang:RotateAroundAxis(Ang:Forward(), 90)

    cam.Start3D2D(Pos + Ang:Up() * 26 + Ang:Forward() * 16, Ang, 0.11)
        draw.WordBox(2, -TextWidth * 0.5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        if text2 != "" then
            draw.WordBox(2, -TextWidth2 * 0.5, 8, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        end
    cam.End3D2D()

    cam.Start3D2D(Pos + Ang:Up() * 22 + Ang:Forward() * -40 + Ang:Right() * -12, Ang, 0.08)
        draw.RoundedBox(8, 0, 0, 400, 200, Color(140, 0, 0, 100))
        local recipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][self.SelectedRecipeIndex]
        if not recipe then
            self.SelectedRecipeIndex = 1
            recipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][self.SelectedRecipeIndex]
        end
        draw.SimpleText("Recipe: " .. recipe.name, "HUDNumber5", 8, 8, color_white)
        draw.SimpleText("Ingredients: ", "HUDNumber5", 8, 40, color_white)
        local y = 40
        for k, v in pairs(recipe.ingredients) do
            y = y + 32
            draw.SimpleText("- " .. ((ArcRP_Craft.Items[k] or {}).name or k) .. " x" .. v, "HUDNumber5", 16, y, color_white)
        end
    cam.End3D2D()
end