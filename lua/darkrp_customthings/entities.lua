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

DarkRP.createEntity("Gun lab", {
    ent = "arcrp_gunlab",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    price = 1000,
    max = 1,
    cmd = "buygunlab",
    allowed = TEAM_CRAFTSMAN
})

DarkRP.createEntity("Explosives lab", {
    ent = "arcrp_bomblab",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    price = 800,
    max = 1,
    cmd = "buybomblab",
    allowed = TEAM_CRAFTSMAN
})

// DarkRP.createEntity("Bitcoin Miner", {
//     ent = "arcrp_bitcoin_miner",
//     model = "models/props_c17/consolebox05a.mdl",
//     price = 5000,
//     max = 1,
//     cmd = "buyminer"
// })
