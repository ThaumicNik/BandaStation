#define STONESHARD_GAUNTLETS (1<<0)
#define STONESHARD_ARMOR (1<<1)
#define STONESHARD_HELMET (1<<2)
#define STONESHARD_BOOTS (1<<4)

/obj/item/clothing/suit/hooded/cultrobes/cult_shield
/datum/component/shielded

/datum/armor/berserk
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/item/stoneshard
	name = "stoneshard"
	desc = "Странный фиолетовый осколок камня, мерцающий пурпуром во тьме."

	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	inhand_icon_state = "flashlight"
	worn_icon_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'

	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_NECK

	actions_types = list(/datum/action/item_action/toggle)

	action_slots = ALL

	light_color = COLOR_DARK_PURPLE
	light_range = 1
	light_power = 1

	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

	var/in_use = FALSE
	var/list/armor_parts = list()

/obj/item/stoneshard/Initialize(mapload)
	. = ..()
	armor_parts["[STONESHARD_HELMET]"] = new /obj/item/clothing/head/helmet/berserk()
	armor_parts["[STONESHARD_BOOTS]"] = new /obj/item/clothing/shoes/berserk()
	armor_parts["[STONESHARD_GAUNTLETS]"] = new /obj/item/clothing/gloves/berserk()
	armor_parts["[STONESHARD_ARMOR]"] = new /obj/item/clothing/suit/armor/berserk()

/obj/item/stoneshard/attack_self(mob/user, modifiers)
	. = ..()
	var/mob/living/carbon/human/human_user = user
	if(!istype(human_user))
		return
	INVOKE_ASYNC(src, PROC_REF(play_animation), human_user)

/obj/item/stoneshard/proc/play_animation(mob/living/carbon/human/target)
	var/mutable_appearance/equip_animation = mutable_appearance('modular_bandastation/objects/icons/onbody/berserk_equip_animation.dmi', "equip_start", MOB_SHIELD_LAYER)
	target.overlays += equip_animation
	sleep(0.6 SECONDS)
	target.equip_to_slot_if_possible(armor_parts["[STONESHARD_HELMET]"], ITEM_SLOT_HEAD, 1, 1, 1)
	target.equip_to_slot_if_possible(armor_parts["[STONESHARD_BOOTS]"], ITEM_SLOT_FEET, 1, 1, 1)
	target.equip_to_slot_if_possible(armor_parts["[STONESHARD_GAUNTLETS]"], ITEM_SLOT_GLOVES, 1, 1, 1)
	target.equip_to_slot_if_possible(armor_parts["[STONESHARD_ARMOR]"], ITEM_SLOT_OCLOTHING, 1, 1, 1)
	target.overlays -= equip_animation
	equip_animation.icon_state = "equip_end"
	target.overlays += equip_animation
	sleep(0.4 SECONDS)
	target.overlays -= equip_animation
	qdel(equip_animation)

/obj/machinery/door/airlock
