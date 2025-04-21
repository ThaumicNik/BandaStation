/mob/living/carbon/human/species/shadow/shadowling
	race = /datum/species/shadow/shadowling

/datum/species/shadow/shadowling
	name = "\improper Тенелинг"
	plural_form = "Тенелинги"
	id = SPECIES_SHADOWLING
	// Shadowling are creatures of darkness, so the they are adapted to live in cold starless systems.
	bodytemp_cold_damage_limit = BODYTEMP_COLD_ICEBOX_SAFE
	changesource_flags = MIRROR_BADMIN
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_RESISTCOLD,
		TRAIT_NOBREATH,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_NOHUNGER,
		TRAIT_NOBLOOD,
		TRAIT_NO_DNA_COPY,
		TRAIT_NODISMEMBER,
		TRAIT_NEVER_WOUNDED,
		TRAIT_NO_JUMPSUIT,
	)

/datum/species/shadow/shadowling/check_roundstart_eligible()
	return FALSE

