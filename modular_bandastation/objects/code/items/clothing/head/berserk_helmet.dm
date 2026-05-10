/obj/item/clothing/head/helmet/berserk
	name = "berserk helmet"
	desc = "Шлем, изготовленный из чёрного гладкого металла, словно поглощающего свет."

	icon = 'modular_bandastation/objects/icons/obj/clothing/head/berserk_helmet.dmi'
	worn_icon = 'modular_bandastation/objects/icons/mob/clothing/head/berserk_helmet.dmi'
	lefthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_lefthand.dmi'
	righthand_file = 'modular_bandastation/objects/icons/mob/inhands/berserk_armor_righthand.dmi'
	icon_state = "helmet"
	base_icon_state = "helmet"
	inhand_icon_state = "armor"

	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	sound_vary = TRUE

	armor_type = /datum/armor/berserk
	clothing_flags = STOPSPRESSUREDAMAGE|STACKABLE_HELMET_EXEMPT|HEADINTERNALS|THICKMATERIAL
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	resistance_flags = FIRE_PROOF|ACID_PROOF
	dog_fashion = null
	cold_protection = HEAD|NECK
	heat_protection = HEAD|NECK
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/berserk/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))
