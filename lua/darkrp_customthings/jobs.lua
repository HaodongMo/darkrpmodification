--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

TEAM_POLICE_ROOKIE = DarkRP.createJob("Rookie", {
    color = Color(150, 150, 255, 255),
    model = {"models/player/phoenix.mdl"},
    description =
[[The lowest rung of law enforcement.

Has few real powers, and no gun.
Anyone taken down by police will be jailed.

Ask a Sergeant or the Sheriff for a promotion.]],
    command = "police_rookie",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Police",
    max = 0,
    sortOrder = 100,
    weapons = {"tacrp_m_tonfa"},
    unarrest = false,
})

TEAM_POLICE_DEPUTY = DarkRP.createJob("Deputy", {
    color = Color(50, 50, 200, 255),
    model = {"models/player/riot.mdl"},
    description =
[[Deputies are the backbone of the police force.
Sergeants and the Sheriff will need to approve your promotion.

Take down suspected criminals. You can also release prisoners from jail.

Report to a Sergeant or the Sheriff to have prisoners sentenced.]],
    command = "police_deputy",
    salary = GAMEMODE.Config.normalsalary * 1.5,
    NeedToChangeFrom = TEAM_POLICE_ROOKIE,
    admin = 0,
    category = "Police",
    max = 8,
    vote = false,
    RequiresVote = function(ply, job) return (#team.GetPlayers(TEAM_POLICE_SHERIFF) + #team.GetPlayers(TEAM_POLICE_SERGEANT)) > 0 end,
    ammo = {
        ["pistol"] = 60,
    },
    weapons = {"tacrp_vertec", "tacrp_m_tonfa"},
    hasLicense = true,
    sortOrder = 101,
    unarrest = true,
})

TEAM_POLICE_SERGEANT = DarkRP.createJob("Sergeant", {
    color = Color(25, 25, 170, 255),
    model = {"models/player/gasmask.mdl"},
    description =
[[Sergeants are the trusted leaders of the police force.
They are appointed by the Sheriff (Sheriff vote required if one exists).

Can promote rookies to Deputy.
Can issue arrest warrants (causing a player to always be jailed on death).
Can issue up to 20m of ban time (after a trial).

Use /givelicense {name} and /revokelicense {name} to give or revoke gun licenses.]],
    command = "police_sergeant",
    salary = GAMEMODE.Config.normalsalary * 2,
    NeedToChangeFrom = TEAM_POLICE_DEPUTY,
    admin = 0,
    category = "Police",
    max = 4,
    RequiresVote = function(ply, job) return (#team.GetPlayers(TEAM_POLICE_SHERIFF) + #team.GetPlayers(TEAM_POLICE_SERGEANT)) > 0 end,
    sortOrder = 102,
    ammo = {
        ["pistol"] = 60,
        ["buckshot"] = 32,
    },
    weapons = {"tacrp_vertec", "tacrp_fp6", "tacrp_m_tonfa"},
    hasLicense = true,
    giveLicense = true,
    warrant = true,
    ban_max_time = 20,
    unarrest = true,
})

TEAM_POLICE_SHERIFF = DarkRP.createJob("Sheriff", {
    color = Color(25, 25, 25, 255),
    model = {"models/player/breen.mdl"},
    description =
[[The chief of the police force.

Voted in by the sergeants.
Can promote deputies to Sergeant.
Can issue up to 1h of ban time (after a trial).

Use /givelicense {name} and /revokelicense {name} to give or revoke gun licenses.]],
    command = "police_sheriff",
    salary = GAMEMODE.Config.normalsalary * 3,
    NeedToChangeFrom = TEAM_POLICE_SERGEANT,
    admin = 0,
    category = "Police",
    chief = true,
    mayor = true,
    max = 1,
    vote = true,
    hasLicense = true,
    giveLicense = true,
    RequiresVote = function(ply, job) return (#team.GetPlayers(TEAM_POLICE_SHERIFF) + #team.GetPlayers(TEAM_POLICE_SERGEANT)) > 0 end,
    sortOrder = 103,
    ammo = {
        ["357"] = 60,
    },
    weapons = {"tacrp_mr96", "tacrp_m_tonfa"},
    warrant = true,
    ban_max_time = 60,
    unarrest = true,
})

TEAM_MEDIC = DarkRP.createJob("Medic", {
    color = Color(200, 200, 200, 255),
    model = {"models/player/kleiner.mdl"},
    description =
[[With your first aid kit, you can heal other players.]],
    command = "medic",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 3,
    sortOrder = 100,
    weapons = {"tacrp_medkit"},
})

TEAM_LOCKSMITH = DarkRP.createJob("Locksmith", {
    color = Color(200, 25, 25, 255),
    model = {"models/player/leet.mdl"},
    description =
[[Your lockpick can be used to break into buildings.]],
    command = "locksmith",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 2,
    sortOrder = 101,
    weapons = {"lockpick"},
})

TEAM_GUNSMITH = DarkRP.createJob("Gunsmith", {
    color = Color(25, 25, 200, 255),
    model = {"models/player/eli.mdl"},
    description =
[[You are able to modify weapons.]],
    command = "gunsmith",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 2,
    sortOrder = 102,
    gunsmith = true,
})

TEAM_LAWYER = DarkRP.createJob("Lawyer", {
    color = Color(100, 100, 100, 255),
    model = {"models/player/gman_high.mdl"},
    description =
[[Advocate for your clients.

Police MUST hear you out before sentencing a prisoner.]],
    command = "lawyer",
    salary = GAMEMODE.Config.normalsalary * 2,
    admin = 0,
    category = "Citizens",
    max = 3,
    sortOrder = 103,
})

TEAM_CRAFTSMAN = DarkRP.createJob("Craftsman", {
    color = Color(255, 175, 0, 255),
    model = {"models/player/hostage/hostage_04.mdl"},
    description =
[[You can buy factories to make random weapons and explosives.]],
    command = "craftsman",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 2,
    sortOrder = 104,
})

TEAM_COURIER = DarkRP.createJob("Courier", {
    color = Color(255, 225, 100, 255),
    model = {"models/player/hostage/hostage_03.mdl"},
    description =
[[You can hold a lot of items in your pockets. Make deliveries or sales.]],
    command = "courier",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    maxpocket  = 15,
    category = "Citizens",
    max = 3,
    sortOrder = 105,
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE_ROOKIE] = true,
    [TEAM_POLICE_DEPUTY] = true,
    [TEAM_POLICE_SERGEANT] = true,
    [TEAM_POLICE_SHERIFF] = true
}

DarkRP.createCategory{
    name = "Police",
    categorises = "jobs",
    startExpanded = true,
    color = Color(25, 25, 170, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

hook.Add("canUnarrest", "tacrp_police_unarrest", function(unarrester, unarrestee)
    local jobClass = unarrester:getJobTable()

    return jobClass.unarrest
end)

// arrest on kill by police
hook.Add("PlayerDeath", "tacrp_police_arrest", function(victim, inflictor, attacker)
    if (!victim:isCP() and attacker:isCP()) or victim:isWanted() then
        victim:arrest(300, attacker)
    else
        if victim:Team() != GAMEMODE.DefaultTeam then
            victim:teamBan(victim:Team(), 300)
            victim:changeTeam(GAMEMODE.DefaultTeam, true)
        end
    end
end)

GAMEMODE.AllowVoteRoles = {
    [TEAM_POLICE_DEPUTY] = {
        [TEAM_POLICE_SERGEANT] = true,
        [TEAM_POLICE_SHERIFF] = true,
    },
    [TEAM_POLICE_SERGEANT] = {
        [TEAM_POLICE_SHERIFF] = true,
    },
    [TEAM_POLICE_SHERIFF] = {
        [TEAM_POLICE_SERGEANT] = true,
        [TEAM_POLICE_DEPUTY] = true
    },
}


hook.Add("canVote", "tacrp_police_vote", function(ply, vote)
    if vote.votetype != "job" then return end

    local role = vote.info.targetTeam

    if allow_vote_roles then
        local ply_role = ply:Team()
        PrintTable(GAMEMODE.AllowVoteRoles)
        return GAMEMODE.AllowVoteRoles[role][ply_role] or false
    end
end)

function TacRP.CanCustomize(ply, wep, att, slot)
    if wep:GetValue("PrimaryMelee") then return true end

    return ply:getJobTable().gunsmith or false
end

// drop up to $5000 on death
hook.Add("PlayerDeath", "tacrp_drop_money", function(victim, inflictor, attacker)
    if attacker:isCP() then return end

    local money = victim:getDarkRPVar("money")

    if money > 5000 then
        money = 5000
    end

    victim:addMoney(-money)
    DarkRP.createMoneyBag(victim:GetPos() + Vector(0, 0, 10), money)
end)

hook.Add("canGiveLicense", "tacrp_police_license", function(giver, target)
    return giver:getJobTable().giveLicense or false
end)

hook.Add("canWanted", "tacrp_police_wanted", function(ply, target)
    return ply:getJobTable().warrant
end)

hook.Add("canUnarrest", "tacrp_police_unarrest", function(unarrester, unarrestee)
    return unarrester:getJobTable().unarrest
end)