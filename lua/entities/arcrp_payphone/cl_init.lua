include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:OpenHitmanMenu()
    local bg = vgui.Create("DFrame")
    bg:SetSize(ScreenScale(100), ScreenScale(250))
    bg:Center()
    bg:MakePopup()
    bg:SetTitle("Select Target")
    bg.Paint = function(self2, w, h)
    end

    local scroll = vgui.Create("DScrollPanel", bg)
    scroll:Dock(FILL)

    function scroll:Paint(w, h)
        local c_bg = TacRP.GetPanelColor("bg")
        surface.SetDrawColor(c_bg)
        surface.DrawRect(0, 0, w, h)
    end
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
        local c_bg, c_txt = TacRP.GetPanelColor("bg2", self:IsHovered()), TacRP.GetPanelColor("text", self:IsHovered())
        surface.SetDrawColor(c_bg)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("↑", "TacRP_HD44780A00_5x8_4", w / 2, h / 2, c_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function sbar.btnDown:Paint(w, h)
        local c_bg, c_txt = TacRP.GetPanelColor("bg2", self:IsHovered()), TacRP.GetPanelColor("text", self:IsHovered())        surface.SetDrawColor(c_bg)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("↓", "TacRP_HD44780A00_5x8_4", w / 2, h / 2, c_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function sbar.btnGrip:Paint(w, h)
        local c_bg, c_cnr = TacRP.GetPanelColor("bg2", self:IsHovered()), TacRP.GetPanelColor("corner", self:IsHovered())        surface.SetDrawColor(c_bg)
        TacRP.DrawCorneredBox(0, 0, w, h, c_cnr)
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply == LocalPlayer() then continue end
        if ply:Team() == TEAM_CITIZEN then continue end

        local cost = ArcRP_GetHitCost(ply)

        local button = vgui.Create("DButton", scroll)
        button:SetText("")
        button:Dock(TOP)
        button.player = ply
        button.label = ply:GetName() .. " (" .. DarkRP.formatMoney(cost) .. ")"
        button.cost = cost
        button.Paint = function(self2, w, h)
            if self2:IsDown() then
                surface.SetDrawColor(255, 255, 255, 150)
            elseif self2:IsHovered() then
                surface.SetDrawColor(255, 255, 255, 50)
            else
                surface.SetDrawColor(0, 0, 0, 150)
            end

            TacRP.DrawCorneredBox(0, 0, w, h)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("TacRP_HD44780A00_5x8_4")
            local tw = surface.GetTextSize(self2.label)
            surface.SetTextPos((w - tw) / 2, ScreenScale(2))
            surface.DrawText(self2.label)
        end
        button.DoClick = function()
            if (LocalPlayer():getDarkRPVar("money") or 0) < cost then return end

            net.Start("arcrp_placehit")
            net.WriteEntity(self)
            net.WriteEntity(ply)
            net.SendToServer()

            bg:Remove()
        end
        scroll:AddItem(button)
    end
end