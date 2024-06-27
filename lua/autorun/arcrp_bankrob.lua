ArcRP_BankRob = ArcRP_BankRob or {}

---------------------------------------------------------------------------------------------------
-- Timers
---------------------------------------------------------------------------------------------------

ArcRP_BankRob.MinPlayers = 1

-- Cooldown after a failed attempt (pallet was restored)
ArcRP_BankRob.CooldownAttempt = 120

-- Cooldown after a successful attempt (laundered)
ArcRP_BankRob.CooldownSuccess = 480

-- After this much time, the briefcase is automatically returned.
ArcRP_BankRob.Timeout = 360

-- Greed by staying near the pallet with the briefcase after robbery starts.
-- The reward listed below is for staying for the maximum amount of greed time.
-- Each additional player speeds up the timer up to 3.
ArcRP_BankRob.GreedTime = 90


---------------------------------------------------------------------------------------------------
-- Rewards and Penalties
---------------------------------------------------------------------------------------------------

-- If a bank robbery is successful, the whole server will get no salary for this much time.
ArcRP_BankRob.SalarySuppression = 480

-- Starting money independent of player count
ArcRP_BankRob.BaseAmount = 300

-- Starting money per player in the server
ArcRP_BankRob.BaseAmountPerPlayer = 75


-- Greed bonus independent of player count
ArcRP_BankRob.GreedAmountFlat = 1000

-- Greed bonus per player in the server
ArcRP_BankRob.GreedAmountPerPlayer = 200


---------------------------------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------------------------------

function ArcRP_BankRob.GetCooldown()
    return math.max(0, GetGlobalFloat("ArcRP_NextBankRob", 0) - CurTime())
end


function ArcRP_BankRob.GetBriefcase()
    return GetGlobalEntity("ArcRP_BankBriefcase")
end

function ArcRP_BankRob.IsRobberyActive()
    return IsValid(ArcRP_BankRob.GetBriefcase())
end

if SERVER then
    function ArcRP_BankRob.PutOnCooldown(t)
        SetGlobalFloat("ArcRP_NextBankRob", math.max(GetGlobalFloat("ArcRP_NextBankRob", 0), CurTime() + t))
    end

    function ArcRP_BankRob.WonRobbery()
        DarkRP.notifyAll(0, 10, "The bank was robbed! There won't be any salary payout for a while...")
        SetGlobalFloat("SalarySuppressionEndTime", CurTime() + ArcRP_BankRob.SalarySuppression)
        local briefcase = ArcRP_BankRob.GetBriefcase()
        if IsValid(briefcase) then
            briefcase:Remove()
        end
        ArcRP_BankRob.PutOnCooldown(ArcRP_BankRob.CooldownSuccess)
    end

    function ArcRP_BankRob.EndRobbery(timeout)
        local briefcase = ArcRP_BankRob.GetBriefcase()
        if IsValid(briefcase) then
            briefcase:Remove()
        end
        ArcRP_BankRob.PutOnCooldown(ArcRP_BankRob.CooldownAttempt)
        if timeout then
            DarkRP.notifyAll(0, 10, "The bank robbery took too long and failed. Your salaries are safe... for now.")
        else
            DarkRP.notifyAll(0, 10, "The bank robbery was stopped. Your salaries are safe... for now.")
        end
    end
elseif CLIENT then
    local cached_laundry = nil
    hook.Add("HUDPaintBackground", "ArcRP_BankRob", function()
        local briefcase = ArcRP_BankRob.GetBriefcase()
        if !IsValid(briefcase) then return end

        local briefcasedist = briefcase:GetPos():Distance(LocalPlayer():GetPos())
        if LocalPlayer():isCP() or briefcasedist <= 328 then
            if !cached_laundry then
                cached_laundry = {}
                for _, ent in pairs(ents.FindByClass("arcrp_moneylaundry")) do
                    table.insert(cached_laundry, ent:GetPos())
                end
            end

            local font = "TacRP_Myriad_Pro_24_Unscaled"

            local a = LocalPlayer():isCP() and 255 or Lerp((briefcasedist - 256) / (328 - 256), 255, 0)
            local clr_w = Color(255, 255, 255, a)
            local clr_b = Color(0, 0, 0, a)
            for _, pos in pairs(cached_laundry) do
                local data2D = pos:ToScreen()
                if data2D.visible then
                    draw.SimpleTextOutlined("Money Laundry",font, data2D.x, data2D.y, clr_w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, clr_b)
                    draw.SimpleTextOutlined(math.Round(pos:Distance(LocalPlayer():GetPos()) * TacRP.HUToM, 1) .. "m", font, data2D.x, data2D.y + 20, clr_w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, clr_b)
                end
            end

            if LocalPlayer():isCP() then
                local data2D = briefcase:GetPos():ToScreen()
                if data2D.visible then
                    draw.SimpleTextOutlined("Briefcase", font, data2D.x, data2D.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
                    draw.SimpleTextOutlined(math.Round(briefcasedist * TacRP.HUToM, 1) .. "m", font, data2D.x, data2D.y + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
                end
            end
        end
    end)
end