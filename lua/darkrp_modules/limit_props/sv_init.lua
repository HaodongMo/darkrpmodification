local maxs = 300
local maxvol = 256 * 256 * 256

GAMEMODE.PropLimitTable = {}

hook.Add("PlayerSpawnedProp", "ARCRP_LimitProps", function(ply, model, ent)
    if GAMEMODE.PropLimitTable[model] != nil then
        if GAMEMODE.PropLimitTable[model] == false then
            SafeRemoveEntity(ent)
        end

        return
    end

    if !IsValid(ent) then return end

    local physobj = ent:GetPhysicsObject()

    if !IsValid(physobj) or util.IsValidModel(model) then
        SafeRemoveEntity(ent)
        DarkRP.notify(ply, 1, 3, "Prop is not valid!")
        GAMEMODE.PropLimitTable[model] = false
        return
    end

    local min, max = ent:WorldSpaceAABB()

    local long = max[1] - min[1]
    local wide = max[2] - min[2]
    local tall = max[3] - min[3]

    if long > maxs or wide > maxs or tall > maxs then
        SafeRemoveEntity(ent)
        DarkRP.notify(ply, 1, 3, "Prop is too big!")
        GAMEMODE.PropLimitTable[model] = false
        return
    end

    if long * wide * tall > maxvol then
        SafeRemoveEntity(ent)
        DarkRP.notify(ply, 1, 3, "Prop is too big!")
        GAMEMODE.PropLimitTable[model] = false
        return
    end

    GAMEMODE.PropLimitTable[model] = true
end)