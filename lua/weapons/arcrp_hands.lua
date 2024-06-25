AddCSLuaFile()

SWEP.IconOverride = "materials/entities/weapon_fists.png"
SWEP.PrintName = "ArcRP Hands"
SWEP.Purpose = "Multi-functionality SWEP. You're in good hands now."
SWEP.Instructions = "Left Click: Lock door / Pickup item / Drag body\nRight Click: Unlock door\nReload: Open pocket / Door menu\nReload + Walk: Animation menu"
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

local function lockUnlockAnimation(ply, snd)
    ply:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
    timer.Simple(0.9, function() if IsValid(ply) then ply:EmitSound(snd) end end)

    umsg.Start("anim_keys")
        umsg.Entity(ply)
        umsg.String("usekeys")
    umsg.End()

    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
end

local function doKnock(ply, sound)
    ply:EmitSound(sound, 100, math.random(90, 110))

    umsg.Start("anim_keys")
        umsg.Entity(ply)
        umsg.String("knocking")
    umsg.End()

    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Dragging")
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
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Holster()
    self:StopDragging()
    return true
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.2)
    self:SetNextSecondaryFire(CurTime() + 0.2)

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
        elseif SERVER and ent:isKeysOwnable() and ((ent:isDoor() and distsqr < 2000) or (ent:IsVehicle() and eyepos:DistToSqr(hitpos) < 4000)) then
            if owner:canKeysLock(ent) then
                ent:keysLock() -- Lock the door immediately so it won't annoy people
                lockUnlockAnimation(owner, "doors/door_latch3.wav")
            elseif ent:IsVehicle() then
                DarkRP.notify(owner, 1, 3, DarkRP.getPhrase("do_not_own_ent"))
            else
                doKnock(owner, "physics/wood/wood_crate_impact_hard2.wav")
            end
        elseif SERVER then
            local canPickup, message = hook.Call("canPocket", GAMEMODE, owner, ent)
            if not canPickup then
                if message then DarkRP.notify(owner, 1, 4, message) end
                return
            end
            owner:addPocketItem(ent)
        end
    end
end

function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.2)
    self:SetNextSecondaryFire(CurTime() + 0.2)

    local owner = self:GetOwner()

    if self:GetDragging() then
        self:StopDragging()
    else
        local tr = owner:GetEyeTrace()
        local ent = tr.Entity
        if not IsValid(ent) then return end
        local distsqr = tr.HitPos:DistToSqr(owner:EyePos())
        if SERVER and ent:isKeysOwnable() and ((ent:isDoor() and distsqr < 2000) or (ent:IsVehicle() and eyepos:DistToSqr(hitpos) < 4000)) then
            if owner:canKeysUnlock(ent) then
                ent:keysUnLock()
                lockUnlockAnimation(owner, "doors/door_latch3.wav")
            elseif ent:IsVehicle() then
                DarkRP.notify(owner, 1, 3, DarkRP.getPhrase("do_not_own_ent"))
            else
                doKnock(owner, "physics/wood/wood_crate_impact_hard2.wav")
            end
        end
    end
end

function SWEP:Reload()
    local owner = self:GetOwner()
    if owner:KeyDown(IN_WALK) then
        if CLIENT and not DarkRP.disabledDefaults["modules"]["animations"] then RunConsoleCommand("_DarkRP_AnimationMenu") end
    else
        local tr = owner:GetEyeTrace()
        local ent = tr.Entity
        if IsValid(ent) and (ent:isDoor() or ent:IsVehicle()) and owner:EyePos():DistToSqr(tr.HitPos) <= 40000 then
            if SERVER then
                umsg.Start("KeysMenu", self:GetOwner())
                umsg.End()
            end
        else
            if CLIENT then
                DarkRP.openPocketMenu()
            end
            if SERVER and game.SinglePlayer() then
                net.Start("DarkRP_PocketMenu")
                net.Send(owner)
            end
        end
    end
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
        if not IsValid(self:GetDraggingEnt()) then
            self:StopDragging()
        else
            self:ApplyForce()
        end
    end
