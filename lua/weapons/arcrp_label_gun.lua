AddCSLuaFile()

SWEP.IconOverride = "materials/entities/weapon_fists.png"
SWEP.PrintName = "Label Gun"
SWEP.Purpose = "Create sellable entities by affixing labels to them."
SWEP.Instructions = "Left Click: Make Sellable"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 64
SWEP.BobScale = 1.3
SWEP.SwayScale = 1.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DisableDuplicator = true
SWEP.BounceWeaponIcon = false
SWEP.m_bPlayPickupSound = false
SWEP.HitDistance = 60

SWEP.DoNotDrop = true

function SWEP:SetupDataTables()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
    if SERVER then return end

    if !IsFirstTimePredicted() then return end

    local owner = self:GetOwner()
    local ent = owner:GetEyeTrace().Entity

    if !IsValid(ent) then return end
    if !ent.CanBeSold and !ArcRP_Sellable[ent:GetClass()] then return end
    if IsValid(ent:GetOwner()) and ent:GetOwner() != owner then
        return
    end
    if ent.Getowning_ent and ent:Getowning_ent() != ply then return end
    if ent:GetNWInt("arcrp_salescost", 0) > 0 then return end
    if ent:GetPos():DistToSqr(owner:GetPos()) > 128 * 128 then return end

    Derma_StringRequest("Label Printer", "Charge how much?", "0", function(string)
        local cost = tonumber(string)

        if cost != nil then
            cost = math.Clamp(cost, 0, math.pow(2, 32) - 1)

            net.Start("arcrp_makesellable")
            net.WriteEntity(ent)
            net.WriteUInt(cost, 32)
            net.SendToServer()
        end
    end)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
end