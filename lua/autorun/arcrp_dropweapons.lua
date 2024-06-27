local donotdrop = {
    "tacrp_medkit",
    "arcrp_hands"
}

local dodrop = {
    // "weapon_the_instrument"
}

local function TryDropWeapon(victim, wep)
    if !IsValid(wep) then return 0 end
    if wep:GetNWBool("TacRP_PoliceBiocode", false) then return 0 end -- do not drop police coded weapons
    if wep.AdminOnly then return 0 end
    if !wep.Spawnable then return 0 end
    if donotdrop[wep:GetClass()] then return 0 end
    if weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        victim:DropWeapon( wep )
        print("Dropping", wep)
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

hook.Add("PlayerDeath", "ArcRP_DropWeaponsOndeath", ArcRP_DoDropWeapon)