include("shared.lua")

ENT.SelectedRecipeIndex = 1

function ENT:Initialize()
end

ENT.DisplayAngles = Angle(0, 90, 180)

ENT.DisplayOffset1 = Vector(0, 16, 26)
ENT.DisplayOffset2 = Vector(12, -40, 22)

function ENT:DrawTranslucent()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    local text2 = ""

    surface.SetFont("HUDNumber5")
    local text = self.PrintName
    if self:GetIsCrafting() and self:IsPowered() then
        local recipename = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()].name or "??"
        text = recipename .. " - " .. math.ceil(self:GetCraftingEndTime() - CurTime()) .. "s"
    end
    if !self:IsPowered() then
        text2 = "No Power - Cannot Craft"
    end
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(text2)

    Ang:RotateAroundAxis(Ang:Up(), self.DisplayAngles.z)
    Ang:RotateAroundAxis(Ang:Forward(), self.DisplayAngles.y)
    Ang:RotateAroundAxis(Ang:Right(), self.DisplayAngles.x)

    cam.Start3D2D(Pos + Ang:Up() * self.DisplayOffset1.z + Ang:Forward() * self.DisplayOffset1.y + Ang:Right() * self.DisplayOffset1.x, Ang, 0.11)
        draw.WordBox(2, -TextWidth * 0.5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        if text2 != "" then
            draw.WordBox(2, -TextWidth2 * 0.5, 8, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        end
    cam.End3D2D()

    local index = self:GetSelectedRecipeIndex()

    cam.Start3D2D(Pos + Ang:Up() * self.DisplayOffset2.z + Ang:Forward() * self.DisplayOffset2.y + Ang:Right() * self.DisplayOffset2.x, Ang, 0.08)
        draw.RoundedBox(8, 0, 0, 420, 300, Color(140, 0, 0, 100))
        local recipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][index]
        if not recipe then return end
        draw.SimpleText("Recipe: " .. recipe.name, "HUDNumber5", 8, 8, color_white)
        draw.SimpleText("Duration: " .. (recipe.time or 0) .. "s", "HUDNumber5", 8, 40, color_white)
        draw.SimpleText("Ingredients: ", "HUDNumber5", 8, 72, color_white)
        local i = 0
        for k, v in pairs(recipe.ingredients) do
            draw.SimpleText("- " .. ((ArcRP_Craft.Items[k] or {}).name or k) .. " x" .. v, "HUDNumber5", 16 + math.floor(i / 3) * 200, 72 + ((i % 3) + 1) * 32, color_white)
            i = i + 1
        end
    cam.End3D2D()
end