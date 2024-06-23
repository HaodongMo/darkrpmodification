local bgframe = nil

function ArcRP_OpenVendingMachine()
    if bgframe and IsValid(bgframe) then
        bgframe:Remove()
    end

    bgframe = vgui.Create("DFrame")
    bgframe:SetSize(ScreenScale(200), ScrH() * 0.8)
    bgframe:Center()
    bgframe:SetTitle("Buy Guns and Ammo")
    bgframe:MakePopup()
    bgframe.Paint = function(self2, w, h)
    end

    local scroll = vgui.Create("DScrollPanel", bgframe)
    scroll:Dock(FILL)

    function scroll.Paint(self, w, h)
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

    local grid = vgui.Create("DIconLayout", scroll)
    grid:Dock(FILL)
    grid:SetSpaceY(ScreenScale(4))
    grid:SetSpaceX(ScreenScale(4))
    grid:SetBorder(ScreenScale(8))
    grid:SetLayoutDir(TOP)

    local ammo_label = grid:Add( "DLabel" )
    ammo_label.OwnLine = true
    ammo_label:SetText( "Ammunition" )
    ammo_label:SetFont( "TacRP_HD44780A00_5x8_8" )
    ammo_label:SetWide(bgframe:GetWide())
    ammo_label:SetTall(ScreenScale(8))

    for i, t in ipairs(GAMEMODE.Config.vendingMachineAmmo) do
        local but = grid:Add( "DButton" )
        but:SetText( "" )
        but:SetSize( ScreenScale(85), ScreenScale(20) )
        but.ammotype = t.ammo
        but.ammodata = t
        but.pricetext = DarkRP.formatMoney(t.cost)
        but.Paint = function(self2, w, h)
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
            local tw = surface.GetTextSize(self2.ammodata.name)
            surface.SetTextPos((w - tw) / 2, ScreenScale(2))
            surface.DrawText(self2.ammodata.name)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("TacRP_HD44780A00_5x8_6")
            local tw2, th2 = surface.GetTextSize(self2.pricetext)
            surface.SetTextPos((w - tw2) / 2, h - th2 - ScreenScale(2))
            surface.DrawText(self2.pricetext)
        end
        but.DoClick = function()
            if (LocalPlayer():getDarkRPVar("money") or 0) < t.cost then return end

            net.Start("arcrp_buyammo")
            net.WriteUInt(i, 8)
            net.SendToServer()
        end
    end

    local weapons_label = grid:Add( "DLabel" )
    weapons_label.OwnLine = true
    weapons_label:SetText( "Weapons" )
    weapons_label:SetFont( "TacRP_HD44780A00_5x8_8" )
    weapons_label:SetWide(bgframe:GetWide())
    weapons_label:SetTall(ScreenScale(8))

    local vendingWeapons = {}

    for weapon, cost in pairs(GAMEMODE.Config.vendingMachineGuns) do
        table.insert(vendingWeapons, {
            cost = cost,
            weapon = weapon
        })
    end

    table.sort(vendingWeapons, function(a, b)
        return a.cost < b.cost
    end)

    for i, data in ipairs(vendingWeapons) do
        local but = grid:Add( "DButton" )
        local weapon_class = weapons.Get(data.weapon)
        local prohibited = !GAMEMODE.Config.vendingMachineNoLicense and GAMEMODE.Config.vendingMachineRequireLicense[data.weapon] and !LocalPlayer():getDarkRPVar("HasGunlicense")
        but:SetText("")
        but:SetSize( ScreenScale(55), ScreenScale(55) )
        but.name = weapon_class.AbbrevName or weapon_class.PrintName
        but.price = data.cost
        but.pricetext = DarkRP.formatMoney(data.cost)
        but.weapon = data.weapon
        but.mat = Material("entities/" .. data.weapon .. ".png", "smooth")
        but.prohibited = prohibited
        but.Paint = function(self2, w, h)
            if self2.prohibited then
                surface.SetDrawColor(255, 50, 50, 50)
            else
                if self2:IsDown() then
                    surface.SetDrawColor(255, 255, 255, 150)
                elseif self2:IsHovered() then
                    surface.SetDrawColor(255, 255, 255, 50)
                else
                    surface.SetDrawColor(0, 0, 0, 150)
                end
            end

            TacRP.DrawCorneredBox(0, 0, w, h)

            surface.SetMaterial(self2.mat)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("TacRP_HD44780A00_5x8_6")
            local tw = surface.GetTextSize(self2.name)
            if tw > w then
                surface.SetFont("TacRP_HD44780A00_5x8_4")
                tw = surface.GetTextSize(self2.name)
            end
            surface.SetTextPos((w - tw) / 2, ScreenScale(2))
            surface.DrawText(self2.name)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("TacRP_HD44780A00_5x8_6")
            local tw2, th2 = surface.GetTextSize(self2.pricetext)
            surface.SetTextPos((w - tw2) / 2, h - th2 - ScreenScale(2))
            surface.DrawText(self2.pricetext)
        end
        but.DoClick = function()
            if prohibited then return end
            if (LocalPlayer():getDarkRPVar("money") or 0) < data.cost then return end

            net.Start("arcrp_buyweapon")
            net.WriteString(data.weapon)
            net.SendToServer()
        end
    end
end