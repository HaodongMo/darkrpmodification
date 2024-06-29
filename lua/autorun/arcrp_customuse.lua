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
            return downed_ply:Nick()
        end
    end
end

local function checkhealth(victim, attacker)
    local msg = "fine"
    local perc = victim:Health() / victim:GetMaxHealth()

    if perc >= 1.0 then
        msg = "perfectly fine"
    elseif perc >= 0.9 then
        msg = "mostly fine"
    elseif perc >= 0.8 then
        msg = "hurt"
    elseif perc >= 0.7 then
        msg = "slightly injured"
    elseif perc >= 0.6 then
        msg = "somewhat injured"
    elseif perc >= 0.5 then
        msg = "injured"
    elseif perc >= 0.4 then
        msg = "badly injured"
    elseif perc >= 0.3 then
        msg = "very badly injured"
    elseif perc >= 0.2 then
        msg = "severely injured"
    elseif perc >= 0.1 then
        msg = "critically injured"
    else
        msg = "near death"
    end

    DarkRP.notify(attacker, 0, 3, victim:Nick() .. " is " .. msg .. ".")
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
        local tbl = {}

        table.insert(tbl, {
            interacttime = 1,
            callback = checkhealth,
            message = "Check Health"
        })

        if ent:isArrested() and not ply:isArrested() and ply:getJobTable().unarrest then
            table.insert(tbl,
            {
                callback = function(ent2, ply2)
                    if ent2:isArrested() and !ply2:isArrested() and ply:getJobTable().unarrest then
                        GAMEMODE.Config.telefromjail = false
                        ent2:unArrest(ply2)
                        GAMEMODE.Config.telefromjail = true
                    end
                end,
                interacttime = 1,
                message = "Unarrest"
            })
        end

        return tbl
    elseif ent:GetClass() == "prop_ragdoll" then
        local downed_ply = ent:GetNWBool("IMDE_IsRagdoll", false) and ent:GetOwner() or ent

        if IsValid(downed_ply) and downed_ply:IsPlayer() then
            if downed_ply == ply then return end
            local tbl = {}

            table.insert(tbl,
                {
                    interacttime = 1,
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                        checkhealth(victim, attacker)
                    end,
                    message = "Check Health"
                }
            )

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

            if ply:isCP() then
                table.insert(tbl, {
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                        if attacker:isCP() then
                            victim:arrest(GAMEMODE.Config.jailtimer, attacker)
                        end
                    end,
                    interacttime = 1,
                    message = "Arrest"
                })
            end

            table.insert(tbl, {
                callback = function(ent2, attacker)
                    local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                    local amount = ArcRP_DoDropWeapon( victim, nil, attacker )

                    if amount > 0 then
                        DarkRP.notify(attacker, 3, 5, "You've taken " .. tostring(amount) .. " weapons from " .. victim:Nick() .. "!")
                        DarkRP.notify(victim, 1, 5, attacker:Nick() .. " has stolen your weapons!")
                    else
                        DarkRP.notify(attacker, 3, 5, victim:Nick() .. " has no weapons you can take!")
                    end
                end,
                interacttime = 5,
                message = "Strip Weapons"
            })

            if ply:getJobTable().canMug then
                table.insert(tbl, {
                    interacttime = 5,
                    callback = function(ent2, attacker)
                        local victim = ent2:GetNWBool("IMDE_IsRagdoll", false) and ent2:GetOwner() or ent2
                        if attacker:getJobTable().canMug and !victim:isCP() then
                            local nextMugTime = victim:GetNW2Float("NextCanBeMuggedTime", 0)

                            if nextMugTime > CurTime() or victim:getDarkRPVar("money") <= 0 then
                                DarkRP.notify(attacker, 1, 3, "The victim's wallet is empty!")
                                return
                            end

                            local money = ArcRP_GetMoneyDropAmount(victim)

                            victim:addMoney(-money)
                            attacker:addMoney(money)

                            DarkRP.notify(attacker, 3, 5, "You've stolen " .. DarkRP.formatMoney(money) .. " from " .. victim:Nick() .. "!")
                            DarkRP.notify(victim, 1, 5, attacker:Nick() .. " has stolen " .. DarkRP.formatMoney(money) .. " from you!")

                            victim:SetNW2Float("NextCanBeMuggedTime", CurTime() + Lerp((player.GetCount() - 5) / 20, 300, 600))
                        end
                    end,
                    message = "Mug for Money"
                })
            end

            return tbl
        elseif ent:GetNWBool("IMDE_IsRagdoll") then
            local tbl = {}
            if ent:GetNW2Int("AGINV_ContainerID", 0) > 0 then
                table.insert(tbl, {
                    callback = function(ent2, attacker)
                        local con = AGINV.GetContainer(ent:GetNW2Int("AGINV_ContainerID", 0))
                        if con then
                            con:Sync(attacker)
                            net.Start("aginv_container_open")
                                net.WriteUInt(ent:GetNW2Int("AGINV_ContainerID", 0), AGINV_B_CON)
                                net.WriteBool(true)
                            net.Send(attacker)
                        end
                    end,
                    interacttime = 3,
                    message = "Loot Body"
                })
            end

            table.insert(tbl, {
                callback = function(body, investigator)
                    local hintnum = 6
                    local roll = body.DeathRoll or math.random(1, hintnum)

                    if roll == 1 then
                        -- Name
                        DarkRP.notify(investigator, 0, 3, "The victim was named " .. body.DeathInfo.name .. ".")
                    elseif roll == 2 then
                        DarkRP.notify(investigator, 0, 3, "The fatal blow was dealt by a " .. body.DeathInfo.weaponname .. ".")
                    elseif roll == 3 then
                        local killer =  body.DeathInfo.killer
                        local killer_has_license = IsValid(killer) and killer:getDarkRPVar("HasGunlicense")

                        if killer_has_license then
                            DarkRP.notify(investigator, 0, 3, "It is clear that the killer was " .. killer:Nick() .. ".")
                        elseif !IsValid(killer) then
                            DarkRP.notify(investigator, 0, 3, "It is clear that the killer was " .. body.DeathInfo.killername .. ".")
                        else
                            DarkRP.notify(investigator, 0, 3, "The killer was not licensed to carry.")
                        end
                    elseif roll == 4 then
                        local dist = math.Round(body.DeathInfo.dist * 0.0254)

                        DarkRP.notify(investigator, 0, 3, "The killer was about " .. tostring(dist) .. " meters away from the victim.")
                    elseif roll == 5 then
                        local time = math.Round(CurTime() - body.DeathInfo.dietime, 0)

                        if time > 60 then
                            time = math.Round(time / 60)
                            DarkRP.notify(investigator, 0, 3, "The victim died " .. tostring(time) .. " minute(s) ago.")
                        else
                            DarkRP.notify(investigator, 0, 3, "The victim died " .. tostring(time) .. " seconds ago.")
                        end
                    elseif roll == 6 then
                        DarkRP.notify(investigator, 0, 3, "The victim was killed by a " .. body.DeathInfo.killerjob .. ".")
                    end

                    roll = roll + 1
                    if roll > hintnum then
                        roll = 1
                    end

                    body.DeathRoll = roll
                end,
                interacttime = 1,
                message = "Investigate"
            })

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