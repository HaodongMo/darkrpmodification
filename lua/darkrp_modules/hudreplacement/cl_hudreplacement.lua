--[[---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------]]

local hideHUDElements = {
    -- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
    -- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
    ["DarkRP_HUD"] = false,

    -- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
    -- This also draws the information on doors and vehicles
    ["DarkRP_EntityDisplay"] = true,

    -- This is the one you're most likely to replace first
    -- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
    -- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
    ["DarkRP_LocalPlayerHUD"] = true,

    -- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
    -- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
    ["DarkRP_Hungermod"] = false,

    -- Drawing the DarkRP agenda
    ["DarkRP_Agenda"] = false,

    -- Lockdown info on the HUD
    ["DarkRP_LockdownHUD"] = false,

    -- Arrested HUD
    ["DarkRP_ArrestedHUD"] = false,

    -- Chat receivers box when you open chat or speak over the microphone
    ["DarkRP_ChatReceivers"] = false,

    -- hl2 ammo
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
    if hideHUDElements[name] then return false end
end)

hook.Add("HUDDrawDoorData", "HideDrawDoorData", function(door)
    return true
end)

local rackrisetime = 0
local lastrow = 0

local col = Color(255, 255, 255)
local col_hi = Color(255, 150, 0)
local col_bal = Color(255, 200, 100)
local col_amr = Color(200, 200, 255)
local col_hi2 = Color(255, 230, 200)
local col_dark = Color(255, 255, 255, 20)
local col_super = Color(255, 255, 100)

local surfaceSetColor = surface.SetTextColor
local surfaceSetFont = surface.SetFont
local surfaceSetTextPos = surface.SetTextPos
local surfaceDrawText = surface.DrawText
local surfaceDrawTexturedRect = surface.DrawTexturedRect
local surfaceSetDrawColor = surface.SetDrawColor
local surfaceSetMaterial = surface.SetMaterial
local surfaceDrawRect = surface.DrawRect
local surfaceGetTextSize = surface.GetTextSize
local surfaceSetTextColor = surface.SetTextColor
local surfaceDrawOutlinedRect = surface.DrawOutlinedRect
local surfaceDrawLine = surface.DrawLine

