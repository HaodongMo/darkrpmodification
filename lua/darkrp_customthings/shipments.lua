--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

DarkRP.createShipment("Chemicals", {
    model = "models/props_junk/garbage_plasticbottle002a.mdl",
    entity = "arcrp_in_chemicals",
    price = 150,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Electronics", {
    model = "models/props_lab/reciever01d.mdl",
    entity = "arcrp_in_electronics",
    price = 400,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Fuel", {
    model = "models/props_junk/metalgascan.mdl",
    entity = "arcrp_in_fuel",
    price = 200,
    amount = 5,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Gear", {
    model = "models/props_phx/gears/spur9.mdl",
    entity = "arcrp_in_gear",
    price = 125,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Steel", {
    model = "models/mechanics/solid_steel/plank_4.mdl",
    entity = "arcrp_in_steel",
    price = 100,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Wood", {
    model = "models/props_junk/wood_pallet001a_chunkb2.mdl",
    entity = "arcrp_in_wood",
    price = 50,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Pipe", {
    model = "models/props_pipes/pipe01_straight01_short.mdl",
    entity = "arcrp_in_pipe",
    price = 110,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Paper", {
    model = "models/props/cs_office/Paper_towels.mdl",
    entity = "arcrp_in_paper",
    price = 60,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})

DarkRP.createShipment("Nails", {
    model = "models/props_lab/box01a.mdl",
    entity = "arcrp_in_nails",
    price = 175,
    amount = 10,
    separate = false,
    noship = false,
    allowed = {TEAM_SHOPKEEPER},
    category = "Shipments",
})