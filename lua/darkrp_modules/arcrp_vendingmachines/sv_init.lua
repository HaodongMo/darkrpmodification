util.AddNetworkString("arcrp_openvendingmachine")
util.AddNetworkString("arcrp_buyweapon")
util.AddNetworkString("arcrp_buyammo")

net.Receive("arcrp_buyammo", function(len, ply)
    local ammo = net.ReadUInt(8)

    local class = GAMEMODE.Config.vendingMachineAmmo[ammo]
    local cost = class.cost

    if cost != nil and ply:getDarkRPVar("money") >= cost then
        local insphere = ents.FindInSphere(ply:GetPos(), 256)
        local has_vending_machine = false

        for i, ent in ipairs(insphere) do
            if ent.isVendingMachine then
                has_vending_machine = true
                break
            end
        end

        if has_vending_machine then
            local reserve = ply:GetAmmoCount(class.ammo)

            if reserve >= class.max then
                DarkRP.notify(ply, 1, 4, "You have the max amount of this ammo type!")
            else
                reserve = math.min(reserve + class.amount, class.max)
                ply:addMoney(-cost)
                ply:SetAmmo(reserve, class.ammo)

                DarkRP.notify(ply, 0, 2, "You bought " .. class.name .. " for " .. DarkRP.formatMoney(cost) .. ".")
            end
        end
    else
        DarkRP.notify(ply, 1, 4, "You cannot afford this!")
    end
end)

net.Receive("arcrp_buyweapon", function(len, ply)
    local weapon = net.ReadString()

    local cost = GAMEMODE.Config.vendingMachineGuns[weapon]

    if cost != nil and ply:getDarkRPVar("money") >= cost then
        if GAMEMODE.Config.vendingMachineNoLicense or !GAMEMODE.Config.vendingMachineRequireLicense[weapon] or ply:getDarkRPVar("HasGunlicense") then
            local insphere = ents.FindInSphere(ply:GetPos(), 256)
            local has_vending_machine = false

            for i, ent in ipairs(insphere) do
                if ent.isVendingMachine then
                    has_vending_machine = true
                    break
                end
            end

            if has_vending_machine then
                if !ply:HasWeapon(weapon) then
                    local newwpn = ents.Create(weapon)

                    if IsValid(newwpn) then
                        ply:addMoney(-cost)
                        local weaponclass = weapons.Get(weapon)
                        newwpn:SetPos(ply:GetPos())
                        newwpn:Spawn()
                        local canPickup = hook.Run("PlayerCanPickupWeapon", ply, newwpn)
                        if canPickup != false then
                            ply:PickupWeapon(newwpn)
                        end
                        DarkRP.notify(ply, 0, 2, "You bought " .. weaponclass.PrintName .. " for " .. DarkRP.formatMoney(cost) .. ".")
                    else
                        DarkRP.notify(ply, 1, 4, "Unable to buy weapon!")
                    end
                else
                    DarkRP.notify(ply, 1, 4, "You are already carrying this weapon!")
                end
            else
                DarkRP.notify(ply, 1, 4, "You need to be at a vending machine.")
            end
        else
            DarkRP.notify(ply, 1, 4, "You are not licensed to buy this!")
        end
    else
        DarkRP.notify(ply, 1, 4, "You cannot afford this!")
    end
end)