-- ent = entity you are trying to customUse
-- ply = custom user

function ArcRP_GetCustomUse(ent, ply)
    if ent:IsPlayer() then
        if ent:isArrested() and !ply:isArrested() then
            return {
                callback = function(ent2, ply2)
                    if ent2:isArrested() and !ply2:isArrested() then
                        ent2:unArrest(ply2)
                    end
                end,
                message = "Unarrest"
            }
        end
    end
end