local donotdrop = {
}

local function DoDropWeapon( victim, inflictor, attacker )
    if ( victim:IsValid() ) then
        -- Loop through all player weapons and drop them.
        for _, wep in ipairs( victim:GetWeapons() ) do
            if !donotdrop[wep:GetClass()] and weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
                victim:DropWeapon( wep )
            end
        end
    end
end

hook.Add("PlayerDeath", "ArcRP_DropWeaponsOndeath", DoDropWeapon)