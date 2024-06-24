hook.Add("CalcView", "IMDB_View", function(ply, origin, angles, fov, znear, zfar)
    local rag = ply:IMDE_GetRagdoll()
    if not IsValid(rag) or (not ply:IMDE_IsHidden() and ply:Alive()) then
        if IsValid(ply.LastRag) then
            local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
            if not bone then return end
            rag:ManipulateBoneScale(bone, Vector(1, 1, 1))
        end
        ply.LastRag = nil
        return
    end
    ply.LastRag = rag

    local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
    if not bone then return end
    rag:ManipulateBoneScale(bone, Vector(0.01, 0.01, 0.01))
    local matrix = rag:GetBoneMatrix(bone)
    if not matrix then return nil end
    local pos = matrix:GetTranslation()
    local ang = matrix:GetAngles()

    -- pos = pos - (ply:GetAimVector() * 128)
    -- ang = (pos - c_pos):Angle()

    pos = pos + ang:Forward() * 0
    ang:RotateAroundAxis(ang:Up(), -90)
    ang:RotateAroundAxis(ang:Forward(), -90)
    pos = pos + ang:Forward() * 2

    return {
        origin = pos,
        angles = ang,
    }
end)