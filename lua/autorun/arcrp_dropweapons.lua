local donotdrop = {
    "tacrp_medkit",
    "arcrp_hands"
}

local dodrop = {
    // "weapon_the_instrument"
}

local function CanDropWeapon(victim, wep)
    if !IsValid(wep) then return false end
    if wep:GetNWBool("TacRP_PoliceBiocode", false) then return false end -- do not drop police coded weapons
    if wep.AdminOnly then return false end
    if !wep.Spawnable then return false end
    if donotdrop[wep:GetClass()] then return false end
    if dodrop[wep:GetClass()] then return true end
    if weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        if !victim:Alive() then
            ArcRP_AddBrokenAttachment(wep)
        end

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

function ArcRP_AddBrokenAttachment(weapon)
    if weapon:IsWeapon() then
        if !weapon.ArcticTacRP then return end
        if weapon:GetValue("PrimaryMelee") then return false end

        local unbroken_slots = {}

        for i, slot in ipairs(weapon.Attachments) do
            local atttbl = TacRP.GetAttTable(slot.Installed) or {}
            if !atttbl.IsBlocker then
                table.insert(unbroken_slots, i)
            end
        end

        if #unbroken_slots <= 0 then
            return false
        else
            local insert_slot = table.Random(unbroken_slots)

            local cats = weapon.Attachments[insert_slot].Category
            if !istable(cats) then
                cats = {cats}
            end

            if table.HasValue(cats, "optic_irons") or table.HasValue(cats, "optic_irons_sniper") then
                weapon.Attachments[insert_slot].Installed = "irons_blocker"
            else
                weapon.Attachments[insert_slot].Installed = "blocker"
            end

            return true
        end
    elseif weapon.IsSpawnedWeapon then
        local unbroken_slots = {}

        local weptbl = weapons.Get(weapon:GetWeaponClass())
        if weptbl.PrimaryMelee then return false end

        weapon.Attachments = weapon.Attachments or {}

        for i, slot in ipairs(weptbl.Attachments) do
            local atttbl = TacRP.GetAttTable(weapon.Attachments[i]) or {}
            if !atttbl.IsBlocker then
                table.insert(unbroken_slots, i)
            end
        end

        if #unbroken_slots <= 0 then
            return false
        else
            local insert_slot = table.Random(unbroken_slots)

            local cats = weptbl.Attachments[insert_slot].Category
            if !istable(cats) then
                cats = {cats}
            end

            if table.HasValue(cats, "ironsights") or table.HasValue(cats, "ironsights_sniper") then
                weapon.Attachments[insert_slot] = TacRP.GetAttTable("irons_blocker").ID
            else
                weapon.Attachments[insert_slot] = TacRP.GetAttTable("blocker").ID
            end

            net.Start("tacrp_spawnedwepatts")
                net.WriteUInt(weapon:EntIndex(), 12) -- ent won't exist on client when message arrives
                net.WriteUInt(table.Count(weapon.Attachments), 4)
                for k, v in pairs(weapon.Attachments) do
                    net.WriteUInt(k, 4)
                    net.WriteUInt(v, TacRP.Attachments_Bits)
                end
            net.Broadcast()

            return true
        end
    end
end

function ArcRP_DoDropWeapon( victim, inflictor, attacker )
    local disarmed = 0
    if ( victim:IsValid() ) then
        for _, wep in ipairs( victim:GetWeapons() ) do
            local success = TryDropWeapon(victim, wep)
            disarmed = disarmed + success
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

hook.Add("onDarkRPWeaponDropped", "ArcRP_DamageWeapons", function(ply, ent, weapon)
    
end)