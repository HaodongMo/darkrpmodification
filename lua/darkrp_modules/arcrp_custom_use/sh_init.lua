-- ent = entity you are trying to customUse
-- ply = custom user

function ArcRP_GetCustomUse(ent, ply)
    if ent:IsPlayer() then
        if ent:isArrested() and !ply:isArrested() and ply:getJobTable().unarrest then
            return {
                callback = function(ent2, ply2)
                    if ent2:isArrested() and !ply2:isArrested() and ply:getJobTable().unarrest then
                        GAMEMODE.Config.telefromjail = false
                        ent2:unArrest(ply2)
                        GAMEMODE.Config.telefromjail = true
                    end
                end,
                message = "Unarrest"
            }
        end
    elseif ent.isVendingMachine then
        return {
            cl_callback = function(ent2, ply2)
                ArcRP_OpenVendingMachine()
            end,
            message = "Use Gun's 4U"
        }
    end
end