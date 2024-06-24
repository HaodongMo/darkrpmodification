local maxs = 512
local maxvol = 256 * 256 * 256

hook.Add("PlayerSpawnedProp", "ARCRP_LimitProps", function(ply, model, ent)
    if !IsValid(ent) then return end

    local min, max = ent:WorldSpaceAABB()

    local long = max[1] - min[1]
    local wide = max[2] - min[2]
    local tall = max[3] - min[3]

    if long > maxs or wide > maxs or tall > maxs then
        SafeRemoveEntity(ent)
        DarkRP.notify(ply, 1, 3, "Prop is too big!")
        return
    end

    if long * wide * tall > maxvol then
        SafeRemoveEntity(ent)
        DarkRP.notify(ply, 1, 3, "Prop is too big!")
        return
    end
end)