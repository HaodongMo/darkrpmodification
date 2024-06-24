local PLAYER = FindMetaTable("Player")

function PLAYER:IMDE_GetMaxStamina()
    return 100
end

function PLAYER:IMDE_GetStamina()
    return self:GetNWFloat("IMDE_Stamina")
end

function PLAYER:IMDE_SetStamina(val)
    self:SetNWFloat("IMDE_Stamina", val)
end

function PLAYER:IMDE_GetMaxBalance()
    return 100
end

function PLAYER:IMDE_GetBalanceLevel()
    if not self:OnGround() then
        if self:WaterLevel() > 0 then
            local v = self:WaterLevel() == 3 and 0.8 or 0.6
            v = v - Lerp(self:GetVelocity():Length() / self:GetWalkSpeed(), 0, 0.1)
            v = v - Lerp((self:GetVelocity():Length() - self:GetWalkSpeed()) / (self:GetRunSpeed() - self:GetWalkSpeed()), 0, 0.2)
            return v
        else
            return 0.05
        end
    else
        local v = self:Crouching() and 1 or 0.8
        v = v - Lerp(self:GetVelocity():Length() / self:GetWalkSpeed(), 0, 0.25)
        v = v - Lerp((self:GetVelocity():Length() - self:GetWalkSpeed()) / (self:GetRunSpeed() - self:GetWalkSpeed()), 0, 0.25)
        return v
    end
end

function PLAYER:IMDE_GetBalance()
    return self:GetNWFloat("IMDE_Balance")
end

function PLAYER:IMDE_SetBalance(val)
    self:SetNWFloat("IMDE_Balance", val)
end

function PLAYER:IMDE_IsHidden()
    return self:GetNWBool("IMDE_Hidden", false)
end

function PLAYER:IMDE_GetRagdoll()
    return self:GetNWEntity("IMDE_LastRagdoll")
end

function PLAYER:IMDE_GetWakeupThreshold()
    return self:IMDE_GetMaxStamina() * GetConVar("imde_wake_threshold"):GetFloat() * (GetConVar("imde_wake_healthaffects"):GetBool() and (1 - math.Clamp(self:Health() / self:GetMaxHealth(), 0, 0.8)) or 1)
end

hook.Add("PlayerSwitchWeapon", "IMDE_Ragdoll", function(ply, old, new)
    if ply:IMDE_IsHidden() then
        if SERVER then timer.Simple(0, function() ply:DrawWorldModel(false) end) end
        return true
    end
end)