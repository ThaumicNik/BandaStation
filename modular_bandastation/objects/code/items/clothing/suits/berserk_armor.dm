/obj/item/clothing/suit/armor/berserk
	name = "berserk armor"
	desc = "Броня, изготовленная из чёрного гладкого металла, словно поглощающего свет."

	icon = 'modular_bandastation/objects/icons/obj/clothing/suits/berserk_armor.dmi'
	worn_icon = 'modular_bandastation/objects/icons/mob/clothing/suits/berserk_armor.dmi'
	lefthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_righthand.dmi'
	icon_state = "armor"
	base_icon_state = "armor"
	inhand_icon_state = "armor"

	equip_sound = 'sound/items/handling/armor_rustle/plate_armor/plate_armor_rustle1.ogg'
	pickup_sound = 'sound/items/handling/armor_rustle/plate_armor/plate_armor_rustle2.ogg'
	drop_sound = 'sound/items/handling/armor_rustle/plate_armor/plate_armor_rustle3.ogg'
	sound_vary = TRUE

	armor_type = /datum/armor/berserk
	clothing_flags = STOPSPRESSUREDAMAGE|THICKMATERIAL
	resistance_flags = FIRE_PROOF|ACID_PROOF
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|GROIN|ARMS|LEGS
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	strip_delay = 8 SECONDS
	equip_delay_other = 6 SECONDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)

	allowed = list(
		/obj/item/claymore
		// Впишите сюда меч как будет готов
		)

/obj/item/clothing/head/helmet/berserk/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)
