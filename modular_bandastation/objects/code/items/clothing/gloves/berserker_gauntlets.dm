/obj/item/clothing/gloves/berserk
	name = "berserk gauntlets"
	desc = "Латные руковицы, изготовленные из чёрного гладкого металла, словно поглощающего свет."

	icon = 'modular_bandastation/objects/icons/obj/clothing/gloves/berserk_gauntlets.dmi'
	worn_icon = 'modular_bandastation/objects/icons/mob/clothing/gloves/berserk_gauntlets.dmi'
	lefthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_righthand.dmi'
	icon_state = "gauntlets"
	base_icon_state = "gauntlets"
	inhand_icon_state = "armor"

	armor_type = /datum/armor/berserk
	clothing_flags = THICKMATERIAL
	resistance_flags = FIRE_PROOF|ACID_PROOF
	siemens_coefficient = 0
	cold_protection = HANDS
	heat_protection = HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/gloves/berserk/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))
