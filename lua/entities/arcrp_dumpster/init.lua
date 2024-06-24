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

    self.NextScavengeTime = 0
end

function ENT:canUse(owner, activator)
    return true
end

ENT.ScavengeLoot_Guns = {
    "tacrp_ex_m1911",
    "tacrp_ex_glock",
    "tacrp_gsr1911",
    "tacrp_mr96",
    "tacrp_ex_usp",
    "tacrp_ex_mac10",
    "tacrp_uzi",
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
    "tacrp_m_heathawk",
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
    "tacrp_m_wiimote",
    "tacrp_m_wrench",
}

ENT.SpawnOffset = Vector(0, 0, 64)
ENT.ScavengeDelay = 60

function ENT:Use(activator, caller)
    local wep = activator:GetActiveWeapon()

    if IsValid(wep) and weapons.IsBasedOn(wep:GetClass(), "tacrp_base") then
        activator:StripWeapon(wep:GetClass())
        DarkRP.notify(activator, 1, 4, "Thank you for keeping the streets clean!")
    else

        if self.NextScavengeTime < CurTime() then
            // SCAVENGE!!!! :torle:

            local roll = math.random(0, 100)

            if roll < 20 then
                // roll random melee
                local randowep = table.Random(self.ScavengeLoot_Melees)

                if roll < 5 then
                    // roll random gun
                    randowep = table.Random(self.ScavengeLoot_Guns)
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
                newwep:Spawn()

                DarkRP.notify(activator, 0, 4, "You found a(n) " .. newwep.PrintName .. "!")
            else
                // moners
                local amount = math.random(5, 100)

                activator:addMoney(amount)
                DarkRP.notify(activator, 0, 4, "You found " .. DarkRP.formatMoney(amount) .. "!")
            end

            self.NextScavengeTime = CurTime() + self.ScavengeDelay
        else
            DarkRP.notify(activator, 1, 4, "There is nothing to scavenge at the moment...")
        end
    end
end