local function hudPaintHealth()
    local w = TacRP.SS(128)
    local h = TacRP.SS(40)
    local x = TacRP.SS(8)
    local y = ScrH() - h - TacRP.SS(8)

    local hpb_x = x + TacRP.SS(14)
    local hpb_y = y + h - TacRP.SS(18)
    local hpb_w = TacRP.SS(2)
    local hpb_h = TacRP.SS(8)
    local hpb_h2 = TacRP.SS(6)

    local hpb_segments = 36

    local hpb_y2 = y + h - TacRP.SS(8)

    local armor = LocalPlayer():Armor()

    if armor > 0 then
        hpb_h = TacRP.SS(5)
    end

    local arm_y = hpb_y + hpb_h + TacRP.SS(1)

    surfaceSetDrawColor(0, 0, 0, 150)
    TacRP.DrawCorneredBox(x, y, w, h, col)

    local nametext = LocalPlayer():Nick()
    surfaceSetFont("TacRP_HD44780A00_5x8_8")
    surfaceSetTextPos(x + TacRP.SS(3), y + TacRP.SS(1))
    surfaceSetColor(col)
    surfaceDrawText(nametext)

    local salary = LocalPlayer():getDarkRPVar("salary")
    if GetGlobalFloat("SalarySuppressionEndTime", 0) > CurTime() then salary = 0 end

    local salarytext = DarkRP.formatMoney(salary) or ""
    local wallettext = (DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")) or "") .. " (+" .. salarytext .. ")"

    surfaceSetFont("TacRP_HD44780A00_5x8_6")
    surfaceSetTextPos(x + TacRP.SS(3), y + TacRP.SS(12))
    surfaceDrawText(wallettext)

    -- on the right hand side
    local jobtext = LocalPlayer():getDarkRPVar("job") or ""
    local ts, th = surfaceGetTextSize(jobtext)
    if ts >= w * 0.4 then
        surfaceSetFont("TacRP_HD44780A00_5x8_5")
        ts, th = surfaceGetTextSize(jobtext)
    end
    surfaceSetTextPos(x + w - TacRP.SS(3) - ts, y + TacRP.SS(18) - th)
    surfaceDrawText(jobtext)

    -- Health / Armor

    local perc = LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
    local arm_perc = math.Clamp(armor / 100, 0, 1)

    surfaceSetTextPos(x + TacRP.SS(6), hpb_y - TacRP.SS(2))
    surfaceSetFont("TacRP_HD44780A00_5x8_10")

    if perc <= 0.2 then
        surfaceSetTextColor(col_hi)
        if math.sin(CurTime() * 7) > 0.5 then
            surfaceSetTextColor(col)
        end
    elseif perc <= 0.4 then
        surfaceSetTextColor(col_hi)
    else
        surfaceSetTextColor(col)
    end

    surfaceDrawText("♥")

    local hpb_canraw = math.ceil(hpb_segments * perc)

    hpb_can = math.min(hpb_canraw, hpb_segments)

    local overheal = hpb_canraw - hpb_can

    for i = 1, hpb_segments do
        if overheal >= i then
            surfaceSetDrawColor(col_super)
        else
            if hpb_can <= 2 then
                surfaceSetDrawColor(col_hi)
            else
                surfaceSetDrawColor(col)
            end
        end

        if hpb_can >= i then
            surfaceDrawRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), hpb_y, hpb_w, hpb_h)
        else
            surfaceDrawOutlinedRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), hpb_y, hpb_w, hpb_h)
        end
    end

    if armor > 0 then
        surfaceSetDrawColor(col_amr)
        local arm_can = math.ceil(hpb_segments * arm_perc)

        arm_can = math.min(arm_can, hpb_segments)

        for i = 1, hpb_segments do
            if arm_can >= i then
                surfaceDrawRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), arm_y, hpb_w, TacRP.SS(2))
            else
                surfaceDrawOutlinedRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), arm_y, hpb_w, TacRP.SS(2))
            end
        end
    end

    surfaceSetDrawColor(col)
    surfaceDrawLine(x + TacRP.SS(2), hpb_y - TacRP.SS(2), x + w - TacRP.SS(2), hpb_y - TacRP.SS(2))

    if LocalPlayer().IMDE_GetBalance then
        -- Balance / Stamina
        local stamina_perc = LocalPlayer():IMDE_GetStamina() / LocalPlayer():IMDE_GetMaxStamina()
        local balance_perc = LocalPlayer():IMDE_GetBalance() / LocalPlayer():IMDE_GetMaxBalance()

        surfaceSetFont("TacRP_HD44780A00_5x8_6")
        local ew, eh = surfaceGetTextSize("E")

        surfaceSetTextPos(x + TacRP.SS(7), hpb_y2 + hpb_h2 / 2 - eh / 2)
        surfaceSetTextColor(col)
        surfaceDrawText("E")

        local hpb_can = math.min(math.ceil(hpb_segments * stamina_perc), hpb_segments)

        for i = 1, hpb_segments do
            if i / hpb_segments <= balance_perc then
                surfaceSetDrawColor(col_bal)
            else
                surfaceSetDrawColor(col)
            end
            if hpb_can >= i then
                surfaceDrawRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), hpb_y2, hpb_w, hpb_h2)
            else
                surfaceDrawOutlinedRect(hpb_x + (i * (hpb_w + TacRP.SS(1))), hpb_y2, hpb_w, hpb_h2)
            end
        end
    end

    -- License
    local has_license = LocalPlayer():getDarkRPVar("HasGunlicense")
    if has_license then

        surfaceSetFont("TacRP_HD44780A00_5x8_4")
        local txt = "[Licensed]"
        local ew, eh = surfaceGetTextSize(txt)

        surfaceSetTextPos(x + w - ew - TacRP.SS(2), y + TacRP.SS(2))
        surfaceSetTextColor(col)
        surfaceDrawText(txt)

    end

    lasthp = LocalPlayer():Health()
end

