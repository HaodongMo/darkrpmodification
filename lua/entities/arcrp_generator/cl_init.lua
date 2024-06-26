--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

function ENT:Initialize()
end

local clr_bar_bg = Color(75, 75, 75, 255)
local clr_fuel = Color(150, 150, 0, 100)
local clr_conn = Color(0, 0, 150, 100)
local clr_on = Color(30, 150, 25, 255)

function ENT:Draw()
    self:DrawModel()

    if self.Show3D2D then
        local Pos = self:GetPos()
        local Ang = self:GetAngles()

        Ang:RotateAroundAxis(Ang:Up(), 180)
        Ang:RotateAroundAxis(Ang:Forward(), 90)

        cam.Start3D2D(Pos + Ang:Up() * 21 + Ang:Forward() * -2.5 + Ang:Right() * -63.5, Ang, 0.08)
            draw.RoundedBox(8, 0, 5, 250, 40, clr_bar_bg)
            draw.RoundedBox(8, 0, 5, 250 * (self:GetFuel() / self:GetCapacity()), 40, clr_fuel)
            draw.SimpleText(string.ToMinutesSeconds(self:GetFuelTime()), "HUDNumber5", 125, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(8, 0, 50, 250, 40, clr_bar_bg)
            draw.RoundedBox(8, 0, 50, 250 * (self:GetConnectedEntityAmount() / self:GetMaxConnectedEntities()), 40, clr_conn)
            draw.SimpleText(tostring(self:GetConnectedEntityAmount()) .. " / " .. self:GetMaxConnectedEntities(), "HUDNumber5", 125, 50 + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(8, 0, 100, 80, 50, self:IsPowered() and clr_on or clr_bar_bg)
            draw.SimpleText(self:GetSwitchedOn() and "ON" or "OFF", "HUDNumber5", 40, 125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(8, 0, 165, 250, 40, Color(140, 0, 0, 100))
            draw.SimpleText("CAP UPG " .. self:GetCapacityUpgrades() .. "/" .. self.MaxCapacityUpgrades, "HUDNumber5", 125, 165 + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(8, 0, 210, 250, 40, Color(140, 0, 0, 100))
            draw.SimpleText("CONN UPG " .. self:GetConnectionUpgrades() .. "/" .. self.MaxConnectionUpgrades, "HUDNumber5", 125, 210 + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


        cam.End3D2D()
    end
end

function ENT:Think() end