end

hook.Add("StartCommand", "ArcRP_Hands", function(ply, cmd)
    if cmd:KeyDown(IN_SPEED) and (
            cmd:GetForwardMove() <= 0 or -- also stops backwards sprinting
            (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "arcrp_hands" and ply:GetActiveWeapon():GetDragging())) then
        cmd:RemoveKey(IN_SPEED)
    end
end)

if SERVER then return end

local function hack()
    local pocket = pocket or {}
    local frame

    local function reload()
        if not IsValid(frame) or not frame:IsVisible() then return end
        if not pocket or next(pocket) == nil then frame:Close() return end
    
        local itemCount = table.Count(pocket)
    
        frame.List:Clear()
        local items = {}
    
        for k, v in pairs(pocket) do
            local ListItem = frame.List:Add("DPanel")
            ListItem:SetSize(64, 64)
    
            local icon = vgui.Create("SpawnIcon", ListItem)
            icon:SetModel(v.model)
            icon:SetSize(64, 64)
            icon:SetTooltip()
            icon.DoClick = function(self)
                icon:SetTooltip()
    
                net.Start("DarkRP_spawnPocket")
                    net.WriteFloat(k)
                net.SendToServer()
                pocket[k] = nil
    
                itemCount = itemCount - 1
    
                if itemCount == 0 then
                    frame:Close()
                    return
                end
    
                fn.Map(self.Remove, items)
                items = {}
    
                local wep = LocalPlayer():GetActiveWeapon()
    
                wep:SetHoldType("pistol")
                timer.Simple(0.2, function()
                    if wep:IsValid() then
                        wep:SetHoldType("normal")
                    end
                end)
            end
    
            table.insert(items, icon)
        end
        if itemCount < GAMEMODE.Config.pocketitems then
            for _ = 1, GAMEMODE.Config.pocketitems - itemCount do
                local ListItem = frame.List:Add("DPanel")
                ListItem:SetSize(64, 64)
            end
        end
    end
    function DarkRP.openPocketMenu()
        if IsValid(frame) and frame:IsVisible() then return end
        local wep = LocalPlayer():GetActiveWeapon()
        if not wep:IsValid() or (wep:GetClass() ~= "pocket" and wep:GetClass() ~= "arcrp_hands") then return end
    
        if not pocket then
            pocket = {}
            return
        end
    
        if table.IsEmpty(pocket) then return end
        frame = vgui.Create("DFrame")
    
        local count = GAMEMODE.Config.pocketitems or GM.Config.pocketitems
        frame:SetSize(345, 32 + 64 * math.ceil(count / 5) + 3 * math.ceil(count / 5))
        frame:SetTitle(DarkRP.getPhrase("drop_item"))
        frame.btnMaxim:SetVisible(false)
        frame.btnMinim:SetVisible(false)
        frame:SetDraggable(false)
        frame:MakePopup()
        frame:Center()
    
        local Scroll = vgui.Create("DScrollPanel", frame)
        Scroll:Dock(FILL)
    
        local sbar = Scroll:GetVBar()
        sbar:SetWide(3)
        frame.List = vgui.Create("DIconLayout", Scroll)
        frame.List:Dock(FILL)
        frame.List:SetSpaceY(3)
        frame.List:SetSpaceX(3)
        reload()
        frame:SetSkin(GAMEMODE.Config.DarkRPSkin)
    end
    net.Receive("DarkRP_PocketMenu", DarkRP.openPocketMenu)


    local function retrievePocket()
        pocket = net.ReadTable()
        reload()
    end
    net.Receive("DarkRP_Pocket", retrievePocket)
end
hook.Add("InitPostEntity", function()
    timer.Simple(1, function() hack() end)
end)
hack()