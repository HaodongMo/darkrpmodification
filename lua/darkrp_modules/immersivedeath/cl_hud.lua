local stam_last, stam, stam_max, stam_time, die_time, bal_last, bal, bal_max, bal_time
local lerpspeed = 0.4
local lerpspeed2 = 0.2

local mat = Material("tacrp/hud/vignette.png", "smooth") -- immersive_death/vignette.png

surface.CreateFont( "IMDE_8", {
    font = "Myriad Pro",
    size = ScreenScale(8),
    weight = 0,
    antialias = true,
    extended = true,
})

surface.CreateFont( "IMDE_14", {
    font = "Myriad Pro",
    size = ScreenScale(14),
    weight = 0,
    antialias = true,
    extended = true,
})
surface.CreateFont( "IMDE_20", {
    font = "Myriad Pro",
    size = ScreenScale(20),
    weight = 0,
    antialias = true,
    extended = true,
})
surface.CreateFont( "IMDE_24", {
    font = "Myriad Pro",
    size = ScreenScale(24),
    weight = 0,
    antialias = true,
    extended = true,
})

hook.Add("HUDPaint", "IMDE_Hud", function()
    if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE then return end

    local ptr = LocalPlayer():GetEyeTrace()

    if not LocalPlayer():IMDE_IsHidden() and IsValid(ptr.Entity) and ptr.Entity:GetNWBool("IMDE_IsRagdoll", false) and IsValid(ptr.Entity:GetOwner()) and ptr.Entity:GetPos():DistToSqr(LocalPlayer():EyePos()) <= 128 * 128 then
        draw.SimpleTextOutlined(ptr.Entity:GetOwner():GetName(), "IMDE_8", ScrW() * 0.5, ScrH() / 2 + ScreenScale(8), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0))
    end

    if LocalPlayer():IsAdmin() and GetConVar("imde_hud_debug"):GetBool() and IsValid(ptr.Entity) then
        local ply = ptr.Entity:GetNWBool("IMDE_IsRagdoll", false) and ptr.Entity:GetOwner() or ptr.Entity
        if ply:IsPlayer() then
            draw.SimpleText(math.Round(ply:Health()), "DermaDefaultBold", ScrW() * 0.5, ScrH() / 2 + 96 - 14, Color(255, 120, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(math.Round(ply:IMDE_GetStamina(), 1), "DermaDefaultBold", ScrW() * 0.5, ScrH() / 2 + 96, Color(120, 200, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(math.Round(ply:IMDE_GetBalance(), 1), "DermaDefaultBold", ScrW() * 0.5, ScrH() / 2 + 96 + 14, Color(200, 180, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)    
        end
    end

    if not GetConVar("cl_drawhud"):GetBool() or not GetConVar("imde_enabled"):GetBool() then
        stam_time = nil
        return
    end
    local activew = LocalPlayer():GetActiveWeapon()
    if IsValid(activew) and activew:GetClass() == "gmod_camera" then return end

    local ply = LocalPlayer()
    if IsValid(LocalPlayer():GetObserverTarget()) and LocalPlayer():GetObserverTarget():IsPlayer() then
        ply = LocalPlayer():GetObserverTarget()
    end

    if not ply.IMDE_IsHidden then return end

    if not ply:Alive() then
        die_time = die_time or CurTime()
        --[[]
        local mult_die = math.Clamp((CurTime() - die_time) / 5, 0, 1)
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255, 100 + 155 * mult_die ^ 0.25)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        surface.SetDrawColor(0, 0, 0, 100 + 150 * mult_die ^ 0.25)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        ]]
        return
    else
        die_time = nil
    end


    if not stam_time then
        stam_time = SysTime()
        stam = ply:IMDE_GetStamina()
        stam_max = ply:IMDE_GetMaxStamina()
        stam_last = ply:IMDE_GetStamina()
    end
    if not bal_time then
        bal_time = SysTime()
        bal = ply:IMDE_GetBalance()
        bal_max = ply:IMDE_GetMaxBalance()
        bal_last = ply:IMDE_GetBalance()
    end

    local stam_cur = Lerp((SysTime() - stam_time) / lerpspeed, stam_last, stam)
    local mult = stam_cur / stam_max
    local mult2 = ply:IMDE_IsHidden() and math.Clamp((stam_cur - stam_max * 0.3) / (stam_max * (1 - 0.3)) * 0.8, 0, 0.8) or mult
    if stam_last ~= ply:IMDE_GetStamina() or stam_max ~= ply:IMDE_GetMaxStamina() then
        stam_time = SysTime()
        stam = ply:IMDE_GetStamina()
        stam_max = ply:IMDE_GetMaxStamina()
        stam_last = stam_cur
    end

    local bal_cur = Lerp((SysTime() - bal_time) / lerpspeed2, bal_last, bal)
    local mult3 = bal_cur / bal_max
    if bal_last ~= ply:IMDE_GetStamina() or bal_max ~= ply:IMDE_GetMaxBalance() then
        bal_time = SysTime()
        bal = ply:IMDE_GetBalance()
        bal_max = ply:IMDE_GetMaxBalance()
        bal_last = bal_cur
    end

    surface.SetMaterial(mat)
    surface.SetDrawColor(255, 255, 255, 255 * (1 - mult2) ^ 0.5)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    surface.SetDrawColor(0, 0, 0, 245 *  (1 - mult2) ^ (ply:IMDE_IsHidden() and 0.5 or 2))
    surface.DrawRect(0, 0, ScrW(), ScrH())

    if ply:IMDE_IsHidden() then
        local x, y = ScrW() * 0.5, ScrH() - ScreenScale(44)
        local w, h = ScreenScale(128), ScreenScale(8)

        draw.SimpleText("Unconscious", "IMDE_20", ScrW() * 0.5, ScrH() * 0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local hint2
        if ply:IMDE_GetStamina() < ply:IMDE_GetWakeupThreshold() then
            hint2 = "You may wake up when stamina recovers"
        elseif ply:GetNWFloat("IMDE_LastRagdollTime") + GetConVar("imde_wake_mintime"):GetFloat() >= CurTime() then
            hint2 = "You must wait " .. math.ceil(ply:GetNWFloat("IMDE_LastRagdollTime") + GetConVar("imde_wake_mintime"):GetFloat() - CurTime()) .. "s to get up"
        else
            hint2 = "Press " .. input.LookupBinding("+attack") .. " to get up"
        end
        draw.SimpleText(hint2, "IMDE_14", ScrW() * 0.5, ScrH() - ScreenScale(8), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        surface.SetDrawColor(50, 50, 50, 200)
        surface.DrawRect(x - w * 0.5, y, w, h)
        surface.SetDrawColor(120, 200, 150)
        surface.DrawRect(x + 2 - w * 0.5, y + 2, (w - 4) * mult, h - 4)
    elseif GetConVar("imde_hud"):GetBool() then

        local x, y = ScreenScale(12), ScrH() - ScreenScale(44)
        local w = ScreenScale(64)

        surface.SetDrawColor(50, 50, 50, 200)
        surface.DrawRect(x, y, w, 16)
        surface.SetDrawColor(120, 200, 150)
        surface.DrawRect(x + 2, y + 2, (w - 4) * mult, 16 - 4)

        y = y - ScreenScale(6)

        surface.SetDrawColor(50, 50, 50, 200)
        surface.DrawRect(x, y, w, 16)
        surface.SetDrawColor(200, 180, 120)
        surface.DrawRect(x + 2, y + 2, (w - 4) * mult3, 16 - 4)
    end
end)

hook.Add( "RenderScreenspaceEffects", "IMDE_Hud", function()

    local ply = LocalPlayer()
    if IsValid(LocalPlayer():GetObserverTarget()) and LocalPlayer():GetObserverTarget():IsPlayer() then
        ply = LocalPlayer():GetObserverTarget()
    end

    if not stam_time then
        stam_time = SysTime()
        stam = ply:IMDE_GetStamina()
        stam_max = ply:IMDE_GetMaxStamina()
        stam_last = ply:IMDE_GetStamina()
    end

    if ply.IMDE_IsHidden and ply:IMDE_IsHidden() then
        local stam_cur = Lerp((SysTime() - stam_time) / lerpspeed, stam_last, stam)
        local mult = math.Clamp((stam_cur - stam_max * 0.3) / (stam_max * (1 - 0.3)) * 0.6, 0, 0.6)
        --DrawBokehDOF(mult * 5, 0, 1)
        DrawMotionBlur( 0.1 + mult, 0.9, 0.02 )
    end
end )


hook.Add("CreateMove", "IMDE_Stamina", function(cmd)
    if not LocalPlayer().IMDE_IsHidden then return end

    if cmd:KeyDown(IN_ATTACK) and LocalPlayer():IMDE_IsHidden() and LocalPlayer():IMDE_GetStamina() >= LocalPlayer():IMDE_GetWakeupThreshold() and LocalPlayer():GetNWFloat("IMDE_LastRagdollTime") + GetConVar("imde_wake_mintime"):GetFloat() < CurTime() then
        net.Start("imde_wake")
        net.SendToServer()
    end
end)

hook.Add("HUDShouldDraw", "IMDE_Stamina", function(str)
    if not LocalPlayer().IMDE_IsHidden then return end

    if LocalPlayer():IMDE_IsHidden() and str ~= "CHudGMod" then return false end
end)