local function hudPaintAmmo()
    local w = TacRP.SS(110)
    local h = TacRP.SS(24)
    local x = ScrW() - w - TacRP.SS(8)
    local y = ScrH() - h - TacRP.SS(8)
    local wpn = LocalPlayer():GetActiveWeapon()

    if !IsValid(wpn) then return end

    local clipsize = wpn:GetMaxClip1()

    if clipsize <= 0 and !wpn.ArcticTacRP then return end

    surfaceSetDrawColor(0, 0, 0, 150)
    TacRP.DrawCorneredBox(x, y, w, h, col)

    local name_txt = wpn:GetPrintName()
    local getValue = wpn.GetValue

    if wpn.ArcticTacRP then
        name_txt = getValue(wpn, "AbbrevName") or getValue(wpn, "PrintName")
    end

    surfaceSetFont("TacRP_HD44780A00_5x8_8")
    local tw = surfaceGetTextSize(name_txt)
    surfaceSetTextPos(x + TacRP.SS(3), y + TacRP.SS(1))
    if tw > w then
        surfaceSetFont("TacRP_HD44780A00_5x8_6")
        tw = surfaceGetTextSize(name_txt)
    elseif tw > w - TacRP.SS(3) then
        surfaceSetTextPos(x + TacRP.SS(1.5), y + TacRP.SS(1))
    end
    surfaceSetColor(col)
    surfaceDrawText(name_txt)

    local ammotype = wpn:GetPrimaryAmmoType()
    if wpn.ArcticTacRP then
        ammotype = getValue(wpn, "PrimaryGrenade") and (TacRP.QuickNades[getValue(wpn, "PrimaryGrenade")].Ammo) or getValue(wpn, "Ammo")
    end
    local clips = math.min(math.ceil(wpn:GetOwner():GetAmmoCount(ammotype)), 999) 

    if clipsize > 0 then

        if TacRP.ConVars["hud_ammo_number"]:GetBool() then
            surfaceSetFont("TacRP_HD44780A00_5x8_10")
            local t = math.max(0, wpn:Clip1()) .. " /" .. clipsize
            local tw = surfaceGetTextSize(t)
            surfaceSetColor(col)
            surfaceSetTextPos(x + w - tw - TacRP.SS(40), y + TacRP.SS(12))
            surfaceDrawText(t)
        else
            local sb = TacRP.SS(4)
            local xoffset = TacRP.SS(77)
            -- local pw = TacRP.SS(1)

            local row1_bullets = 0
            local row2_bullets = 0
            local rackrise = 0
            local cs = wpn:GetMaxClip1()
            local c1 = wpn:Clip1()
            local aps = 1

            if wpn.ArcticTacRP then
                cs = wpn:GetCapacity()
                aps = getValue(wpn, "AmmoPerShot")
            end

            local row_size = 15
            if cs == 20 then
                row_size = 10
            end

            local row = math.ceil(c1 / row_size)
            local maxrow = math.ceil(cs / row_size)

            local row2_size = math.min(row_size, cs)
            local row1_size = math.Clamp(cs - row2_size, 0, row_size)

            if c1 > row_size * 2 then
                if row == maxrow then
                    row1_size = cs - row_size * (maxrow - 1)
                    row1_bullets = c1 - row_size * (maxrow - 1)
                elseif c1 % row_size == 0 then
                    row1_bullets = row_size
                else
                    row1_bullets = c1 % row_size
                end
                row2_bullets = row2_size
            else
                row2_bullets = math.min(row2_size, c1)
                row1_bullets = math.min(row1_size, c1 - row2_bullets)
            end

            if row > 1 and row < lastrow then
                rackrisetime = CurTime()
            end
            lastrow = row

            if rackrisetime + 0.2 > CurTime() then
                local rackrisedelta = ((rackrisetime + 0.2) - CurTime()) / 0.2
                rackrise = rackrisedelta * (sb + TacRP.SS(1))
            end

            render.SetScissorRect(x, y, x + w, y + TacRP.SS(12) + sb + sb + 3, true)

            for i = 1, row1_size do
                if i >= row1_bullets - aps + 1 and i <= row1_bullets then
                    surfaceSetDrawColor(col_hi)
                elseif i > row1_bullets then
                    surfaceSetDrawColor(col_dark)
                elseif i % 5 == 0 then
                    surfaceSetDrawColor(col_hi2)
                else
                    surfaceSetDrawColor(col)
                end
                surfaceDrawRect(x + xoffset - (i * (sb + TacRP.SS(1))), y + TacRP.SS(12) + rackrise, sb, sb)
            end

            local hi_left = math.max(0, aps - row1_bullets)
            for i = 1, row2_size do
                if (i >= row2_bullets - aps + 1 and i <= row2_bullets and row1_bullets <= 0) or (row1_bullets > 0 and hi_left > 0 and i >= row2_bullets - hi_left + 1 and i <= row2_bullets) then
                    surfaceSetDrawColor(col_hi)
                elseif i > row2_bullets then
                    surfaceSetDrawColor(col_dark)
                elseif i % 5 == 0 then
                    surfaceSetDrawColor(col_hi2)
                else
                    surfaceSetDrawColor(col)
                end

                if row1_size == 0 and row2_size <= 10 then
                    local m = 1.5
                    if row2_size <= 5 then
                        m = 2
                    end

                    surfaceDrawRect(x + xoffset - (i * (sb * m + TacRP.SS(1))), y + TacRP.SS(12 + 1) + sb * (2 - m) / 2, sb * m, sb * m)
                else
                    surfaceDrawRect(x + xoffset - (i * (sb + TacRP.SS(1))), y + TacRP.SS(12 + 1) + sb + rackrise, sb, sb)
                end
            end
        end

        render.SetScissorRect(0, 0, 0, 0, false)

        if clipsize <= 0 and ammotype == "" then
            clips = ""
        elseif ammotype == "" then
            clips = "---"
        elseif clipsize > 0 then
            surfaceSetColor(col)
            surfaceSetTextPos(x + w - TacRP.SS(31), y + TacRP.SS(16))
            surfaceSetFont("TacRP_HD44780A00_5x8_6")
            surfaceDrawText("+")
            if wpn.ArcticTacRP and ((getValue(wpn, "PrimaryGrenade") and TacRP.IsGrenadeInfiniteAmmo(getValue(wpn, "PrimaryGrenade"))) or (!getValue(wpn, "PrimaryGrenade") and wpn:GetInfiniteAmmo())) then
                clips = "INF"
            end
        end

        surfaceSetColor(col)
        surfaceSetTextPos(x + w - TacRP.SS(25), y + TacRP.SS(12))
        surfaceSetFont("TacRP_HD44780A00_5x8_10")
        surfaceDrawText(clips)
    else
        if !ammotype or ammotype == -1 or ammotype == "" then
            clips = ""
        elseif wpn.ArcticTacRP and ((getValue(wpn, "PrimaryGrenade") and TacRP.IsGrenadeInfiniteAmmo(getValue(wpn, "PrimaryGrenade"))) or (!getValue(wpn, "PrimaryGrenade") and wpn:GetInfiniteAmmo())) then
            clips = "INF"
        end

        if wpn.ArcticTacRP and getValue(wpn, "PrimaryGrenade") then
            local nade = TacRP.QuickNades[getValue(wpn, "PrimaryGrenade")]
            if nade.Icon then
                local sg = TacRP.SS(16)
                surfaceSetMaterial(nade.Icon)
                surfaceSetDrawColor(255, 255, 255)
                surfaceDrawTexturedRect(x + TacRP.SS(4), y + h - sg + TacRP.SS(1), sg, sg)
            end

            surfaceSetColor(col)
            surfaceSetTextPos(x + TacRP.SS(24), y + h - TacRP.SS(13))
            surfaceSetFont("TacRP_HD44780A00_5x8_10")
            surfaceDrawText("x" .. clips)
        else
            surfaceSetColor(col)
            surfaceSetTextPos(x + TacRP.SS(36), y + TacRP.SS(12))
            surfaceSetFont("TacRP_HD44780A00_5x8_10")
            surfaceDrawText(clips)
        end
    end

    if wpn.ArcticTacRP and wpn:GetFiremodeAmount() > 0 then
        if wpn:GetSafe() then
            surfaceSetMaterial(wpn:GetFiremodeMat(0))
        else
            surfaceSetMaterial(wpn:GetFiremodeMat(wpn:GetCurrentFiremode()))
        end
        surfaceSetDrawColor(col)
        local sfm = TacRP.SS(10)
        surfaceDrawTexturedRect(x + w - sfm - TacRP.SS(1 + 2), y + h - sfm - TacRP.SS(12), sfm, sfm)
    end
