AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/TrashDumpster01a.mdl")
    self:SetMaterial("binaknife")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    self:SetNextScavengeTime(0)
end

function ENT:canUse(owner, activator)
    return true
end

ENT.ScavengeLoot_Guns = {
    "tacrp_ex_m1911",
    "tacrp_ex_glock",
    "tacrp_ex_vertec",
    "tacrp_ex_m1911",
    "tacrp_ex_glock",
    "tacrp_ex_vertec",
    "tacrp_gsr1911",
    "tacrp_p2000",
    "tacrp_ex_usp",
    "tacrp_ex_mac10",
    "tacrp_skorpion",
    "tacrp_bekas",
    "tacrp_tgs12",
    "tacrp_m1"
}
ENT.ScavengeLoot_Melees = {
    "tacrp_m_bamaslama",
    "tacrp_m_bat",
    "tacrp_m_bayonet",
    "tacrp_m_boina",
    "tacrp_m_cleaver",
    "tacrp_m_crowbar",
    "tacrp_m_css",
    "tacrp_m_fasthawk",
    "tacrp_m_gerber",
    "tacrp_m_glock",
    "tacrp_m_hamma",
    "tacrp_m_harpoon",
    "tacrp_m_incorp",
    "tacrp_m_kitchen",
    "tacrp_m_knife3",
    "tacrp_m_kukri",
    "tacrp_m_machete",
    "tacrp_m_pan",
    "tacrp_m_pipe",
    "tacrp_m_rambo",
    "tacrp_m_shovel",
    "tacrp_m_tonfa",
    "tacrp_m_tracker",
    "tacrp_m_wrench",
    "tacrp_m_bamaslama",
    "tacrp_m_bat",
    "tacrp_m_bayonet",
    "tacrp_m_boina",
    "tacrp_m_cleaver",
    "tacrp_m_crowbar",
    "tacrp_m_css",
    "tacrp_m_fasthawk",
    "tacrp_m_gerber",
    "tacrp_m_glock",
    "tacrp_m_hamma",
    "tacrp_m_harpoon",
    "tacrp_m_incorp",
    "tacrp_m_kitchen",
    "tacrp_m_knife3",
    "tacrp_m_kukri",
    "tacrp_m_machete",
    "tacrp_m_pan",
    "tacrp_m_pipe",
    "tacrp_m_rambo",
    "tacrp_m_shovel",
    "tacrp_m_tonfa",
    "tacrp_m_tracker",
    "tacrp_m_wrench",

    // rare
    "tacrp_m_heathawk",
    "tacrp_m_wiimote",
}
ENT.ScavengeLoot_Items = {
    "tacrp_ammo_flashbang",
    "tacrp_ammo_flashbang",
    "tacrp_ammo_flashbang",
    "tacrp_ammo_smoke",
    "tacrp_ammo_smoke",
    "tacrp_ammo_smoke",
    "tacrp_ammo_gas",
    "tacrp_ammo_gas",
    "tacrp_ammo_heal",
    "arcrp_drug_beer",
    "arcrp_drug_beer",
    "arcrp_drug_beer",
    "arcrp_in_component",
    "arcrp_in_electronics",
    "arcrp_in_adv_electronics",
    "arcrp_in_steel",
    "arcrp_in_chemicals",
    "arcrp_in_fuel",
    "arcrp_in_fuze",
    "arcrp_in_gear",
    "arcrp_in_screws",
    "arcrp_in_paper",
    "arcrp_in_pipe",
    "arcrp_in_wood",
}

ENT.ScavengeLoot_LiveGrenades = {
    "tacrp_proj_nade_flashbang",
    "tacrp_proj_nade_flashbang",
    "tacrp_proj_nade_flashbang",
    "tacrp_proj_nade_flashbang",
    "tacrp_proj_nade_smoke",
    "tacrp_proj_nade_smoke",
    "tacrp_proj_nade_gas",
    "tacrp_proj_nade_heal",
    "tacrp_proj_nade_frag",
}

local descriptors = {
    "a slightly battered",
    "a worn",
    "a smelly",
    "a stained",
    "a wet",
    "a sticky",
    "a slimy",
    "a moist",
    "a fine-looking",
    "a beaten",
    "a nasty-looking",
    "a blood stained",
    "a funny smelling",
    "a somewhat functional",
    "an okay looking",
    "a decent",
    "a weird-looking",
    "a barely functional",
    "a rusty",
    "an average",
    "a snot-ridden",
    "a fishy smelling",
    "a dusty",
    "a dust-covered",
    "a tainted",
    "a dangerous-looking",
    "a boring",
    "a mundane",
    "an unassuming",
    "a typical",
}

local dispose_blacklist = {
    ["tacrp_medkit"] = true,
    ["tacrp_riot_shield"] = true,
}

ENT.SpawnOffset = Vector(0, 0, 32)
ENT.ScavengeDelay = 120

