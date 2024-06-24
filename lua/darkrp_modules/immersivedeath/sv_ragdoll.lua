local PLAYER = FindMetaTable("Player")

local dirs = {
    Vector(1, 0, 0),
    Vector(0, 1, 0),
    Vector(-1, 0, 0),
    Vector(-1, 0, 0),
    Vector(1, 1, 0),
    Vector(1, -1, 0),
    Vector(-1, 1, 0),
    Vector(-1, -1, 0),
}
local mins, maxs = Vector(-16, -16, 0), Vector(16, 16, 72)
local function trace(pos, filter)
    local tr = util.TraceHull({
        start = pos,
        endpos = pos,
        mins = mins,
        maxs = maxs,
        filter = filter,
        mask = MASK_PLAYERSOLID,
        collisiongroup = COLLISION_GROUP_PLAYER,
    })
    debugoverlay.Box(pos, mins, maxs, 5, tr.Hit and Color(255, 255, 255, 0) or Color(0, 255, 0, 0))
    return not tr.Hit and not tr.AllSolid
end
function PLAYER:IMDE_FindEmptySpot(pos, filter)
    if trace(pos, filter) then return pos end
    for i = 1, 4 do
        for _, v in pairs(dirs) do
            local pos2 = pos + v * (32 * i)
            if trace(pos2, filter) then
                return pos2
            end
        end
    end
    return false
end

function PLAYER:IMDE_Ragdoll(death, force, position)

    local vel = self:GetVelocity()
    if force then
        vel = vel + force * 10
    end

    if not death and IsValid(self.IMDE_RagdollEntity) then
        self:IMDE_GetRagdoll():Remove()
    end

    local rag = ents.Create("prop_ragdoll")
    rag:SetModel(self:GetModel())
    rag:SetPos(self:GetPos())
    rag:SetAngles(self:GetAngles())
    rag:SetColor(self:GetColor())
    rag:SetMaterial(self:GetMaterial())
    rag:SetSkin(self:GetSkin())
    rag:Spawn()
    rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    rag:SetNWVector("IMDE_RagdollColor", self:GetPlayerColor())
    function rag.GetPlayerColor(self2)
        return self2:GetNWVector("IMDE_RagdollColor")
    end

    for i = 1, #self:GetBodyGroups() do
        rag:SetBodygroup(i, self:GetBodygroup(i))
    end

    local num = rag:GetPhysicsObjectCount() - 1
    for i = 0, num do
        local bone = rag:GetPhysicsObjectNum(i)
        if IsValid(bone) then
            local bp, ba = self:GetBonePosition(rag:TranslatePhysBoneToBone(i))
            if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
            end

            bone:SetVelocity(vel + VectorRand() * 200)

            bone:SetMass(10)
        end
    end

    if not death then
        self:SetParent(rag)
        rag:SetOwner(self)

        self.IMDE_LastPosition = self:GetPos()
    else
        SafeRemoveEntityDelayed(rag, 300)
    end

    self:SetNWEntity("IMDE_LastRagdoll", rag)
    self:SetNWFloat("IMDE_LastRagdollTime", CurTime())

    rag.CreateTime = CurTime()
    rag.IsDeathRagdoll = death
    rag:SetNWEntity("IMDE_IsRagdoll", true)

    return rag
end

function PLAYER:IMDE_UnRagdoll()

    local rag = self:IMDE_GetRagdoll()

    self:SetParent(NULL)

    if IsValid(rag) then
        local pos = self:IMDE_FindEmptySpot(rag:GetPos(), {self, rag})
        if not pos then
            -- uh oh
            pos = self:GetPos()
            print("Failed to find wake-up location for " .. self .. "!")
        end
        self:SetPos(pos)
        rag:Remove()
    elseif self.IMDE_LastPosition then
        self:SetPos(self.IMDE_LastPosition)
    end
end

function PLAYER:IMDE_Hide(hidden)
    self:SetNWBool("IMDE_Hidden", hidden)
    self:SetNoDraw(hidden)
    self:DrawShadow(not hidden)
    self:SetNotSolid(hidden)
    self:DrawWorldModel(not hidden)
    self:Freeze(hidden)
    -- self:SetNoTarget(hidden)
    self:SetCollisionGroup(hidden and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_PLAYER)
end

function PLAYER:IMDE_MakeUnconscious(force, position)
    if self:IMDE_IsHidden() then return end
    if self:InVehicle() then self:ExitVehicle() end
    -- self:Give("imde_holster", true)
    -- self:SelectWeapon("imde_holster")
    self:SetActiveWeapon(NULL)

    self:IMDE_Ragdoll(false, force, position)
    self:IMDE_Hide(true)
    self.IMDE_UnconsciousStart = CurTime()
end

function PLAYER:IMDE_MakeConscious()
    if not self:IMDE_IsHidden() then return end
    -- self:StripWeapon("imde_holster")
    self:IMDE_Hide(false)
    self:IMDE_UnRagdoll()
end

hook.Add("DoPlayerDeath", "IMDE_Ragdoll", function(ply, attacker, dmginfo)
    ply.DeathCache = {
        attacker = attacker,
        dmginfo = dmginfo
    }
end)

hook.Add("PlayerDeath", "IMDE_Ragdoll", function(ply)
    if not GetConVar("imde_enabled"):GetBool() then return end

    if IsValid(ply:IMDE_GetRagdoll()) and ply:IMDE_IsHidden() then
        ply:IMDE_Hide(false)
        ply:SetParent(NULL)
        ply:IMDE_GetRagdoll():SetOwner(nil)
        SafeRemoveEntityDelayed(ply:IMDE_GetRagdoll(), 300)
        ply.IMDE_LastPosition = nil
    else
        ply:IMDE_Ragdoll(true)
    end

    ply:IMDE_GetRagdoll().DeathInfo = {
        ply = ply,
        name = ply:GetName(), -- incase they disconnect
        killer = ply.DeathCache.attacker,
        dnatime = 60 -- TODO: dependent on killing method and range
    }

    if IsValid(ply:GetRagdollEntity()) then
        ply:GetRagdollEntity():Remove()
    end

    local rag = ply:IMDE_GetRagdoll()
    local name = "death_bleed_" .. rag:EntIndex()
    timer.Create(name, 0.5, math.random(10, 20), function()
        if not IsValid(rag) then timer.Remove(name) return end

        local start = rag:GetPos() + VectorRand() * 16
        start.z = 20
        local btr = util.TraceLine({
            start = start,
            endpos = start - Vector(0, 0, 256),
            mask = MASK_SOLID,
            ignore = rag,
        })
        util.Decal("Blood", btr.HitPos + btr.HitNormal, btr.HitPos - btr.HitNormal, rag)
    end)
end)
