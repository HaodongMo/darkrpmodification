local donotdrop = {
    "tacrp_medkit",
    "arcrp_hands"
}

local dodrop = {
    // "weapon_the_instrument"
}

local function CanDropWeapon(victim, wep)
    if wep:GetNWBool("TacRP_PoliceBiocode", false) then return false end -- do not drop police coded weapons
    if wep.AdminOnly then return false end
    if !wep.Spawnable then return false end
    if donotdrop[wep:GetClass()] then return false end
    if weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        return true
    end
    return false
end

local function TryDropWeapon(victim, wep)
    if !IsValid(wep) then return 0 end

    if CanDropWeapon(victim, wep) then
        victim:DropWeapon( wep )
        return 1
    end

    return 0
end

function ArcRP_DoDropWeapon( victim, inflictor, attacker )
    local disarmed = 0
    if ( victim:IsValid() ) then
        for _, wep in ipairs( victim:GetWeapons() ) do
            disarmed = disarmed + TryDropWeapon(victim, wep)
        end
    end

    return disarmed
end

hook.Add("PlayerDeath", "ArcRP_DropWeaponsOndeath", function(victim, inflictor, attacker)
    ArcRP_DoDropWeapon( victim, inflictor, attacker )
end)

hook.Add("canDropWeapon", "ArcRP_CanDropWeapon", function(ply, weapon)
    return CanDropWeapon(ply, weapon)
end)