function ENT:DisposeWeapon(activator, caller)
    local wep = activator:GetActiveWeapon()

    if IsValid(wep) and weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then

        local canDrop = hook.Call("canDropWeapon", GAMEMODE, activator, wep)
        if !canDrop or dispose_blacklist[wep:GetClass()] then
            DarkRP.notify(activator, 1, 4, "This item cannot be disposed.")
            return
        end

        local money = 0
        if wep:GetValue("PrimaryMelee") or wep:GetValue("PrimaryGrenade") then
            money = math.random(5, 25)
        elseif wep.Attachments then
            local has_surplus = false
            for k, v in pairs(wep.Attachments or {}) do
                if v.Installed == "bolt_surplus" then
                    has_surplus = true
                    break
                end
            end
            if !has_surplus then
                money = math.random(10, 75)
            else
                money = math.random(5, 25)
            end
        end
        activator:StripWeapon(wep:GetClass())
        if money > 0 then
            DarkRP.notify(activator, 0, 4, "Thank you for keeping the streets clean! You received a " .. DarkRP.formatMoney(money) .. " cash refund.")
            activator:addMoney(money)
        else
            DarkRP.notify(activator, 0, 4, "Thank you for keeping the streets clean! Your disposal item was not eligible for a cash refund.")
        end

        self:EmitSound("doors/door_metal_thin_close2.wav", 85, math.Rand(98, 102))
    end
end

function ENT:Scavenge(activator, caller)
    if self:GetNextScavengeTime() < CurTime() then
        // SCAVENGE!!!! :torle:

        local roll = math.random(1, 100)

        if roll <= 60 then
            // roll random melee
            local randowep = table.Random(self.ScavengeLoot_Melees)

            if roll <= 3 then
                // roll random gun
                randowep = table.Random(self.ScavengeLoot_Guns)
            elseif roll <= 45 then
                // item
                randowep = table.Random(self.ScavengeLoot_Items)
            end

            local newwep = ents.Create(randowep)
            if !IsValid(newwep) then print("Invalid entity: " .. randowep) return end
            local newpos = self:GetPos()
            newpos = newpos + self:GetForward() * self.SpawnOffset.x
            newpos = newpos + self:GetRight() * self.SpawnOffset.y
            newpos = newpos + self:GetUp() * self.SpawnOffset.z
            newwep:SetPos(newpos)
            newwep.nodupe = true
            newwep.spawnedBy = activator

            if newwep.ArcticTacRP and newwep.Attachments then
                for k, v in pairs(newwep.Attachments) do
                    if v.Category == "bolt_automatic" or v.Category == "bolt_manual"
                            or (istable(v.Category) and (table.HasValue(v.Category, "bolt_automatic") or table.HasValue(v.Category, "bolt_manual"))) then
                        v.Installed = "bolt_surplus"
                        break
                    end
                end
            end
            newwep:Spawn()

            DarkRP.notify(activator, 0, 5, "You found " .. descriptors[math.random(1, #descriptors)] .. " " .. newwep.PrintName .. "!")
        elseif roll <= 70 then
            local amount = math.ceil(math.random(5, 30))
            activator:addMoney(amount)
            DarkRP.notify(activator, 0, 5, "You found " .. DarkRP.formatMoney(amount) .. "!")
        elseif roll <= 95 then
            local amount = math.ceil(math.random(1, 5))
            activator:addMoney(amount)
            DarkRP.notify(activator, 0, 5, "You found " .. DarkRP.formatMoney(amount) .. ".")
        elseif roll == 100 then
            -- hot potato
            local newwep = ents.Create(table.Random(self.ScavengeLoot_LiveGrenades))
            if !IsValid(newwep) then print("Invalid entity: " .. randowep) return end
            local newpos = self:GetPos()
            newpos = newpos + self:GetForward() * self.SpawnOffset.x
            newpos = newpos + self:GetRight() * self.SpawnOffset.y
            newpos = newpos + self:GetUp() * self.SpawnOffset.z
            newwep:SetPos(newpos)
            newwep.nodupe = true
            newwep.spawnedBy = activator
            newwep.Delay = math.Rand(3, 5) -- more time to react
            newwep:Spawn()
            newwep:GetPhysicsObject():ApplyTorqueCenter(VectorRand() * 360)
            newwep:GetPhysicsObject():ApplyForceCenter(VectorRand() * 100 + (activator:EyePos() - newpos):GetNormalized() * 300 + Vector(0, 0, math.Rand(100, 300)))
            DarkRP.notify(activator, 1, 5, "You found a live grenade?!")
        else
            DarkRP.notify(activator, 1, 5, "You didn't find anything...")
        end

        self:SetNextScavengeTime(CurTime() + self.ScavengeDelay * math.Rand(1, 1.5))
    else
        DarkRP.notify(activator, 1, 4, "There is nothing to scavenge at the moment...")
    end

    self:EmitSound("doors/door_metal_rusty_move1.wav", 85, math.Rand(98, 102))
end

function ENT:PhysicsCollide(coldata, collider)
    local ent = coldata.HitEntity
    if IsValid(ent) and ent:GetNWBool("IMDE_IsRagdoll") and ent.IsDeathRagdoll and not IsValid(ent:GetOwner()) and !ent.USED then
        ent.USED = true

        local money = ent.DisposeReward and math.random(5, 50) or math.random(1, 5)
        if IsValid(ent.Dragger) and ent.Dragger:Alive()
                and IsValid(ent.Dragger:GetActiveWeapon()) and ent.Dragger:GetActiveWeapon():GetClass() == "arcrp_hands"
                and ent.Dragger:GetActiveWeapon().DraggingEnt == ent then
            ent.Dragger:addMoney(money)
            DarkRP.notify(ent.Dragger, 0, 5, "Thank you for keeping the streets clean! You received " .. DarkRP.formatMoney(money) .. " for disposing a body.")
        else
            DarkRP.createMoneyBag(ent:WorldSpaceCenter() + Vector(0, 0, 10), money)
        end
        SafeRemoveEntity(ent)
        self:EmitSound("doors/door_metal_thin_close2.wav", 85, math.Rand(98, 102))
    end
end
