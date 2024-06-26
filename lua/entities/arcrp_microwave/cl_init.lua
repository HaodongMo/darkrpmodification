--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()

    // local Pos = self:GetPos()
    // local Ang = self:GetAngles()

    // surface.SetFont("HUDNumber5")
    // local text = "Money Printer"
    // local text2 = ""
    // if !self:IsPowered() then
    //     text2 = "No Power - Cannot Print"
    // else
    //     text2 = "Paper: " .. tostring(self:GetPaper()) .. "/" .. self:GetCapacity()
    // end
    // local text3 = "Stored: " .. DarkRP.formatMoney(self:GetMoney())
    // local TextWidth = surface.GetTextSize(text)
    // local TextWidth2 = surface.GetTextSize(text2)
    // local TextWidth3 = surface.GetTextSize(text3)

    // Ang:RotateAroundAxis(Ang:Up(), 90)

    // cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
    //     draw.WordBox(2, -TextWidth * 0.5, -68, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    //     draw.WordBox(2, -TextWidth2 * 0.5, -24, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    //     draw.WordBox(2, -TextWidth3 * 0.5, 18, text3, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    // cam.End3D2D()
end

function ENT:Think()
end
