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
    elseif ent:GetClass() == "prop_ragdoll" then
        local downed_ply = ent:GetNWBool("IMDE_IsRagdoll", false) and ent:GetOwner() or ent

        if not(IsValid(downed_ply) and downed_ply:IsPlayer()) then return end
        if downed_ply == ply then return end

        if downed_ply:Health() <= 1 then
            return downed_ply:Nick() .. " | CRITICAL"
        else
            return downed_ply:Nick() .. " | " .. downed_ply:Health() .. "HP"
        end
    end
end

function ArcRP_GetCustomContextMenu(ent, ply)
    if not ply:Alive() then return end

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
    elseif ent:GetClass() == "prop_ragdoll" then
        local downed_ply = ent:GetNWBool("IMDE_IsRagdoll", false) and ent:GetOwner() or ent

        if IsValid(downed_ply) and downed_ply:IsPlayer() then
            if downed_ply == ply then return end
            local tbl = {}

            if ply:isCP() then
                table.insert(tbl, {
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                        if attacker:isCP() then
                            victim:arrest(GAMEMODE.Config.jailtimer, attacker)
                        end
                    end,
                    message = "Arrest"
                })
            end

            table.insert(tbl, {
                callback = function(ent2, attacker)
                    local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                    local amount = ArcRP_DoDropWeapon( victim, nil, attacker )

                    if amount > 0 then
                        DarkRP.notify(attacker, 3, 5, "You've taken " .. tostring(amount) .. " weapons from " .. victim:Nick() .. "!")
                        DarkRP.notify(victim, 1, 5, attacker:Nick() .. " has stolen your weapons")
                    else
                        DarkRP.notify(attacker, 3, 5, victim:Nick() .. " has no weapons you can take!")
                    end
                end,
                interacttime = 1,
                message = "Disarm"
            })

            if ply:getJobTable().canHelpCritical or downed_ply:Health() > 1 then
                local msg = "Help Up"
                local time = 5
                if downed_ply:Health() <= 1 then
                    msg = "Resuscitate"
                elseif ply:getJobTable().canHelpCritical then
                    time = 1
                end
                table.insert(tbl, {
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2

                        victim:IMDE_SetBalance(victim:IMDE_GetMaxBalance() * 0.5)
                        victim:IMDE_MakeConscious()
                        victim:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0)

                        DarkRP.notify(attacker, 0, 5, "You've helped " .. victim:Nick() .. " up!")
                        DarkRP.notify(victim, 0, 5, attacker:Nick() .. " has helped you up!")
                    end,
                    interacttime = time,
                    message = msg
                })
            end

            if ply:getJobTable().canMug then
                table.insert(tbl, {
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                        if attacker:getJobTable().canMug then
                            local nextMugTime = victim.NextCanBeMuggedTime or 0

                            if nextMugTime > CurTime() or victim:getDarkRPVar("money") <= 0 then
                                DarkRP.notify(attacker, 1, 3, "The victim's wallet is empty!")
                                return
                            end

                            local money = ArcRP_GetMoneyDropAmount(victim)

                            victim:addMoney(-money)
                            attacker:addMoney(money)

                            DarkRP.notify(attacker, 3, 5, "You've stolen " .. DarkRP.formatMoney(money) .. " from " .. victim:Nick() .. "!")
                            DarkRP.notify(victim, 1, 5, attacker:Nick() .. " has stolen " .. DarkRP.formatMoney(money) .. " from you!")

                            victim.NextCanBeMuggedTime = CurTime() + 300
                        end
                    end,
                    message = "Steal Money"
                })
            end

            return tbl
        end
    end
end

if SERVER then

util.AddNetworkString("arcrp_customuse")
util.AddNetworkString("arcrp_customusefinish")

net.Receive("arcrp_customusefinish", function(len, ply)
    local cancel = net.ReadBool()

    if cancel then
        ply.ArcRP_CustomContextEnt = nil
        ply.ArcRP_CustomContext = nil
    end

    local ent = ply.ArcRP_CustomContextEnt

    if !IsValid(ent) then return end

    if ent:GetPos():DistToSqr(ply:GetPos()) > 128 * 128 then return end
    if !ply:Alive() then return end

    local context = ply.ArcRP_CustomContext

    if CurTime() - ply.ArcRP_CustomUseStartTime >= (context.interacttime or 0) - 0.25 then -- if you have more than 250ms of fucking jitter you need to buy new internet
        context.callback(ent, ply)
        ply.ArcRP_CustomContextEnt = nil
        ply.ArcRP_CustomContext = nil
    end
end)

net.Receive("arcrp_customuse", function(len, ply)
    local ent = net.ReadEntity()
    local index = net.ReadUInt(8)

    if !IsValid(ent) then return end

    if ent:GetPos():DistToSqr(ply:GetPos()) > 128 * 128 then return end
    if !ply:Alive() then return end

    local context = ArcRP_GetCustomContextMenu(ent, ply)

    if !context then return end
    if !context[index] then return end
    if !context[index].callback then return end

    if (context[index].interacttime or 0) > 0 then
        ply.ArcRP_CustomUseStartTime = CurTime()
        ply.ArcRP_CustomContext = context[index]
        ply.ArcRP_CustomContextEnt = ent
    else
        context[index].callback(ent, ply)
        ply.ArcRP_CustomContextEnt = nil
        ply.ArcRP_CustomContext = nil
    end
end)

end