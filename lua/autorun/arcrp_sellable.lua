ArcRP_Sellable = {
    ["spawned_weapon"] = true,
    ["spawned_shipment"] = true,
}

if SERVER then
    util.AddNetworkString("arcrp_makesellable")

    net.Receive("arcrp_makesellable", function(len, ply)
        local ent = net.ReadEntity()
        local cost = net.ReadUInt(32)

        if !IsValid(ent) then return end
        if ent:GetPos():DistToSqr(ply:GetPos()) > 128 * 128 then return end
        if !ent.CanBeSold and !ArcRP_Sellable[ent:GetClass()] then return end
        if ent.Getowning_ent and ent:Getowning_ent() != ply then return end

        ent.ArcRP_IsSellable = true
        ent.ArcRP_SalesCost = cost
        ent.ArcRP_SellOwner = ply
        ent.ArcRP_OwnerSteamID = ply:SteamID64()

        ent:SetNWInt("arcrp_salescost", cost)
        ent:SetNWEntity("arcrp_sellowner", ply)

        DarkRP.notify(ply, "Item is now buyable by other players!")
    end)

    hook.Add("PlayerUse", "ArcRP_Sellable", function(ply, ent)
        if ent.ArcRP_IsSellable then return false end
    end)

    hook.Add("PlayerCanPickupItem", "ArcRP_Sellable", function(ply, ent)
        if ent.ArcRP_IsSellable then return false end
    end)
end