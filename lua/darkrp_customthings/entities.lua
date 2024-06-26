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
    allowed = {TEAM_GUNSMITH, TEAM_CRAFTSMAN}
})

DarkRP.createEntity("Civilian Autolathe", {
    ent = "arcrp_crafter_civil",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 500,
    max = 1,
    cmd = "buycivilianlab",
    allowed = TEAM_CRAFTSMAN
})

DarkRP.createEntity("Explosives Autolathe", {
    ent = "arcrp_crafter_bombs",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 800,
    max = 1,
    cmd = "buybomblab",
    allowed = TEAM_CRAFTSMAN
})

DarkRP.createEntity("The Instrument", {
    ent = "weapon_the_instrument",
    model = "models/props_lab/monitor01b.mdl",
    price = 125,
    max = 1,
    cmd = "buytheinstrument",
})

DarkRP.createEntity("Insurance", {
    ent = "arcrp_insurance",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buyinsurance",
    allowed = TEAM_LAWYER
})

DarkRP.createEntity("Tax Return Forms", {
    ent = "arcrp_taxreturn",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buytaxreturn",
    allowed = TEAM_LAWYER
})

DarkRP.createEntity("Bail Bonds", {
    ent = "arcrp_bailbonds",
    model = "models/props_lab/clipboard.mdl",
    price = 100,
    max = 3,
    cmd = "buybail",
    allowed = TEAM_LAWYER
})

DarkRP.createEntity("Money Printer", {
    ent = "arcrp_money_printer",
    model = "models/props_c17/consolebox05a.mdl",
    price = 600,
    max = 4,
    cmd = "buyprinter"
})

DarkRP.createEntity("Compact Generator", {
    ent = "arcrp_generator_compact",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    price = 600,
    max = 1,
    cmd = "buycompactgen"
})


DarkRP.createEntity("Generator", {
    ent = "arcrp_generator",
    model = "models/props_vehicles/generatortrailer01.mdl",
    price = 950,
    max = 1,
    cmd = "buygen"
})

DarkRP.createEntity("Microwave", {
    ent = "arcrp_microwave",
    model = "models/props/cs_office/microwave.mdl",
    price = 80,
    max = 1,
    cmd = "buymicrowave"
})
