include("shared.lua")

ENT.SelectedRecipeIndex = 1

local clr_upg_off = Color(50, 50, 50, 255)
local clr_upg_on = Color(30, 120, 25, 255)

function ENT:Initialize()
end

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

    Ang:RotateAroundAxis(Ang:Up(), 180)
    Ang:RotateAroundAxis(Ang:Forward(), 90)

    cam.Start3D2D(Pos + Ang:Up() * 26 + Ang:Forward() * 16, Ang, 0.11)
        draw.WordBox(2, -TextWidth * 0.5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        if text2 != "" then
            draw.WordBox(2, -TextWidth2 * 0.5, 8, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        end
    cam.End3D2D()

    local index = self:GetSelectedRecipeIndex()

    Ang:RotateAroundAxis(Ang:Forward(), -15)

    cam.Start3D2D(Pos + Ang:Up() * 22 + Ang:Forward() * -40 + Ang:Right() * -9, Ang, 0.05)
        draw.RoundedBox(8, 0, 0, 600, 300, Color(140, 0, 0, 100))
        local recipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][index]
        if !recipe then return end
        draw.SimpleText("Recipe: " .. recipe.name, "HUDNumber5", 8, 8, color_white)
        if (recipe.time or 0) > 0 and self:HasUpgrade("crafter_speed") then
            draw.SimpleText("Duration: " .. recipe.time .. "s" .. " (" .. math.Round(recipe.time * self.UpgradeSpeedMult, 1) .. "s)", "HUDNumber5", 8, 40, color_white)
        else
            draw.SimpleText("Duration: " .. (recipe.time or 0) .. "s", "HUDNumber5", 8, 40, color_white)
        end
        draw.SimpleText("Ingredients: " .. (self:HasUpgrade("crafter_speed") and "(30% refund chance)" or ""), "HUDNumber5", 8, 72, color_white)
        local i = 0
        for k, v in pairs(recipe.ingredients) do
            draw.SimpleText("- " .. ((ArcRP_Craft.Items[k] or {}).name or k) .. " x" .. v, "HUDNumber5", 16 + math.floor(i / 3) * 200, 72 + ((i % 3) + 1) * 32, color_white)
            i = i + 1
        end
    cam.End3D2D()

    Ang:RotateAroundAxis(Ang:Forward(), -15)

    cam.Start3D2D(Pos + Ang:Up() * 16 + Ang:Forward() * -45 + Ang:Right() * 20, Ang, 0.1)
        draw.SimpleText("Upgrades", "HUDNumber5", 0, -15, color_white)

        for i, v in ipairs(self.Upgrades) do
            draw.RoundedBox(8, (i - 1) * 160, 25, 150, 40, self:HasUpgrade(i) and clr_upg_on or clr_upg_off)
            draw.SimpleText(v.name, "HUDNumber5", (i - 1) * 160 + 75, 25 + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()

    Ang:RotateAroundAxis(Ang:Forward(), -15)

    cam.Start3D2D(Pos + Ang:Up() * 20 + Ang:Forward() * 1 + Ang:Right() * -10, Ang, 0.075)
        draw.RoundedBox(8, 0, 0, 400, 200, Color(140, 0, 0, 100))
        if self["GetIngredientID1"](self) == 0 then
            draw.SimpleText("Empty", "HUDNumber5", 16, 16, color_white)
        else
            for i = 1, self.MaxIngredientTypes do
                local ingid = self["GetIngredientID" .. i](self)
                if ingid <= 0 then continue end
                local amt = self["GetIngredientCount" .. i](self)
                draw.SimpleText( ((ArcRP_Craft.Items[ArcRP_Craft.ItemsID[ingid]] or {}).name or ingid) .. " x" .. amt .. "/" .. self:GetMaxIngredientCount(), "HUDNumber5", 8, 16 + (i - 1) * 32, color_white)
            end
        end

    cam.End3D2D()
end