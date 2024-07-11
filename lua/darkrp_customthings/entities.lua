--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

DarkRP.createEntity("Weapon Autolathe", {
    ent = "arcrp_crafter_guns",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 1000,
    max = 1,
    cmd = "buygunlab",
    allowed = {TEAM_GUNSMITH, TEAM_CRAFTSMAN},
    category = "Industrial Equipment"
})

DarkRP.createEntity("Civilian Autolathe", {
    ent = "arcrp_crafter_civil",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 500,
    max = 1,
    cmd = "buycivilianlab",
    allowed = TEAM_CRAFTSMAN,
    category = "Industrial Equipment"
})

DarkRP.createEntity("Explosives Autolathe", {
    ent = "arcrp_crafter_bombs",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 800,
    max = 1,
    cmd = "buybomblab",
    allowed = TEAM_CRAFTSMAN,
    category = "Industrial Equipment"
})

DarkRP.createEntity("The Instrument", {
    ent = "weapon_the_instrument",
    model = "models/props_lab/monitor01b.mdl",
    price = 125,
    max = 1,
    cmd = "buytheinstrument",
    category = "Hobby"
})

DarkRP.createEntity("Label Gun", {
    ent = "arcrp_label_gun",
    model = "models/weapons/w_pistol.mdl",
    price = 50,
    max = 1,
    cmd = "buylabelgun",
    category = "Appliances"
})

DarkRP.createEntity("Insurance", {
    ent = "arcrp_insurance",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buyinsurance",
    allowed = TEAM_LAWYER,
    category = "Legal Documents"
})

DarkRP.createEntity("Tax Return Forms", {
    ent = "arcrp_taxreturn",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buytaxreturn",
    allowed = TEAM_LAWYER,
    category = "Legal Documents"
})

DarkRP.createEntity("Bail Bonds", {
    ent = "arcrp_bailbonds",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buybail",
    allowed = TEAM_LAWYER,
    category = "Legal Documents"
})

DarkRP.createEntity("Money Printer", {
    ent = "arcrp_money_printer",
    model = "models/props_c17/consolebox05a.mdl",
    price = 600,
    max = 4,
    cmd = "buyprinter",
    category = "Appliances"
})

DarkRP.createEntity("Compact Generator", {
    ent = "arcrp_generator_compact",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    price = 600,
    max = 1,
    cmd = "buycompactgen",
    category = "Electrical Equipment"
})


DarkRP.createEntity("Generator", {
    ent = "arcrp_generator",
    model = "models/props_vehicles/generatortrailer01.mdl",
    price = 950,
    max = 1,
    cmd = "buygen",
    category = "Electrical Equipment"
})

DarkRP.createEntity("Microwave", {
    ent = "arcrp_microwave",
    model = "models/props/cs_office/microwave.mdl",
    price = 80,
    max = 1,
    cmd = "buymicrowave",
    category = "Appliances"
})

// Clothes

DarkRP.createEntity("Beanie (Black)", {
    ent = "fcs_item_p_beanie_black",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsbeanieblack",
    category = "Clothes"
})

DarkRP.createEntity("Beanie (Blue)", {
    ent = "fcs_item_p_beanie_blue",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsbeanieblue",
    category = "Clothes"
})


DarkRP.createEntity("Beanie (Gray)", {
    ent = "fcs_item_p_beanie_gray",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsbeaniegray",
    category = "Clothes"
})

DarkRP.createEntity("Beanie (Green)", {
    ent = "fcs_item_p_beanie_green",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsbeaniegreen",
    category = "Clothes"
})

DarkRP.createEntity("Jeans (Blue)", {
    ent = "fcs_item_p_citizen1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 60,
    max = 1,
    cmd = "buyfcscitizen1",
    category = "Clothes"
})

DarkRP.createEntity("Jeans (Gray)", {
    ent = "fcs_item_p_citizen2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 60,
    max = 1,
    cmd = "buyfcscitizen2",
    category = "Clothes"
})

DarkRP.createEntity("Jeans (Tan)", {
    ent = "fcs_item_p_medic",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 60,
    max = 1,
    cmd = "buyfcsmedic",
    category = "Clothes"
})

DarkRP.createEntity("Thick Jeans (Brown)", {
    ent = "fcs_item_p_beta1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 50,
    max = 1,
    cmd = "buyfcsbeta1",
    category = "Clothes"
})

DarkRP.createEntity("Thick Jeans (Gray)", {
    ent = "fcs_item_p_beta2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 50,
    max = 1,
    cmd = "buyfcsbeta2",
    category = "Clothes"
})  

DarkRP.createEntity("Cargo Pants (Khaki)", {
    ent = "fcs_item_p_eli",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 70,
    max = 1,
    cmd = "buyfcseli",
    category = "Clothes"
})  

DarkRP.createEntity("Cargo Pants (Blue)", {
    ent = "fcs_item_p_eli4",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 70,
    max = 1,
    cmd = "buyfcseli4",
    category = "Clothes"
})

DarkRP.createEntity("Cargo Pants (Gray)", {
    ent = "fcs_item_p_eli3",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 70,
    max = 1,
    cmd = "buyfcseli3",
    category = "Clothes"
})

DarkRP.createEntity("Cargo Pants (Green)", {
    ent = "fcs_item_p_eli2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 70,
    max = 1,
    cmd = "buyfcseli2",
    category = "Clothes"
})

DarkRP.createEntity("Overalls (Black)", {
    ent = "fcs_item_p_overalls2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 100,
    max = 1,
    cmd = "buyfcsoveralls2",
    category = "Clothes"
})

DarkRP.createEntity("Overalls (Blue)", {
    ent = "fcs_item_p_overalls1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 100,
    max = 1,
    cmd = "buyfcsoveralls1",
    category = "Clothes"
})

