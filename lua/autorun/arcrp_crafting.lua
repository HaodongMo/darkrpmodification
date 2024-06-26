ArcRP_Craft = ArcRP_Craft or {}

ArcRP_Craft.Items = {
    // Basic ingredients
    ["steel"] = {
        name = "Steel",
        description = "",
        model = "models/mechanics/solid_steel/plank_4.mdl",
    },
    ["chemicals"] = {
        name = "Chemicals",
        description = "",
        model = "models/props_junk/garbage_plasticbottle002a.mdl",
    },
    ["electronics"] = {
        name = "Electronics",
        description = "",
        model = "models/props_lab/reciever01d.mdl",
    },
    ["fuel"] = {
        name = "Fuel",
        description = "",
        model = "models/props_junk/metalgascan.mdl",
    },
    ["gear"] = {
        name = "Gear",
        description = "",
        model = "models/props_phx/gears/spur9.mdl",
    },
    ["screw"] = {
        name = "Screws",
        description = "",
        model = "models/props_lab/box01a.mdl",
    },
    ["paper"] = {
        name = "Paper",
        description = "",
        model = "models/props/cs_office/Paper_towels.mdl",
    },
    ["pipe"] = {
        name = "Pipe",
        description = "",
        model = "models/props_pipes/pipe01_straight01_short.mdl",
    },
    ["wood"] = {
        name = "Wood",
        description = "",
        model = "models/props_junk/wood_pallet001a_chunkb2.mdl",
    },

    // Crafted ingredients
    ["component"] = {
        name = "Component",
        description = "",
        model = "models/xqm/pistontype1.mdl",
    },
    ["adv_electronics"] = {
        name = "Advanced Electronics",
        description = "",
        model = "models/props_lab/reciever01a.mdl",
    },
    ["explosive"] = {
        name = "Explosives",
        description = "",
        model = "models/props_junk/metal_paintcan001a.mdl",
    },
    ["fuze"] = {
        name = "Fuze",
        description = "",
        model = "models/props_c17/TrapPropeller_Lever.mdl",
    },
    ["receiver"] = {
        name = "Receiver",
        description = "",
        model = "models/maxofs2d/button_slider.mdl",
    },

    // Drugs
    ["medishot"] = {
        name = "Medi-Shot",
        donotgenerate = true,
    },
    ["adrenalin"] = {
        name = "Adrenaline",
        donotgenerate = true,
    },
    ["mutant"] = {
        name = "Mutant",
        donotgenerate = true,
    },
    ["crocodile"] = {
        name = "Crocodile",
        donotgenerate = true,
    },
    ["rebound"] = {
        name = "Rebound",
        donotgenerate = true,
    },
    ["troil"] = {
        name = "Troil",
        donotgenerate = true,
    },
}
ArcRP_Craft.ItemsID = {}
ArcRP_Craft.ItemsBit = 32

ArcRP_Craft.Upgrades = {
    ["generator_cap"] = {
        name = "Generator Capacity Upgrade",
        model = "models/props_junk/PropaneCanister001a.mdl"
    },
    ["generator_conn"] = {
        name = "Generator Connection Upgrade",
        model = "models/props_junk/PropaneCanister001a.mdl"
    },
    ["printer_cap"] = {
        name = "Printer Capacity Upgrade",
        model = "models/props/cs_office/computer_caseb_p9a.mdl"
    },
    ["printer_efficiency"] = {
        name = "Printer Efficiency Upgrade",
        model = "models/props/cs_office/computer_caseb_p3a.mdl"
    },
    ["printer_speed"] = {
        name = "Printer Speed Upgrade",
        model = "models/props/cs_office/computer_caseb_p2a.mdl"
    },
    ["crafter_auto"] = {
        name = "Autolathe SelfCycle Upgrade",
        model = "models/props_lab/partsbin01.mdl"
    },
    ["crafter_eco"] = {
        name = "Autolathe ConrCttr Upgrade",
        model = "models/props_lab/partsbin01.mdl"
    },
    ["crafter_speed"] = {
        name = "Autolathe TurboGear Upgrade",
        model = "models/props_lab/partsbin01.mdl"
    },
    ["crafter_capacity"] = {
        name = "Autolathe BigBins Upgrade",
        model = "models/props_lab/partsbin01.mdl"
    },
    ["crafter_rarity"] = {
        name = "Autolathe XpertCraft Upgrade",
        model = "models/props_lab/partsbin01.mdl"
    },
}

