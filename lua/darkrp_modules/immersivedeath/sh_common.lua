-- #NoSimplerr#
IMDE = IMDE or {}

-- [DMG enum] = {stamina damage taken, health damage taken, balance damage taken}
-- stamina damage is applied before health damage multiplier.
IMDE.StaminaDamageMultipliers = {

    [DMG_BULLET] = {1, 0.8, 0},
    [DMG_BUCKSHOT] = {0.5, 1, 0.5},

    [DMG_SLASH] = {1, 0.5, 0.25}, -- NPCs use this damage on stunstick/crowbar, which isn't right!
    [DMG_CLUB] = {0.25, 0.1, 0.5},
    [DMG_CRUSH] = {2, 0.25, 0.5}, -- physics damage

    [DMG_BLAST] = {0.75, 0.8, 2},

    [DMG_NERVEGAS] = {2, 0, 0}, -- cs gas (nonlethal)
    [DMG_SHOCK] = {1, 0.25, 1}, -- shock (stungun?)
    [DMG_FALL] = {1, 1, 1}, -- fall damage
    [DMG_SONIC] = {1, 0.25, 2}, -- concussion grenade
}

IMDE.StaminaDamageMultipliers_NPC = {
    [DMG_SLASH] = {1, 0.25, 0.25},
}