AddCSLuaFile()

SWEP.IconOverride = "materials/entities/weapon_fists.png"
SWEP.PrintName = "ArcRP Hands"
SWEP.Purpose = "Multi-functionality SWEP. You're in good hands now."
SWEP.Instructions = "Left Click: Pickup item / Drag body\nRight Click: Surrender!\nReload: Animation menu"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
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

SWEP.SurrenderDuration = 10

SWEP.DoNotDrop = true

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    y = y + 10
    x = x + 10
    wide = wide - 20

    self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
    return
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Dragging")
    self:NetworkVar("Bool", 1, "Surrendered")
    self:NetworkVar("Float", 0, "SurrenderTime")
end

function SWEP:GetDraggingEnt()
    return self.DraggingEnt
end

function SWEP:StartDragging(ent, pos, bone)
    if IsValid(self.DraggingEnt) then self:StopDragging() end
    self:SetDragging(true)
    self.DraggingEnt = ent
    self.DraggingEntBone = bone
    self.DraggingEntPos = pos
    ent.Dragger = self:GetOwner()
    self:SetHoldType("fist")
end

function SWEP:StopDragging()
    self:SetDragging(false)
    if IsValid(self.DraggingEnt) then
        self.DraggingEnt.Dragger = nil
    end
    self.DraggingEnt = nil
    self:SetHoldType("normal")
end

function SWEP:CanDrag(ent)
    if ent:IsRagdoll() then return true end

    return false
end

function SWEP:Initialize()
    self:SetShouldHoldType()
end

function SWEP:Deploy()
    self:SetShouldHoldType()
    return true
end

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
    self:SetShouldHoldType()
end

function SWEP:Holster()
    self:StopDragging()

    self:SetShouldHoldType()

    if self:GetSurrendered() then return false end

    return true
end

function SWEP:ShouldBeSurrendered()
    return self:GetSurrenderTime() + self.SurrenderDuration > CurTime()
end

local bonemods = {
    ["ValveBiped.Bip01_L_UpperArm"] = {
        Pos = Vector(0, 0, 0),
        Ang = Angle(-25, -90, 0)
    },
    ["ValveBiped.Bip01_R_UpperArm"] = {
        Pos = Vector(0, 0, 0),
        Ang = Angle(25, -90, 0)
    },
}

function SWEP:SetShouldHoldType()
    local holdtype = "normal"
    local shouldbonemods = false

    if self:GetSurrendered() then
        holdtype = "duel"
        shouldbonemods = true
    end

    local owner = self:GetOwner()

    if !IsValid(owner) then return end

    for bone, k in pairs(bonemods) do
        local index = owner:LookupBone(bone)
        if shouldbonemods then
            owner:ManipulateBoneAngles(index, k.Ang, true)
        else
            owner:ManipulateBoneAngles(index, Angle(0, 0, 0), true)
        end
    end

    self:SetHoldType(holdtype)
end

function SWEP:PrimaryAttack()
    if self:GetSurrendered() then return end

    local owner = self:GetOwner()

    if self:GetDragging() then
        self:StopDragging()
    else
        local tr = owner:GetEyeTrace()
        local ent = tr.Entity
        if not IsValid(ent) then return end
        local distsqr = tr.HitPos:DistToSqr(owner:EyePos())
        if self:CanDrag(ent) and distsqr <= 72 * 72 then
            self:StartDragging(ent, tr.HitPos, tr.PhysicsBone)
        end
    end
end

function SWEP:SecondaryAttack()
    self:SetSurrenderTime(CurTime())
    self:SetShouldHoldType()
end

function SWEP:Reload()
    if CLIENT and not DarkRP.disabledDefaults["modules"]["animations"] then RunConsoleCommand("_DarkRP_AnimationMenu") end
end

function SWEP:ApplyForce()
    local ent = self:GetDraggingEnt()
    local target = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 32
    local phys = ent:GetPhysicsObjectNum(self.DraggingEntBone or 0)
    if IsValid(phys) then
        local pos = phys:GetPos()

        -- if self.DraggingEntPos then
        --     pos = ent:LocalToWorld(self.DraggingEntPos)
        -- end

        local vec = target - pos
        local len, mul = vec:Length(), ent:GetPhysicsObject():GetMass()
        -- local StandingEnt = self:GetOwner():GetGroundEntity()
        -- local StandingOn = IsValid(StandingEnt) and ((StandingEnt == ent) or (StandingEnt:IsConstrained() and table.HasValue(constraint.GetAllConstrainedEntities(StandingEnt), ent)))

        if len > 64 then -- or StandingOn
            self:StopDragging()
            return
        end

        if ent:IsRagdoll() then
            mul = mul * 10
        end

        vec:Normalize()
        local avec, velo = vec * len ^ 1.5, phys:GetVelocity() - self:GetOwner():GetVelocity()
        local Force = (avec - velo / 2) * mul
        local ForceNormal = Force:GetNormalized()
        local ForceMagnitude = Force:Length()
        ForceMagnitude = math.Clamp(ForceMagnitude, 0, 3000)
        Force = ForceNormal * ForceMagnitude
        phys:ApplyForceCenter(Force)

        phys:ApplyForceCenter(Vector(0, 0, mul))
        phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
    end
end

function SWEP:Think()
    if SERVER and self:GetDragging() then
        if not IsValid(self:GetDraggingEnt()) or self:GetSurrendered() then
            self:StopDragging()
        else
            self:ApplyForce()
        end
    end

    if self:ShouldBeSurrendered() and not self:GetSurrendered() then
        self:StartSurrender()
    elseif not self:ShouldBeSurrendered() and self:GetSurrendered() then
        self:StopSurrender()
    end
end

function SWEP:StartSurrender()
    self:SetSurrendered(true)
    self:SetShouldHoldType()
end

function SWEP:StopSurrender()
    self:SetSurrendered(false)
    self:SetShouldHoldType()
end

local colorBackground = Color(10, 10, 10, 120)

function SWEP:DrawHUD()
    if not self:GetSurrendered() then return end

    local w = ScrW()
    local h = ScrH()
    local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
    draw.RoundedBox(8, x, y, width, height, colorBackground)

    local time = self.SurrenderDuration
    local curtime = CurTime() - self:GetSurrenderTime()
    local status = 1 - math.Clamp(curtime / time, 0, 1)
    local BarWidth = status * (width - 16)
    local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)
    draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(0 + (status * 255), 255 - (status * 255), 0, 255))

    draw.DrawNonParsedSimpleText("Surrendered! Cannot change weapons...", "Trebuchet24", w / 2, y + height / 2, color_white, 1, 1)
end

hook.Add("StartCommand", "ArcRP_Hands", function(ply, cmd)
    if cmd:KeyDown(IN_SPEED) and (
            (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "arcrp_hands" and ply:GetActiveWeapon():GetDragging())) then
        cmd:RemoveKey(IN_SPEED)
    end
end)