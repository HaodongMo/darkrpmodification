--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()

    if !self:IsPowered() then return end

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    surface.SetFont("HUDNumber5")
    local text = ""
    if self:GetHasCook() then
        if self:GetCookTime() > 0 then
            local cooktime = self:GetCookTime()

            text = string.FormattedTime(cooktime, "%02i:%02i")
        else
            text = "DONE"
        end
    else
        text = "00:00"
    end

    local TextWidth = surface.GetTextSize(text)

    Ang:RotateAroundAxis(Ang:Forward(), -90)
    Ang:RotateAroundAxis(Ang:Up(), 180)

    cam.Start3D2D(Pos + Ang:Up() * 10.5 + Ang:Right() * -11 + Ang:Forward() * 12.25, Ang, 0.06)
        draw.WordBox(2, -TextWidth * 0.5, -68, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
end

function ENT:Think()
end
