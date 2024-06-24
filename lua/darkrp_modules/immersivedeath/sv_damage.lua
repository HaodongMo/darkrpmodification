-- #NoSimplerr#

hook.Add("EntityTakeDamage", "IMDE_Damage", function(ent, dmginfo)
    if not GetConVar("imde_enabled"):GetBool() then return end

    if ent:GetNWBool("IMDE_IsRagdoll") then
        local p, d = dmginfo:GetDamagePosition(), dmginfo:GetDamageForce():GetNormalized()
        local fx = EffectData()
        fx:SetOrigin(p)
        util.Effect("BloodImpact", fx)

        util.Decal("Blood", p + d * 4, p - d * 32, ent)
        util.Decal("Blood", p, p + d * 64, ent)

        if dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_NERVEGAS) then
            return
        end

        if IsValid(ent:GetOwner()) and ent:GetOwner():IMDE_IsHidden() then
            dmginfo:SetDamageCustom(1024)
            ent:GetOwner():TakeDamageInfo(dmginfo)
            return
        end

    end

    if not ent:IsPlayer() then return end


    if ent:IMDE_IsHidden() and bit.band(dmginfo:GetDamageCustom(), 1024) ~= 1024 and dmginfo:GetDamageType() ~= DMG_DIRECT
            and not (dmginfo:GetInflictor():IsNPC() and dmginfo:GetDamageType() == DMG_SLASH) then
        return true
    end

    local down = ent:IMDE_IsHidden()

    local stam_mult, health_mult, bal_mult = 1, 1, 0
    for k, v in pairs(IMDE.StaminaDamageMultipliers) do
        if dmginfo:IsDamageType(k) then
            if dmginfo:GetAttacker():IsNPC() and IMDE.StaminaDamageMultipliers_NPC[k] then
                v = IMDE.StaminaDamageMultipliers_NPC[k]
            end
            stam_mult = stam_mult * v[1]
            health_mult = health_mult * v[2]
            if not down and v[3] then
                bal_mult = math.max(v[3], bal_mult)
            end
        end
    end

    if down and dmginfo:GetInflictor():IsNPC() then
        stam_mult = 0
        ent:IMDE_SetStamina(math.min(ent:IMDE_GetStamina() + dmginfo:GetDamage() * 0.5, ent:IMDE_GetMaxStamina()))
    end

    local prev_stamina_damage = ent.IMDE_LastStaminaDamage
    if stam_mult > 0 then
        ent:IMDE_SetStamina(math.max(ent:IMDE_GetStamina() - dmginfo:GetDamage() * stam_mult, dmginfo:IsDamageType(DMG_NERVEGAS) and 5 or 0))
        ent.IMDE_LastStaminaDamage = CurTime()
    end

    if bal_mult > 0 then
        ent:IMDE_SetBalance(math.max(ent:IMDE_GetBalance() - dmginfo:GetDamage() * bal_mult, dmginfo:IsDamageType(DMG_NERVEGAS) and 5 or 0))
    end

    local f, p = dmginfo:GetDamageForce(), dmginfo:GetDamagePosition()

    dmginfo:ScaleDamage(health_mult)

    if health_mult == 0 then
        if not down and (ent:IMDE_GetStamina() <= 0 or ent:IMDE_GetBalance() <= 0) and ent:Health() > 0 then
            ent:IMDE_MakeUnconscious(f, p)
        end
        return true -- this will cause PostEntityTakeDamage to not be called
    elseif (not down or prev_stamina_damage == CurTime()) and dmginfo:GetDamage() > ent:Health() then
        -- May survive a lethal hit depending on config
        local option = GetConVar("imde_oneshot_protection"):GetInt()
        if (option == 3 or dmginfo:GetDamage() < ent:GetMaxHealth()) and (
                (option == 1 and math.random() < math.Clamp(1 - (dmginfo:GetDamage() - ent:Health()) / ent:GetMaxHealth() * 2, 0, 1))
                or (option == 2 and ent:LastHitGroup() ~= HITGROUP_HEAD)
                or option == 3) then
            ent:IMDE_SetStamina(0)
            dmginfo:SetDamage(ent:Health() - 1)
        end
    end
end)

