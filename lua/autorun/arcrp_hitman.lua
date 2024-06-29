function ArcRP_FindFreeHitman(victim)
    local available = {}

    for _, ply in ipairs(player.GetAll()) do
        if !ply:GetNWBool("arcrp_hitman") then continue end
        if ply:hasHit() then continue end
        if ply == victim then continue end

        table.insert(available, ply)
    end

    return table.Random(available)
end

function ArcRP_GetHitCost(ply)
    local cost = 10 * math.max(ply:getJobTable().salary, 25)
    if ply:isMayor() then
        cost = cost * 2
    end

    return cost
end

hook.Add("onHitCompleted", "ArcRP_HitMan", function(hitman, target, customer)
    if CLIENT then return end

    print(hitman)

    hitman:addMoney(hitman.ArcRP_HitPrice or ArcRP_GetHitCost(target))
end)

hook.Add("onHitFailed", "ArcRP_HitMan", function(hitman, target, reason)
    if CLIENT then return end

    if IsValid(hitman.ArcRP_HitCustomer) then
        hitman.ArcRP_HitCustomer:addMoney(hitman.ArcRP_HitPrice or ArcRP_GetHitCost(target))
    end
end)

if SERVER then
    util.AddNetworkString("arcrp_placehit")
end