local function generate_ents()
    local i = 1
    for k, v in pairs(ArcRP_Craft.Items) do
        v.ID = i
        ArcRP_Craft.ItemsID[i] = k
        i = i + 1

        if !v.donotgenerate then
            local tbl = {}
            tbl.Base = "arcrp_ingredient"
            tbl.PrintName = v.name
            tbl.Spawnable = true
            tbl.Category = "ArcRP - Ingredients"
            tbl.craftingIngredient = k
            tbl.Model = v.model
            scripted_ents.Register(tbl, "arcrp_in_" .. k)
        end
    end
    ArcRP_Craft.ItemsBit = math.min(math.ceil(math.log(i + 1, 2)), 32)

    for k, v in pairs(ArcRP_Craft.Upgrades) do
        v.ID = i
        ArcRP_Craft.ItemsID[i] = k
        i = i + 1

        local tbl = {}
        tbl.Base = "arcrp_upgrade"
        tbl.PrintName = v.name
        tbl.Spawnable = true
        tbl.Category = "ArcRP - Machine Upgrades"
        tbl.isUpgrade = true
        tbl.upgradeType = k
        tbl.Model = v.model
        scripted_ents.Register(tbl, "arcrp_up_" .. k)
    end
end

generate_ents()
hook.Add("InitPostEntity", "ArcRP_GenerateIngredients", generate_ents)