DarkRP.createEntity("Plated Jeans (Dark Blue)", {
    ent = "fcs_item_p_rebel2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 80,
    max = 1,
    cmd = "buyfcsrebel2",
    category = "Clothes"
})

DarkRP.createEntity("Plated Jeans (Blue)", {
    ent = "fcs_item_p_rebel1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 80,
    max = 1,
    cmd = "buyfcsrebel1",
    category = "Clothes"
})

DarkRP.createEntity("Security Pants", {
    ent = "fcs_item_p_sec",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 60,
    max = 1,
    cmd = "buyfcssec",
    category = "Clothes"
})

DarkRP.createEntity("Suit Pants (Black)", {
    ent = "fcs_item_p_blacksuit",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 150,
    max = 1,
    cmd = "buyfcsblacksuit",
    category = "Clothes"
})

DarkRP.createEntity("Suit Pants (Blue)", {
    ent = "fcs_item_p_admin3",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 150,
    max = 1,
    cmd = "buyfcsadmin3",
    category = "Clothes"
})

DarkRP.createEntity("Suit Pants (Brown)", {
    ent = "fcs_item_p_admin",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 150,
    max = 1,
    cmd = "buyfcsadmin",
    category = "Clothes"
})

DarkRP.createEntity("Suit Pants (Purple)", {
    ent = "fcs_item_p_admin2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 150,
    max = 1,
    cmd = "buyfcsadmin2",
    category = "Clothes"
})

DarkRP.createEntity("Surplus Pants", {
    ent = "fcs_item_p_surplus",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 40,
    max = 1,
    cmd = "buyfcssurplus",
    category = "Clothes"
})

DarkRP.createEntity("Bomber Jacket", {
    ent = "fcs_item_s_security_bomber",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 200,
    max = 1,
    cmd = "buyfcssbomber",
    category = "Clothes"
})

DarkRP.createEntity("Buttoned Shirt (Olive)", {
    ent = "fcs_item_s_refugee2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcssrefugee2",
    category = "Clothes"
})

DarkRP.createEntity("Buttoned Shirt (Tan)", {
    ent = "fcs_item_s_refugee1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcssrefugee1",
    category = "Clothes"
})

DarkRP.createEntity("Denim Jacket", {
    ent = "fcs_item_s_citizen1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 40,
    max = 1,
    cmd = "buyfcsscitizen1",
    category = "Clothes"
})

DarkRP.createEntity("Longsleeve Jacket", {
    ent = "fcs_item_s_citizen2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 30,
    max = 1,
    cmd = "buyfcsscitizen2",
    category = "Clothes"
})

DarkRP.createEntity("Dress Shirt (Blue)", {
    ent = "fcs_item_s_hostage1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsshostage1",
    category = "Clothes"
})

DarkRP.createEntity("Dress Shirt (White)", {
    ent = "fcs_item_s_hostage2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcsshostage2",
    category = "Clothes"
})

DarkRP.createEntity("Medic Shirt", {
    ent = "fcs_item_s_medic3",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcssmedic3",
    category = "Clothes"
})

DarkRP.createEntity("Ragged Shirt (Green)", {
    ent = "fcs_item_s_beta2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcssbeta2",
    category = "Clothes"
})

DarkRP.createEntity("Ragged Shirt (Pale)", {
    ent = "fcs_item_s_beta1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 20,
    max = 1,
    cmd = "buyfcssbeta1",
    category = "Clothes"
})

DarkRP.createEntity("Security Jacket", {
    ent = "fcs_item_s_security",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 90,
    max = 1,
    cmd = "buyfcsssecurity",
    category = "Clothes"
})

DarkRP.createEntity("Security Shirt", {
    ent = "fcs_item_s_sec",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 30,
    max = 1,
    cmd = "buyfcsssecurityshirt",
    category = "Clothes"
})

DarkRP.createEntity("Suit Jacket (Black)", {
    ent = "fcs_item_s_blacksuit",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 300,
    max = 1,
    cmd = "buyfcssblacksuit",
    category = "Clothes"
})

DarkRP.createEntity("Suit Jacket (Blue)", {
    ent = "fcs_item_s_admin3",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 300,
    max = 1,
    cmd = "buyfcssadmin3",
    category = "Clothes"
})

DarkRP.createEntity("Suit Jacket (Brown)", {
    ent = "fcs_item_s_admin",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 300,
    max = 1,
    cmd = "buyfcssadmin",
    category = "Clothes"
})

DarkRP.createEntity("Suit Jacket (Purple)", {
    ent = "fcs_item_s_admin2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 300,
    max = 1,
    cmd = "buyfcssadmin2",
    category = "Clothes"
})

DarkRP.createEntity("Surplus Jacket", {
    ent = "fcs_item_s_surplus",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 50,
    max = 1,
    cmd = "buyfcsssurplus",
    category = "Clothes"
})

DarkRP.createEntity("Trenchcoat (Black)", {
    ent = "fcs_item_s_trenchcoat_black",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 120,
    max = 1,
    cmd = "buyfcsstrenchcoat",
    category = "Clothes"
})

DarkRP.createEntity("Trenchcoat (Brown)", {
    ent = "fcs_item_s_trenchcoat_brown",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 120,
    max = 1,
    cmd = "buyfcsstrenchcoat2",
    category = "Clothes"
})

DarkRP.createEntity("Winter Coat (Brown)", {
    ent = "fcs_item_s_wintercoat2",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 110,
    max = 1,
    cmd = "buyfcsswintercoat2",
    category = "Clothes"
})

DarkRP.createEntity("Winter Coat (Green)", {
    ent = "fcs_item_s_wintercoat1",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 110,
    max = 1,
    cmd = "buyfcsswintercoat1",
    category = "Clothes"
})