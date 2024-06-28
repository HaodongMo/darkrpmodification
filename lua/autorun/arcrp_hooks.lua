

hook.Add("canVote", "tacrp_police_vote", function(ply, vote)
    if vote.votetype != "job" then return end

    local role = vote.info.targetTeam

    if allow_vote_roles then
        local ply_role = ply:Team()
        return GAMEMODE.AllowVoteRoles[role][ply_role] or false
    end
end)

local police_atts = {
    ["perk_shock"] = true,
    ["melee_boost_shock"] = true,
    ["ammo_40mm_gas"] = true,
    ["ammo_40mm_smoke"] = true,
    ["ammo_40mm_lvg"] = true,
}

hook.Add("TacRP_CanCustomize", "tacrp_rpcustomize", function(ply, wep, att, slot)
    local atttbl = TacRP.GetAttTable(att)

    if atttbl.IsBlocker then
        return false, "Permanently Damaged"
    end

    local cat = istable(atttbl.Category) and atttbl.Category[1] or atttbl.Category

    if (cat == "melee_spec" or cat == "melee_boost") then
        if !ply:getJobTable().martialArtist and !(att == "melee_boost_shock" and ply:isCP()) then
            return false, "Requires Martial Artist"
        end
    else
        local notreq = atttbl.Free
                or cat == "melee_tech"
                or (police_atts[att] and ply:isCP())
        if !notreq and !ply:getJobTable().gunsmith then
            return false, "Requires Gunsmith"
        end
    end

    return true
end)

hook.Add("playerArrested", "tacrp_arrest_bailbonds", function(ply, time, arrestor)
    if ply:GetNWBool("Bail", false) then
        ply:SetNWBool("Bail", false)
        timer.Simple(1, function()
            if !IsValid(ply) then return end
            DarkRP.notify(ply, 3, 10, "Your bail bonds have bought you out of jail!")
            ply:unArrest()
        end)
    end
end)

function ArcRP_GetMoneyDropAmount(victim)
    local cur = victim:getDarkRPVar("money") or 0

    // amount that will never be dropped
    local safe_min = 250
    // fraction of wallet above minimum to drop
    local frac = 0.2
    // maximum amount to drop
    local max = 1000

    local money = math.min(max, math.ceil(math.max(cur - safe_min) * frac))

    return money
end

// drop moolah on death
hook.Add("PlayerDeath", "tacrp_drop_money", function(victim, inflictor, attacker)
    if !IsValid(attacker) or attacker:isCP() then return end

    local money = ArcRP_GetMoneyDropAmount(victim)

    local max = 1000

    if victim:GetNWBool("Insurance", false) then
        victim:SetNWBool("Insurance", false)
        DarkRP.notify(victim, 3, 10, "Your insurance expired and prevented a medical bill of " .. DarkRP.formatMoney(money) .. ".")
    elseif money > 0 then
        victim:addMoney(-money)
        DarkRP.notify(victim, 3, 10, "You paid " .. DarkRP.formatMoney(money) .. " of medical bills on death." .. (money > 0.5 * max and " Maybe consider getting insurance next time..." or ""))
    end

    // Tax returns are void
    local tax_return = "TaxReturn_" .. victim:SteamID64()
    if timer.Exists(tax_return) then
        timer.Remove(tax_return)
        DarkRP.notify(victim, 1, 10, "Your tax return forms were voided due to your death!")
    end
end)

hook.Add("canGiveLicense", "tacrp_police_license", function(giver, target)
    return giver:getJobTable().giveLicense or false
end)

hook.Add("canWanted", "tacrp_police_wanted", function(ply, target)
    return ply:getJobTable().warrant
end)

hook.Add("canUnarrest", "tacrp_police_unarrest", function(unarrester, unarrestee)
    return unarrester:getJobTable().unarrest
end)

// arrest on kill by police
hook.Add("PostPlayerDeath", "tacrp_police_arrest", function(victim)
    if victim:isWanted() and !victim:isArrested() then
        victim:arrest(GAMEMODE.Config.jailtimer, attacker)
    end

    // Lose job on death and enter 5 min cooldown
    local t = victim:Team()
    if t != GAMEMODE.DefaultTeam then
        // Police cannot immediately switch back to rookie
        if GAMEMODE.CivilProtection[t] and t != TEAM_POLICE_ROOKIE then
            victim:teamBan(TEAM_POLICE_ROOKIE, 120)
        end
        victim:teamBan(t, 300)
        victim:changeTeam(GAMEMODE.DefaultTeam, true)
    end
end)

if SERVER then
    // Switching to a new job voluntarily will teamban for a little while, unless jobs are CP
    hook.Add("OnPlayerChangedTeam", "arcrp_jobswitchban", function(ply, old, new)
        if ply:Alive() and old != GAMEMODE.DefaultTeam and
                !(GAMEMODE.CivilProtection[old] and GAMEMODE.CivilProtection[new]) then
            ply:teamBan(old, 120)
            // Switching off CP will also jobban rookie
            if GAMEMODE.CivilProtection[old] and old != TEAM_POLICE_ROOKIE then
                ply:teamBan(TEAM_POLICE_ROOKIE, 120)
            end
        end
    end)
end


hook.Add("playerGetSalary", "arcrp_salary_bankrobbery", function(ply, amount)
    if GetGlobalFloat("SalarySuppressionEndTime", 0) > CurTime() then
        return false, "The bank was recently robbed - no salary could be paid out.", 0
    end
end)

local ramkill = {
    ["sammyservers_textscreen"] = true,
    ["darkrp_billboard"] = true,
}

hook.Add("canDoorRam", "arcrp_doorram", function(ply, tr, ent)
    if ramkill[ent:GetClass()] and !ent.USED then
        ent.USED = true
        if CLIENT then return end
        ent:SetNotSolid( true )
        ent:SetMoveType( MOVETYPE_NONE )
        ent:SetNoDraw( true )
        local ed = EffectData()
        ed:SetEntity( ent )
        util.Effect( "entity_remove", ed, true, true )
        SafeRemoveEntityDelayed(ent, 1)
        return true
    end
end)

hook.Add("canPocket", "arcrp_unpocketable", function(ply, item)
    if !IsValid(item) then return false end

    if item.unPocketAble then return false end

    return true
end)

hook.Add("EntityTakeDamage", "arcrp_destroyspawnedweapon", function(ent, dmg)
    if !IsValid(ent) then return end
    if !ent.IsSpawnedWeapon then return end

    local damage = dmg:GetDamage()

    if dmg:GetDamageType() == DMG_BLAST then
        damage = damage * 2.5
    elseif dmg:GetDamageType() == DMG_SONIC then
        damage = damage * 0.1
    end

    local chance = math.min(damage, 30) / 30

    if math.Rand(0, 1) <= chance then
        local ok = ArcRP_AddBrokenAttachment(ent)

        if !ok then
            local effectdata = EffectData()
            effectdata:SetStart(ent:GetPos())
            effectdata:SetOrigin(ent:GetPos())
            effectdata:SetScale(1)
            util.Effect("HelicopterMegaBomb", effectdata)

            SafeRemoveEntity(ent)
        end
    end
end)