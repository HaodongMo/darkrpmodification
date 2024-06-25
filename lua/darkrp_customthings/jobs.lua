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
local function cploadout(ply, armor)
    if (armor or 0) > 0 then ply:SetArmor(armor) end
    for _, class in pairs(ply:getJobTable().weapons) do
        local wep = ply:GetWeapon(class)
        if not IsValid(wep) then continue end
        local installed = false
        for i, v in pairs(wep.Attachments or {}) do
            if v.Installed then continue end
            if v.Category == "melee_boost" then
                wep.Attachments[i].Installed = "melee_boost_shock"
                installed = true
                break
            elseif v.Category == "perk" or (istable(v.Category) and table.HasValue(v.Category, "perk")) then
                wep.Attachments[i].Installed = "perk_shock"
                installed = true
                break
            end
        end
        if installed then timer.Simple(0.5, function() if IsValid(wep) then wep:NetworkWeapon() end end) end
    end
end


TEAM_POLICE_ROOKIE = DarkRP.createJob("Rookie", {
    color = Color(150, 150, 255, 255),
    model = {"models/player/phoenix.mdl"},
    description =
[[The lowest rung of law enforcement.

Has few real powers, and no gun.
Use the police baton to knock criminals out, and then beat them until they comply.

Ask a Sergeant or the Sheriff for a promotion.]],
    command = "police_rookie",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Police",
    max = 0,
    sortOrder = 100,
    weapons = {"tacrp_m_tonfa", "weaponchecker"},
    unarrest = false,
    PlayerLoadout = function(ply)
        cploadout(ply, 0)
    end,
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
    weapons = {"tacrp_vertec", "tacrp_m_tonfa", "weaponchecker", "door_ram"},
    hasLicense = true,
    sortOrder = 101,
    unarrest = true,
    PlayerLoadout = function(ply)
        cploadout(ply, 50)
    end,
})

TEAM_POLICE_SERGEANT = DarkRP.createJob("Sergeant", {
    color = Color(25, 25, 170, 255),
    model = {"models/player/gasmask.mdl"},
    description =
[[Sergeants are the trusted leaders of the police force.
They are appointed by the Sheriff (Sheriff vote required if one exists).

Can promote rookies to Deputy.
Can issue arrest warrants (causing a player to always be jailed on death).

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
        ["buckshot"] = 16,
        ["smg1_grenade"] = 3,
        ["ti_gas"] = 1,
        ["ti_flashbang"] = 1,
    },
    weapons = {"tacrp_vertec", "tacrp_fp6", "tacrp_m_tonfa" , "tacrp_civ_m320", "weaponchecker", "door_ram"},
    hasLicense = true,
    giveLicense = true,
    warrant = true,
    ban_max_time = 20,
    unarrest = true,
    PlayerLoadout = function(ply)
        cploadout(ply, 50)
    end,
})

TEAM_POLICE_SHERIFF = DarkRP.createJob("Sheriff", {
    color = Color(25, 25, 25, 255),
    model = {"models/player/breen.mdl"},
    description =
[[The chief of the police force.

Voted in by the sergeants.
Can promote deputies to Sergeant.

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
        ["357"] = 36,
        ["smg1_grenade"] = 3,
        ["ti_gas"] = 2,
        ["ti_flashbang"] = 2,
        ["ti_breach"] = 1,
    },
    weapons = {"tacrp_mr96", "tacrp_m_tonfa", "tacrp_civ_m320", "weaponchecker", "door_ram"},
    warrant = true,
    ban_max_time = 60,
    unarrest = true,
    PlayerLoadout = function(ply)
        cploadout(ply, 100)
    end,
})

TEAM_POLICE_SUPERSOLDIER = DarkRP.createJob("SuperCop", {
    color = Color(155, 125, 255, 255),
    model = {"models/player/soldier_stripped.mdl"},
    description =
[[Experimental police ultra-tactical cyborg unit, for use in desperate times.

Admin only role. Hilariously overpowered.]],
    command = "police_robocop",
    salary = 0,
    admin = 1,
    category = "Police",
    max = 1,
    hasLicense = true,
    sortOrder = 103,
    ammo = {
        ["357"] = 60,
        ["ar2"] = 1000,
        ["pistol"] = 300,
        ["smg1_grenade"] = 20,
        ["ti_gas"] = 5,
        ["ti_flashbang"] = 5,
        ["ti_breach"] = 5,
    },
    weapons = {"tacrp_mtx_dual", "tacrp_mg4", "tacrp_m_tonfa", "tacrp_m320"},
    warrant = true,
    ban_max_time = 60,
    unarrest = true,
    PlayerLoadout = function(ply)
        ply:SetMaxHealth(500)
        ply:SetHealth(500)
        cploadout(ply, 100)
    end,
    giveLicense = true,
    gunsmith = true,
    martialArtist = true,
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
    color = Color(25, 155, 200, 255),
    model = {"models/player/eli.mdl"},
    description =
[[You are able to modify weapons for yourself or others.]],
    command = "gunsmith",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 2,
    sortOrder = 102,
    gunsmith = true,
    weapons = {}
})

TEAM_LAWYER = DarkRP.createJob("Lawyer", {
    color = Color(100, 100, 100, 255),
    model = {"models/player/gman_high.mdl"},
    description =
[[You are well versed in legal stuff that nobody else cares about.

File tax returns to help your clients get money back from the IRS.
Sell insurance that prevent money loss on death.
Free your clients from prison (with or without the police's consent).]],
    command = "lawyer",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 1,
    sortOrder = 103,
    unarrest = true,
    weapons = {}
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
    weapons = {}
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
    weapons = {}
})

TEAM_MARTIAL_ARTIST = DarkRP.createJob("Martial Artist", {
    color = Color(255, 125, 175, 255),
    model = {"models/player/alyx.mdl"},
    description =
[[You can equip special ability and boosts on melee weapons for yourself or others.]],
    command = "martial_artist",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    category = "Citizens",
    max = 1,
    sortOrder = 106,
    martialArtist = true,
    weapons = {}
})

TEAM_SHOPKEEPER = DarkRP.createJob("Shopkeeper", {
    color = Color(150, 255, 75, 255),
    model = {"models/player/hostage/hostage_03.mdl"},
    description =
[[You sell shipments of crafting materials to other players, like the Gunsmith and Craftsman.]],
    command = "shopkeeper",
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    maxpocket = 5,
    category = "Citizens",
    max = 2,
    sortOrder = 105,
    weapons = {}
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
    [TEAM_POLICE_SHERIFF] = true,
    [TEAM_POLICE_SUPERSOLDIER] = true,
}

DarkRP.createCategory{
    name = "Police",
    categorises = "jobs",
    startExpanded = true,
    color = Color(25, 25, 170, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

GAMEMODE.AllowVoteRoles = {
    [TEAM_POLICE_DEPUTY] = {
        [TEAM_POLICE_DEPUTY] = true,
        [TEAM_POLICE_SERGEANT] = true,
        [TEAM_POLICE_SHERIFF] = true,
    },
    [TEAM_POLICE_SERGEANT] = {
        [TEAM_POLICE_SERGEANT] = true,
        [TEAM_POLICE_SHERIFF] = true,
    },
    [TEAM_POLICE_SHERIFF] = {
        [TEAM_POLICE_SERGEANT] = true,
        [TEAM_POLICE_DEPUTY] = true
    },
}