ArcRP_Craft.Recipes = {
    civil = {
        {   name = "Component",
            ingredients = {
                gear = 1,
                steel = 1,
                screw = 1,
            },
            time = 5,
            output = {
                "arcrp_in_component"
            }
        },
        {   name = "Advanced Electronics",
            ingredients = {
                electronics = 2,
                screw = 1,
            },
            time = 10,
            output = {
                "arcrp_in_adv_electronics"
            }
        },
        {   name = "Blunt Melee",
            ingredients = {
                wood = 2,
                pipe = 1,
            },
            time = 30,
            output = {
                "tacrp_m_crowbar",
                "tacrp_m_pan",
                "tacrp_m_hamma",
                "tacrp_m_pipe",
                "tacrp_m_bat",
                "tacrp_m_wrench",
                "tacrp_m_tonfa",
                "tacrp_m_shovel",
            },
            output_rare = {
                "tacrp_m_wiimote"
            },
            rare_chance = 0.05,
        },
        {   name = "Sharp Melee",
            ingredients = {
                wood = 2,
                steel = 1,
            },
            time = 30,
            output = {
                "tacrp_m_bamaslama",
                "tacrp_m_rambo",
                "tacrp_m_boina",
                "tacrp_m_harpoon",
                "tacrp_knife",
                "tacrp_m_gerber",
                "tacrp_m_glock",
                "tacrp_knife2",
                "tacrp_m_kitchen",
                "tacrp_m_kukri",
                "tacrp_m_bayonet",
                "tacrp_m_machete",
                "tacrp_m_cleaver",
                "tacrp_m_fasthawk",
                "tacrp_m_knife3",
                "tacrp_m_css",
                "tacrp_m_tracker",
                "tacrp_m_incorp",
            },
            output_rare = {
                "tacrp_m_heathawk"
            },
            rare_chance = 0.05,
        },
        {   name = "Printer Capacity Upgrade",
            ingredients = {
                component = 1,
                adv_electronics = 1,
                pipe = 1
            },
            time = 15,
            output = {
                "arcrp_up_printer_cap"
            }
        },
        {   name = "Printer Efficiency Upgrade",
            ingredients = {
                adv_electronics = 2,
                component = 1,
            },
            time = 15,
            output = {
                "arcrp_up_printer_efficiency"
            }
        },
        {   name = "Printer Speed Upgrade",
            ingredients = {
                adv_electronics = 2,
                electronics = 1,
            },
            time = 15,
            output = {
                "arcrp_up_printer_speed"
            }
        },
        {   name = "Generator Capacity Upgrade",
            ingredients = {
                component = 1,
                steel = 2
            },
            time = 30,
            output = {
                "arcrp_up_generator_cap"
            }
        },
        {   name = "Generator Connections Upgrade",
            ingredients = {
                component = 1,
                electronics = 1,
            },
            time = 30,
            output = {
                "arcrp_up_generator_conn"
            }
        },
        {   name = "Autolathe SelfCycle Upgrade",
            ingredients = {
                gear = 1,
                pipe = 1,
            },
            time = 120,
            output = {
                "arcrp_up_crafter_auto"
            }
        },
        {   name = "Autolathe BigBins Upgrade",
            ingredients = {
                wood = 1,
                steel = 1,
                pipe = 1,
            },
            time = 120,
            output = {
                "arcrp_up_crafter_auto"
            }
        },
        {   name = "Autolathe ConrCttr Upgrade",
            ingredients = {
                adv_electronics = 1,
                component = 1,
                chemicals = 1,
            },
            time = 300,
            output = {
                "arcrp_up_crafter_eco"
            }
        },
        {   name = "Autolathe TurboGear Upgrade",
            ingredients = {
                gear = 2,
                adv_electronics = 1,
            },
            time = 300,
            output = {
                "arcrp_up_crafter_speed"
            }
        },
    },
    drugs = {
        {
            name = "Mutant",
            ingredients = {
                crocodile = 1,
                adrenalin = 1,
                chemical = 1,
            },
            time = 30
        },
        {
            name = "Crocodile",
            ingredients = {
                fuel = 1,
                medishot = 1,
            },
            time = 30
        },
        {
            name = "Rebound",
            ingredients = {
                chemical = 1,
                medishot = 1,
            },
            time = 30
        },
        {
            name = "Adrenalin",
            ingredients = {
                chemical = 1,
                paper = 1,
            },
            time = 30
        },
        {
            name = "Medi-shot",
            ingredients = {
                chemical = 1,
            },
            time = 30
        },
        {
            name = "Troil",
            ingredients = {
                fuel = 1,
            },
            time = 30
        },
    },
    bombs = {
        {   name = "Component",
            ingredients = {
                gear = 1,
                steel = 1,
                screw = 1,
            },
            time = 10,
            output = {
                "arcrp_in_component"
            }
        },
        {   name = "Explosives",
            ingredients = {
                fuel = 1,
                chemicals = 1,
            },
            time = 10,
            output = {
                "arcrp_in_explosive"
            }
        },
        {   name = "Fuze",
            ingredients = {
                electronics = 1,
                wood = 1,
            },
            time = 3,
            output = {
                "arcrp_in_fuze"
            }
        },
        {   name = "Frag Grenade",
            ingredients = {
                fuze = 1,
                explosive = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_frag"
            }
        },
        {   name = "C4 Charge",
            ingredients = {
                electronics = 1,
                explosive = 2,
            },
            time = 20,
            output = {
                "tacrp_ammo_c4"
            }
        },
        {   name = "Breaching Charge",
            ingredients = {
                electronics = 1,
                explosive = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_charge"
            }
        },
        {   name = "Flashbang",
            ingredients = {
                fuze = 1,
                paper = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_flashbang"
            }
        },
        {   name = "Thermite Grenade",
            ingredients = {
                fuze = 1,
                screw = 1,
                fuel = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_fire"
            }
        },
        {   name = "Smoke Grenade",
            ingredients = {
                fuze = 1,
                fuel = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_smoke"
            }
        },
        {   name = "Gas Grenade",
            ingredients = {
                fuze = 1,
                chemicals = 1,
            },
            time = 10,
            output = {
                "tacrp_ammo_gas"
            }
        },
    },
    guns = {
        {   name = "Component",
            ingredients = {
                gear = 1,
                steel = 1,
                screw = 1,
            },
            time = 10,
            output = {
                "arcrp_in_component"
            }
        },
        {   name = "Receiver",
            ingredients = {
                component = 1,
                chemicals = 1,
            },
            time = 15,
            output = {
                "arcrp_in_receiver"
            }
        },
        {   name = "Sidearm",
            ingredients = {
                component = 1,
                pipe = 1,
            },
            time = 15,
            output = {
                "tacrp_vertec",
                "tacrp_ex_m1911",
                "tacrp_ex_glock",
                "tacrp_p2000",
                "tacrp_ex_usp",
                "tacrp_gsr1911",

                "tacrp_p250",
                "tacrp_mr96",
                "tacrp_sphinx",
            },
            output_rare = {
                "tacrp_ex_hk45c",
                "tacrp_mtx_dual",
                "tacrp_xd45"
            },
            rare_chance = 0.1,
        },
        {   name = "Sporter",
            ingredients = {
                component = 1,
                wood = 1,
            },
            time = 20,
            output = {
                "tacrp_civ_p90",
                "tacrp_civ_mp5",
                "tacrp_m1",
            },
            output_rare = {
                "tacrp_ar15",
                "tacrp_civ_g36k",
            },
            rare_chance = 0.2,
        },
        {   name = "SMG",
            ingredients = {
                component = 2,
                pipe = 1,
            },
            time = 30,
            output = {
                "tacrp_skorpion",
                "tacrp_ex_mac10",
                "tacrp_mp5",
                "tacrp_ex_ump45",
                "tacrp_skorpion",
                "tacrp_ex_mac10",
                "tacrp_mp5",
                "tacrp_ex_ump45",

                "tacrp_uzi",
                "tacrp_mp7",
                "tacrp_ex_mp9",
                "tacrp_p90",
            },
            output_rare = {
                "tacrp_pdw",
                "tacrp_superv",
            },
            rare_chance = 0.1,
        },
        {   name = "Light Rifle",
            ingredients = {
                component = 2,
                receiver = 1,
            },
            time = 60,
            output = {
                "tacrp_ex_m4a1",
                "tacrp_k1a",
                "tacrp_m4",
                "tacrp_ak47",
                "tacrp_g36k",
                "tacrp_aug",
            },
            output_rare = {
                "tacrp_sg551",
            },
            rare_chance = 0.1,
        },
        {   name = "Heavy Rifle",
            ingredients = {
                component = 1,
                receiver = 1,
                pipe = 1,
            },
            time = 90,
            output = {
                "tacrp_ex_ak47",
                "tacrp_amd65",
                "tacrp_dsa58",
            },
            output_rare = {
                "tacrp_hk417",
            },
            rare_chance = 0.1,
        },
        { name = "Shotgun",
            ingredients = {
                component = 2,
                steel = 1,
            },
            output = {
                "tacrp_fp6",
                "tacrp_bekas",
                "tacrp_tgs12"
            },
            output_rare = {
                "tacrp_m4star10",
                "tacrp_ks23",
            },
            rare_chance = 0.2,
        },
        {   name = "Sniper Rifle",
            ingredients = {
                receiver = 1,
                component = 1,
                electronics = 1
            },
            time = 90,
            output = {
                "tacrp_m14",
                "tacrp_ex_hecate",
                "tacrp_uratio",
                "tacrp_spr",
            },
            output_rare = {
                "tacrp_as50",
            },
            rare_chance = 0.1,
        },
        {   name = "Grenade Launcher",
            ingredients = {
                explosive = 1,
                component = 1,
                pipe = 1,
            },
            time = 60,
            output = {
                "tacrp_m320"
            }
        },
        {   name = "Rocket Launcher",
            ingredients = {
                receiver = 1,
                wood = 1,
                explosive = 1,
            },
            time = 150,
            output = {
                "tacrp_rpg7"
            }
        },
        {   name = "Machine Gun",
            ingredients = {
                receiver = 2,
                adv_electronics = 1,
            },
            time = 180,
            output = {
                "tacrp_mg4"
            }
        },
        {   name = "C4 Detonator",
            ingredients = {
                electronics = 1,
            },
            time = 5,
            output = {
                "tacrp_c4_detonator"
            }
        },
    }
}