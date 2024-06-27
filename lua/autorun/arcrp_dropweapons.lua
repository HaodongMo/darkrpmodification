local donotdrop = {
    "tacrp_medkit",
    "arcrp_hands"
}

local dodrop = {
    // "weapon_the_instrument"
}

function ArcRP_DoDropWeapon( victim, inflictor, attacker )
    local disarmed = 0
    if ( victim:IsValid() ) then
        -- Loop through all player weapons and drop them.
        for _, wep in ipairs( victim:GetWeapons() ) do
            if wep:GetNWBool("TacRP_PoliceBiocode", false) then continue end -- do not drop police coded weapons
            if !donotdrop[wep:GetClass()] and weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
                victim:DropWeapon( wep )
                disarmed = disarmed + 1
            end
        end
    end

    return disarmed
end

hook.Add("PlayerDeath", "ArcRP_DropWeaponsOndeath", ArcRP_DoDropWeapon)