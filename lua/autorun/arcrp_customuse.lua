-- ent = entity you are trying to customUse
-- ply = custom user

function ArcRP_GetCustomContextHint(ent, ply)
    if ent:isKeysOwnable() then
        local blocked = ent:getKeysNonOwnable()
        local doorTeams = ent:getKeysDoorTeams()
        local doorGroup = ent:getKeysDoorGroup()
        local playerOwned = ent:isKeysOwned() or table.GetFirstValue(ent:getKeysCoOwners() or {}) ~= nil
        local owned = playerOwned or doorGroup or doorTeams

        local text = ""

        local title = ent:getKeysTitle()
        if title then text = text .. title .. " | " end

        if owned then
            text = text .. "Owned by: "
        end

        if playerOwned then
            if ent:isKeysOwned() then
                text = text .. ent:getDoorOwner():Nick() end
            for k in pairs(ent:getKeysCoOwners() or {}) do
                local pk = Player(k)
                if not IsValid(pk) or not pk:IsPlayer() then continue end
                text = text .. ", " .. pk:Nick()
            end

            // local allowedCoOwn = ent:getKeysAllowedToOwn()
            // if allowedCoOwn and not fn.Null(allowedCoOwn) then
            //     table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

            //     for k in pairs(allowedCoOwn) do
            //         local pk = Player(k)
            //         if not IsValid(pk) or not pk:IsPlayer() then continue end
            //         doorInfo = doorInfo .. ", " .. pk:Nick()
            //     end
            // end
        elseif doorGroup then
            text = text .. doorGroup
        elseif doorTeams then
            local is_first = true
            for k, v in pairs(doorTeams) do
                if not v or not RPExtraTeams[k] then continue end

                if is_first then
                    text = text .. RPExtraTeams[k].name
                else
                    text = text .. ", " .. RPExtraTeams[k].name
                end
                is_first = false
            end
        elseif blocked and changeDoorAccess then
            text = "[F2] Allow Ownership"
        elseif not blocked then
            text = "[F2] Buy Door"
            if changeDoorAccess then
                text = "[F2] Disallow Ownership"
            end
        end

        return text
    end
end

function ArcRP_GetCustomContextMenu(ent, ply)
    if isfunction(ent.GetContextMenu) then
        return ent:GetContextMenu(ply)
    elseif ent:isKeysOwnable() then
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

if SERVER then

util.AddNetworkString("arcrp_customuse")

net.Receive("arcrp_customuse", function(len, ply)
    local index = net.ReadUInt(8)
    local ent = net.ReadEntity()

    if !IsValid(ent) then return end

    if ent:GetPos():Distance(ply:GetPos()) > 256 then return end

    local context = ArcRP_GetCustomContextMenu(ent, ply)

    if !context then return end
    if !context[index] then return end
    if !context[index].callback then return end

    context[index].callback(ent, ply)
end)

end