hook.Add("PostEntityTakeDamage", "IMDE_Damage", function(ent, dmg, took)
    if not GetConVar("imde_enabled"):GetBool() then return end
    if not ent:IsPlayer() then return end
    -- uh oh!
    if not ent:IMDE_IsHidden() and (ent:IMDE_GetStamina() <= 0 or ent:IMDE_GetBalance() <= 0) and ent:Health() > 0 then
        ent:IMDE_MakeUnconscious()
    end
end)

hook.Add("PlayerSpawn", "IMDE_Damage", function(ply)
    ply:IMDE_SetStamina(ply:IMDE_GetMaxStamina())
end)

local nextTick = 0
local tickdelay = 0.1
hook.Add("Think", "IMDE_Stamina", function()
    if not GetConVar("imde_enabled"):GetBool() then return end
    local tick = nextTick < CurTime()
    for _, ply in pairs(player.GetAll()) do
        local down = ply:IMDE_IsHidden()
        ply.IMDE_LastStaminaDamage = ply.IMDE_LastStaminaDamage or 0

        if tick and ply:Alive() then
            -- natural regen
            if ply.IMDE_LastStaminaDamage + (down and 1 or 5) < CurTime() then
                local add = GetConVar("imde_recover"):GetFloat()
                if down then
                    add = GetConVar("imde_recover_down"):GetFloat() * math.Clamp((CurTime() - ply:GetNWFloat("IMDE_LastRagdollTime", CurTime())) / 10 + 1, 1, 10)
                elseif not ply:IsOnGround() then
                    add = 0
                elseif ply:GetVelocity():Length() > 0 and ply:KeyDown(IN_SPEED) then
                    add = add * 0.5
                end
                add = add * math.Clamp(ply:Health() / ply:GetMaxHealth() + 0.25, 0.25, 1) * (tickdelay / 0.5)

                ply:IMDE_SetStamina(math.min(ply:IMDE_GetMaxStamina(), ply:IMDE_GetStamina() + add))
            end

            if not down then
                local tgt = ply:IMDE_GetBalanceLevel() * ply:IMDE_GetMaxBalance()
                local cur = ply:IMDE_GetBalance()
                local rate = 0
                if tgt < cur then
                    rate = 1
                elseif ply.IMDE_LastStaminaDamage + 1 < CurTime() then
                    rate = Lerp(((CurTime() - (ply.IMDE_LastStaminaDamage + 1)) / 5) ^ 1, 0, GetConVar("imde_recover_balance"):GetFloat())
                end

                if rate > 0 then
                    ply:IMDE_SetBalance(math.Approach(cur, tgt, ply:IMDE_GetMaxBalance() * rate * (tickdelay / 0.5)))
                end
            end

            -- suit charge
            if GetConVar("imde_charge"):GetBool() and ply:IMDE_GetStamina() < ply:IMDE_GetMaxStamina() and
                    ((ply:IsOnGround() and ply:KeyDown(IN_WALK) and ply:Crouching()) or (down and GetConVar("imde_charge_downed"):GetBool())) and
                    ply:Armor() > 0 then
                local mult = downed and GetConVar("imde_charge_mult_downed"):GetFloat() or GetConVar("imde_charge_mult"):GetFloat()
                local spend = downed and GetConVar("imde_charge_spend_downed"):GetFloat() or GetConVar("imde_charge_spend"):GetFloat()
                local cost = math.min(ply:Armor(), spend, (ply:IMDE_GetMaxStamina() - ply:IMDE_GetStamina()) / mult)
                ply:SetArmor(ply:Armor() - cost)
                ply:IMDE_SetStamina(math.min(ply:IMDE_GetMaxStamina(), ply:IMDE_GetStamina() + cost * mult))
            end

            if ply:IsBot() and down and ply:IMDE_GetStamina() >= ply:IMDE_GetWakeupThreshold() and ply:GetNWFloat("IMDE_LastRagdollTime") + GetConVar("imde_wake_mintime"):GetFloat() < CurTime() then
                ply:IMDE_MakeConscious()
                ply:IMDE_SetBalance(1)
            end
        end

        if IsValid(ply:IMDE_GetRagdoll()) and ply:IMDE_IsHidden() then
            local phys = ply:IMDE_GetRagdoll():GetPhysicsObjectNum(0)
            if not IsValid(phys) then continue end
            phys:AddAngleVelocity(Vector(0, 0, math.sin(CurTime()) * math.Rand(12000, 16000) * FrameTime()))
        end
    end

    if tick then nextTick = CurTime() + tickdelay end
end)