/obj/item/clothing/shoes/berserk
	name = "berserk boots"
	desc = "Латные ботинки, изготовленные из чёрного гладкого металла, словно поглощающего свет."

	icon = 'modular_bandastation/objects/icons/obj/clothing/shoes/berserk_boots.dmi'
	worn_icon = 'modular_bandastation/objects/icons/mob/clothing/shoes/berserk_boots.dmi'
	lefthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_righthand.dmi'
	icon_state = "boots"
	base_icon_state = "boots"
	inhand_icon_state = "armor"

	armor_type = /datum/armor/berserk
	clothing_flags = THICKMATERIAL
	resistance_flags = FIRE_PROOF|ACID_PROOF
	cold_protection = FEET
	heat_protection = FEET
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/berserk/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))