end

local contextindex = 1
local lastcontextent = NULL
local startinteracttime = 0
local interacting_ent = NULL
local interacting_context = nil
local interacting_index = 0
local lastusetime = 0
local lastcontext = nil

local function cancelUse()
    net.Start("arcrp_customusefinish")
    net.WriteBool(true)
    net.SendToServer()

    interacting_ent = NULL
end

local function finishUse()
    net.Start("arcrp_customusefinish")
    net.WriteBool(false)
    net.SendToServer()

    interacting_ent = NULL
end

local function hudPaint()
    if !LocalPlayer():Alive() then return end

    hudPaintAmmo()
    hudPaintHealth()

    -- hitman hud

    if false and LocalPlayer():hasHit() then
        local victim = LocalPlayer():getHitTarget()

        local text = "Assassination Target:"
        local text2 = victim:GetName()

        local font = "TacRP_HD44780A00_5x8_4"
        local font2 = "TacRP_HD44780A00_5x8_6"

        surface.SetFont(font2)
        local w = surface.GetTextSize(text2)
        w = math.max(w, ScreenScale(72))
        local h = ScreenScale(16)
        local x = ScrW() / 2 - (w / 2)
        local y = ScrH() - h - ScreenScale(4)

        surface.SetFont(font)

        surface.SetDrawColor(0, 0, 0, 200)
        TacRP.DrawCorneredBox(x, y, w, h)

        local textcol = Color(255, 255, 255)
        draw.SimpleText(text, font, x + TacRP.SS(4), y + TacRP.SS(2), textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleText(text2, font2, x + TacRP.SS(4), y + TacRP.SS(2 + 6), textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    -- Context menu

    local longUsing = false
    local time, perc

    if IsValid(interacting_ent) and contextindex != interacting_index then
        cancelUse()
    elseif IsValid(interacting_ent) and contextindex == interacting_index then
        longUsing = true

        time = CurTime() - startinteracttime
        perc = math.min(time / interacting_context.interacttime, 1)

        if perc == 1 then
            finishUse()
        end
    end

    local ent

    if longUsing then
        ent = interacting_ent
    else
        local tr = LocalPlayer():GetEyeTrace()
        ent = tr.Entity

        if !IsValid(ent) and lastusetime + 1 > CurTime() then
            ent = lastcontextent
        end
    end

    if !IsValid(ent) or ent:GetPos():DistToSqr(EyePos()) >= 128 * 128 then
        interacting_ent = NULL
        return
    end

    if lastcontextent != ent then
        contextindex = 1
    end

    local customContextHint = ArcRP_GetCustomContextHint(ent, LocalPlayer())

    if ent.contextHint or ent.interactionHint or customContextHint then
        local text = customContextHint or ""

        if ent.contextHint then
            if isfunction(ent.contextHint) then
                text = ent:contextHint() or text
            else
                text = ent.contextHint
            end
        end

        if ent.interactionHint and ent:GetNWInt("arcrp_salescost", 0) == 0 then
            local interactionText
            if isfunction(ent.interactionHint) then
                interactionText = ent:interactionHint()
            else
                interactionText = ent.interactionHint
            end

            if interactionText then
                text = "[" .. TacRP.GetBindKey("+use") .. "] " .. interactionText
            end
        end

        text = text or ""

        if text != "" then
            local font = "TacRP_HD44780A00_5x8_4"
            surface.SetFont(font)
            local w, h = surface.GetTextSize(text)
            w = w + TacRP.SS(8)
            h = h + TacRP.SS(4)

            local textcol = Color(255, 255, 255)
            surface.SetDrawColor(0, 0, 0, 200)

            TacRP.DrawCorneredBox(ScrW() / 2 - w / 2, ScrH() / 2 + TacRP.SS(16), w, h)
            draw.SimpleText(text, font, ScrW() / 2, ScrH() / 2 + TacRP.SS(16) + h / 2, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local context = ArcRP_GetCustomContextMenu(ent, LocalPlayer())

    if !context then
        if lastcontext and lastusetime + 1 > CurTime() then
            context = lastcontext
        else
            contextindex = 1
            return
        end
    end

    if contextindex > #context then
        contextindex = #context
    end

    lastcontext = context
    lastcontextent = ent

    local x = ScrW() / 2 - TacRP.SS(16)
    local y = ScrH() / 2 + TacRP.SS(32)

    for index, item in ipairs(context) do
        local selected = index == contextindex

        local text = item.message

        local font = "TacRP_HD44780A00_5x8_4"
        if selected then
            font = "TacRP_HD44780A00_5x8_6"
        end
        surface.SetFont(font)
        local w, h = surface.GetTextSize(text)
        w = w + TacRP.SS(8)
        h = h + TacRP.SS(4)

        if selected then
            local sfont = "TacRP_HD44780A00_5x8_4"
            local s = TacRP.SS(8)
            local d = 0
            local animtime = 0.5

            local utime = math.min(CurTime() - lastusetime, animtime)

            if utime < animtime then
                local prog = utime / animtime
                local a = prog - 1
                d = math.sin(16 * a) * (1 - (prog * prog))
            end

            if d == 0 then
                surface.SetDrawColor(Color(255, 150, 0))
            else
                surface.SetDrawColor(Color(
                    Lerp(d, 255, 255),
                    Lerp(d, 150, 225),
                    Lerp(d, 0, 200)))
            end
            TacRP.DrawCorneredBox(x - s - TacRP.SS(4), y + TacRP.SS(1), s, s)
            draw.SimpleText(TacRP.GetBind("use"), sfont, x - s, y + TacRP.SS(3), Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            if index > 1 then
                draw.SimpleText("↑", sfont, x - s, y + TacRP.SS(3) - s - (TacRP.SS(1) * math.sin(CurTime() * 4)), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end

            if index < #context then
                draw.SimpleText("↓", sfont, x - s, y + TacRP.SS(3) + s + (TacRP.SS(1) * math.sin(CurTime() * 4)), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end
        end

        local textcol = Color(255, 255, 255)
        surface.SetDrawColor(0, 0, 0, 200)

        TacRP.DrawCorneredBox(x, y, w, h)
        draw.SimpleText(text, font, x + TacRP.SS(4), y + TacRP.SS(2), textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        if longUsing and selected then
            surface.SetDrawColor(255, 255, 255, 150)
            surface.DrawRect(x, y, w * perc, h)

            render.SetScissorRect(x, y, x + w * perc, y + h, true)
            draw.SimpleText(text, font, x + TacRP.SS(4), y + TacRP.SS(2), Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            render.SetScissorRect(0, 0, 0, 0, false)
        end

        if selected then
            y = y + TacRP.SS(12)
        else
            y = y + TacRP.SS(10)
        end
    end

    lastcontextent = ent
end

hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)


hook.Add("HUDDrawTargetID", "DarkRP_Mod_HUDPaint", function()
    -- Names above heads

    local players = player.GetAll()

    cam.Start3D()
    for _, ply in ipairs(players) do
        if ply == LocalPlayer() then continue end
        if ply:GetNoDraw() then ply.NamePercentage = 0 continue end
        if !ply:Alive() then ply.NamePercentage = 0 continue end
        local targetnamepercentage = 1

        if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 512 * 512 then
            targetnamepercentage = 0
        end

        if targetnamepercentage > 0 then
            local dot = ply:EyeAngles():Forward():Dot(LocalPlayer():EyeAngles():Forward())
            if dot > 0.5 then
                targetnamepercentage = 0
            end
        end

        if targetnamepercentage > 0 then
            local etr = util.TraceLine({
                start = EyePos(),
                endpos = ply:EyePos(),
                mask = MASK_OPAQUE,
                filter = {
                    LocalPlayer(),
                    ply
                }
            })

            if etr.Hit then
                targetnamepercentage = 0
            end
        end

        ply.NamePercentage = ply.NamePercentage or 0

        ply.NamePercentage = math.Approach(ply.NamePercentage, targetnamepercentage, FrameTime() / 0.75)

        if ply.NamePercentage <= 0 then continue end

        local pos = ply:GetPos() + Vector(0, 0, 76)
        local ToScreen = pos:ToScreen()

        ply.nameToScreenPos = ToScreen
    end
    cam.End3D()

    for _, ply in ipairs(players) do
        if ply == LocalPlayer() then continue end
        if !ply.nameToScreenPos then continue end

        local x = ply.nameToScreenPos.x
        local y = ply.nameToScreenPos.y - TacRP.SS(12)
        local nameperc = ply.NamePercentage

        if nameperc <= 0 then
            ply.JunkName = nil
            continue
        end

        local text = ply:GetName()
        local namelen = string.len(text)

        if !ply.JunkName then
            ply.JunkName = ""
            for i = 1, namelen do
                ply.JunkName = ply.JunkName .. string.char(math.random(32, 126))
            end
        end

        local resolved_chars = math.ceil(namelen * nameperc)

        text = string.sub(text, 1, resolved_chars)
        for i = resolved_chars, namelen - 1 do
            text = text .. ply.JunkName[i]
        end

        local font = "TacRP_HD44780A00_5x8_6"
        surface.SetFont(font)
        local w, h = surface.GetTextSize(text)
        w = w + TacRP.SS(8)
        h = h + TacRP.SS(4)

        local textcol = Color(255, 255, 255, nameperc * 255)
        surface.SetDrawColor(0, 0, 0, nameperc * 100)

        TacRP.DrawCorneredBox(x - w / 2, y, w, h)
        draw.SimpleText(text, font, x, y + h / 2, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local text2 = ""

        if ply:getDarkRPVar("wanted") then
            text2 = "WANTED"
        elseif ply:getDarkRPVar("HasGunlicense") then
            text2 = "Licensed"
        end

        if text2 != "" then
            local y2 = y + TacRP.SS(12)
            local x2 = x
            local font2 = "TacRP_HD44780A00_5x8_4"
            surface.SetFont(font2)
            local w2, h2 = surface.GetTextSize(text2)
            w2 = w2 + TacRP.SS(8)
            h2 = h2 + TacRP.SS(4)

            local textcol2 = Color(255, 255, 255, nameperc * 255)
            surface.SetDrawColor(0, 0, 0, nameperc * 100)

            TacRP.DrawCorneredBox(x2 - w2 / 2, y2, w2, h2)
            draw.SimpleText(text2, font2, x2, y2 + h2 / 2, textcol2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end)

local function contextScroll(val)
    local tr = LocalPlayer():GetEyeTrace()

    local ent = tr.Entity
    if !IsValid(ent) or ent:GetPos():DistToSqr(EyePos()) >= 128 * 128 then
        return
    end

    local context = ArcRP_GetCustomContextMenu(ent, LocalPlayer())

    if !context then return end

    local min = 1
    local max = #context

    if #context > 1 then
        contextindex = contextindex + val
    end

    contextindex = math.Clamp(contextindex, min, max)

    return true
end

hook.Add("InputMouseApply", "ArcRP_ContextMenu_Wheel", function(cmd, x, y, ang)
    if input.LookupBinding( "invnext" ) and input.LookupBinding( "invprev" ) then return end

    contextScroll(-cmd:GetMouseWheel())
end)

hook.Add( "PlayerBindPress", "ArcRP_ContextMenu_Interact", function(ply, bind, pressed)
    local block = nil

    if pressed and bind == "invnext" then
        block = contextScroll(1)
    elseif pressed and bind == "invprev" then
        block = contextScroll(-1)
    elseif pressed and bind == "+use" then
        local tr = LocalPlayer():GetEyeTrace()

        local ent = tr.Entity
        if !IsValid(ent) or ent:GetPos():DistToSqr(EyePos()) >= 128 * 128 then
            return
        end

        local context = ArcRP_GetCustomContextMenu(ent, LocalPlayer())

        if context then
            local contextitem = context[contextindex]

            if contextitem then
                if contextitem.callback then
                    net.Start("arcrp_customuse")
                    net.WriteEntity(ent)
                    net.WriteUInt(contextindex, 8)
                    net.SendToServer()
                end

                if contextitem.interacttime then
                    startinteracttime = CurTime()
                    interacting_ent = ent
                    interacting_context = contextitem
                    interacting_index = contextindex
                else
                    if contextitem.cl_callback then
                        contextitem.cl_callback(ent, LocalPlayer())
                    end

                    interacting_ent = nil
                end

                lastusetime = CurTime()

                block = true
            end
        end
    elseif !pressed and bind == "+use" then
        if interacting_ent then
            cancelUse()
        end
    end

    return block
end)