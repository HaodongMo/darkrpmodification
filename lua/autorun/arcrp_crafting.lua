ArcRP_Craft = ArcRP_Craft or {}

ArcRP_Craft.Items = {
    ["steel"] = {
        name = "Steel",
        description = "",
        model = "models/mechanics/solid_steel/plank_4.mdl",
    },
    ["chemical"] = {
        name = "Chemicals",
        description = "",
        model = "models/props_junk/garbage_plasticbottle002a.mdl",
    },
    ["electronics"] = {
        name = "Electronics",
        description = "",
        model = "models/props_lab/reciever01d.mdl",
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
    ["fuel"] = {
        name = "Fuel",
        description = "",
        model = "models/props_junk/metalgascan.mdl",
    },
    ["fuze"] = {
        name = "Fuze",
        description = "",
        model = "models/props_c17/TrapPropeller_Lever.mdl",
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

    ["component"] = {
        name = "Component",
        description = "",
        model = "models/xqm/pistontype1.mdl",
    },
}
ArcRP_Craft.ItemsID = {}
ArcRP_Craft.ItemsBit = 32

local function generate_ents()
    local i = 1
    for k, v in pairs(ArcRP_Craft.Items) do
        v.ID = i
        ArcRP_Craft.ItemsID[i] = k
        i = i + 1

        local tbl = {}
        tbl.Base = "arcrp_ingredient"
        tbl.PrintName = v.name
        tbl.Spawnable = true
        tbl.Category = "ArcRP - Ingredients"
        tbl.craftingIngredient = k
        tbl.Model = v.model
        scripted_ents.Register(tbl, "arcrp_in_" .. k)
    end
    ArcRP_Craft.ItemsBit = math.min(math.ceil(math.log(i + 1, 2)), 32)
end

generate_ents()
hook.Add("InitPostEntity", "ArcRP_GenerateIngredients", generate_ents)


ArcRP_Craft.Recipes = {
    civil = {
        {
            name = "Component",
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
        {
            name = "Advanced Electronics",
            ingredients = {
                electronics = 2,
                screw = 1,
            },
            time = 10,
            output = {
                "arcrp_in_adv_electronics"
            }
        },
        {
            name = "Printer Capacity Upgrade",
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
        {
            name = "Printer Efficiency Upgrade",
            ingredients = {
                adv_electronics = 2,
                component = 1,
            },
            time = 15,
            output = {
                "arcrp_up_printer_efficiency"
            }
        },
        {
            name = "Printer Speed Upgrade",
            ingredients = {
                adv_electronics = 2,
                electronics = 1,
            },
            time = 15,
            output = {
                "arcrp_up_printer_speed"
            }
        },
        {
            name = "Generator Capacity Upgrade",
            ingredients = {
                component = 1,
                steel = 2
            },
            time = 30,
            output = {
                "arcrp_up_generator_cap"
            }
        },
        {
            name = "Generator Connections Upgrade",
            ingredients = {
                component = 1,
                electronics = 1,
            },
            time = 30,
            output = {
                "arcrp_up_generator_conn"
            }
        },
    },
    bombs = {
        {
            name = "Component",
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
        {
            name = "Explosive Filler",
            ingredients = {
                fuel = 1,
                chemicals = 1,
            },
            output = {
                "arcrp_in_explosive"
            }
        },
        {
            name = "Fuze",
            ingredients = {
                electronics = 1,
                wood = 1,
            },
            output = {
                "arcrp_in_fuze"
            }
        },
        {
            name = "Frag Grenade",
            ingredients = {
                fuze = 1,
                explosive = 1,
            },
            output = {
                "tacrp_ammo_frag"
            }
        },
        {
            name = "C4 Charge",
            ingredients = {
                electronics = 1,
                explosive = 2,
            },
            output = {
                "tacrp_ammo_c4"
            }
        },
        {
            name = "Breaching Charge",
            ingredients = {
                electronics = 1,
                explosive = 1,
            },
            output = {
                "tacrp_ammo_charge"
            }
        },
        {
            name = "Flashbang",
            ingredients = {
                fuze = 1,
                paper = 1,
            },
            output = {
                "tacrp_ammo_flashbang"
            }
        },
        {
            name = "Thermite Grenade",
            ingredients = {
                fuze = 1,
                screw = 1,
                fuel = 1,
            },
            output = {
                "tacrp_ammo_fire"
            }
        },
        {
            name = "Smoke Grenade",
            ingredients = {
                fuze = 1,
                fuel = 1,
            },
            output = {
                "tacrp_ammo_smoke"
            }
        },
        {
            name = "Gas Grenade",
            ingredients = {
                fuze = 1,
                chemicals = 1,
            },
            output = {
                "tacrp_ammo_gas"
            }
        },
    },
    guns = {
        {
            name = "Component",
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
        {
            name = "Assault Rifle",
            ingredients = {
                component = 3
            },
            output = {
                "tacrp_ex_ak47",
                "tacrp_amd65",
                "tacrp_ex_m4a1",
                "tacrp_k1a",
                "tacrp_m4",
                "tacrp_ak47",
                "tacrp_g36k",
                "tacrp_sg551",
                "tacrp_aug",
                "tacrp_dsa58",
                "tacrp_hk417",
                "tacrp_mg4"
            }
        },
        {
            name = "Grenade Launcher",
            ingredients = {
                explosive = 1,
                component = 1,
                pipe = 1,
            },
            output = {
                "tacrp_m320"
            }
        },
        {
            name = "Rocket Launcher",
            ingredients = {
                component = 2,
                explosive = 1,
            },
            output = {
                "tacrp_rpg7"
            }
        },
        {
            name = "Sniper Rifle",
            ingredients = {
                component = 2,
                electronics = 1
            },
            output = {
                "tacrp_m14",
                "tacrp_ex_hecate",
                "tacrp_as50",
                "tacrp_uratio",
                "tacrp_spr"
            }
        },
        {
            name = "SMG",
            ingredients = {
                component = 2,
                pipe = 1,
            },
            output = {
                "tacrp_skorpion",
                "tacrp_ex_mac10",
                "tacrp_uzi",
                "tacrp_ex_mp9",
                "tacrp_p90",
                "tacrp_mp5",
                "tacrp_mp7",
                "tacrp_ex_ump45",
                "tacrp_pdw",
                "tacrp_superv"
            }
        },
        {
            name = "Shotgun",
            ingredients = {
                component = 2,
                steel = 1,
            },
            output = {
                "tacrp_m4star10",
                "tacrp_fp6",
                "tacrp_ks23",
                "tacrp_bekas",
                "tacrp_tgs12"
            }
        },
        {
            name = "Pistol",
            ingredients = {
                component = 1,
                pipe = 1,
            },
            output = {
                "tacrp_vertec",
                "tacrp_ex_m1911",
                "tacrp_ex_glock",
                "tacrp_ex_hk45c",
                "tacrp_p2000",
                "tacrp_ex_usp",
                "tacrp_gsr1911",
                "tacrp_p250",
                "tacrp_mr96",
                "tacrp_mtx_dual",
                "tacrp_sphinx",
                "tacrp_xd45"
            }
        },
        {
            name = "C4 Detonator",
            ingredients = {
                electronics = 1,
            },
            output = {
                "tacrp_c4_detonator"
            }
        },
    }
}