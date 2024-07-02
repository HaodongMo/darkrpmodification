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

    hitman:addMoney(hitman.ArcRP_HitPrice or ArcRP_GetHitCost(target))

    if TabPhone then
        TabPhone.SendNPCMessage(hitman, "assassins", "Well done, valued Delivery Agent. " .. target:GetName() .. " is now enjoying their pizza. Your payment has already been sent.")
        TabPhone.SendNPCMessage(customer, "assassins", target:GetName() .. " has confirmed their pizza Delivery. The payment has been wired to your Delivery Agent.")
    end
end)

hook.Add("onHitFailed", "ArcRP_HitMan", function(hitman, target, reason)
    if CLIENT then return end

    if IsValid(hitman.ArcRP_HitCustomer) then
        hitman.ArcRP_HitCustomer:addMoney(hitman.ArcRP_HitPrice or ArcRP_GetHitCost(target))
        TabPhone.SendNPCMessage(hitman.ArcRP_HitCustomer, "assassins", "Unfortunately, " .. target:GetName() .. "'s pizza was lost in transit. We have refunded your order and humbly seek your forgiveness for the failure of our Delivery Agent.")
    end

    if TabPhone then
        TabPhone.SendNPCMessage(hitman, "assassins", "The pizza has gone cold; cease attempting to deliver to " .. target:GetName() .. ".")
    end
end)

if SERVER then
    util.AddNetworkString("arcrp_placehit")
end