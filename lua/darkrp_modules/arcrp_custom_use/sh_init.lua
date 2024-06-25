-- ent = entity you are trying to customUse
-- ply = custom user

local doors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true
}

function ArcRP_GetCustomInteractionHint(ent, ply)
    if ent:isDoor() then
        local owner = ent:getDoorOwner()

        if IsValid(owner) then
            return "Owned by " .. owner:Nick()
        else
            return "F2 to buy door"
        end
    end
end

function ArcRP_GetCustomContextMenu(ent, ply)
    if isfunction(ent.GetContextMenu) then
        return ent:GetContextMenu(ply)
    elseif ent:isDoor() then
        local tbl = {
                {
                    message = "Open/Close",
                    callback = function(ent2, ply2)
                        ent:Use(ent2, ply2, USE_TOGGLE, 0)
                    end
                },
                {
                    message = "Knock",
                    callback = function(ent2, ply2)
                        ply2:EmitSound("physics/wood/wood_crate_impact_hard2.wav", 100, math.random(90, 110))
                        ply2:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
                    end
                },
            }

        if ply:canKeysLock(ent) then
            table.insert(tbl, {
                message = "Unlock",
                callback = function(ent2, ply2)
                    ent2:keysUnLock()
                    ent2:EmitSound("buttons/lever7.wav")
                end
            })

            table.insert(tbl, {
                message = "Lock",
                callback = function(ent2, ply2)
                    ent2:keysLock()
                    ent2:EmitSound("doors/door_latch1.wav")
                end
            })
        end

        return tbl
    elseif ent:IsPlayer() then
        if ent:isArrested() and !ply:isArrested() and ply:getJobTable().unarrest then
            return
            {
                {
                    callback = function(ent2, ply2)
                        if ent2:isArrested() and !ply2:isArrested() and ply:getJobTable().unarrest then
                            GAMEMODE.Config.telefromjail = false
                            ent2:unArrest(ply2)
                            GAMEMODE.Config.telefromjail = true
                        end
                    end,
                    message = "Unarrest"
                }
            }
        end
    end
end