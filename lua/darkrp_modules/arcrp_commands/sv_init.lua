local function RevokeLicense(ply, arg)
    local canGive, cantGiveReason = hook.Call("canGiveLicense", DarkRP.hooks, ply, true)
    if canGive == false then
        cantGiveReason = isstring(cantGiveReason) and cantGiveReason or "You cannot give or revoke gun licenses."
        DarkRP.notify(ply, 1, 4, cantGiveReason)
        return ""
    end

    local target = DarkRP.findPlayer(arg)

    if not target then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(arg)))
        return
    end

    target:setDarkRPVar("HasGunlicense", false)

    DarkRP.notify(target, 0, 4, ply:Nick() .. " has revoked your gun license.")
    if ply ~= target then
        DarkRP.notify(ply, 0, 4, "You have revoked " .. target:Nick() .. "'s gun license.")
    end
end
DarkRP.defineChatCommand("revokelicense", RevokeLicense)

local function rp_GiveLicense(ply, arg)
    local canGive, cantGiveReason = hook.Call("canGiveLicense", DarkRP.hooks, ply, true)
    if canGive == false then
        cantGiveReason = isstring(cantGiveReason) and cantGiveReason or DarkRP.getPhrase("unable", "/givelicense", "")
        DarkRP.notify(ply, 1, 4, cantGiveReason)
        return ""
    end

    local target = DarkRP.findPlayer(arg)

    if not target then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(arg)))
        return
    end

    target:setDarkRPVar("HasGunlicense", true)

    DarkRP.notify(target, 0, 4, ply:Nick() .. " has given you a gun license.")
    if ply ~= target then
        DarkRP.notify(ply, 0, 4, "You have given " .. target:Nick() .. " a gun license.")
    end
end
DarkRP.defineChatCommand("givelicense", rp_GiveLicense)

local function policeban(ply, arg)
    local LookingAt = ply:GetEyeTrace().Entity
    if not IsValid(LookingAt) or not LookingAt:IsPlayer() or LookingAt:GetPos():DistToSqr(ply:GetPos()) > 10000 then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("must_be_looking_at", DarkRP.getPhrase("player")))
        return ""
    end

    local maxbantime = ply:getJobTable().ban_max_time or 0
    local bantime = tonumber(arg) or 0

    if maxbantime <= 0 then
        DarkRP.notify(ply, 1, 4, "You don't have the authority to ban.")
        return ""
    end

    DarkRP.notify(LookingAt, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), LookingAt:Nick()))
    DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), LookingAt:Nick()))
    LookingAt:setDarkRPVar("HasGunlicense", true)

    hook.Run("playerGotLicense", LookingAt, ply)

    return ""
end
// DarkRP.defineChatCommand("policeban", policeban)