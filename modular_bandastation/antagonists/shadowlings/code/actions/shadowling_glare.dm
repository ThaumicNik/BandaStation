/datum/action/cooldown/spell/jaunt/shadow_walk
/datum/action/cooldown/spell/smoke
/datum/action/cooldown/spell/aoe

/datum/action/cooldown/spell/aoe/shadowling/glare
	name = "Алый Блик"
	desc = "Ваши красные глаза сверкают, завораживая и очаровывая смертных перед вами. Для лучшего эффекта необходим близкий зрительный контакт и тёмное окружение."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "ninja_cloak"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/aoe/shadowling/glare/get_things_to_cast_on(atom/center)
	var/list/targets = list()

	for(var/mob/living/carbon/human/target in get_hearers_in_view(2, owner))
		if(target == owner || target == center)
			continue
		targets += target

	return targets

/datum/action/cooldown/spell/aoe/shadowling/glare/cast_on_thing_in_aoe(atom/victim, atom/caster)
	var/mob/living/carbon/human/target = victim
	var/mob/user = caster

	switch(calculate_deviation(victim, caster))
		if(DEVIATION_NONE)
			to_chat(user, span_purple("В РАЗНЫЕ СТОРОНЫ ([target.name])"))
		if(DEVIATION_PARTIAL)
			to_chat(user, span_purple("ЧАСТИЧНО ([target.name])"))
		if(DEVIATION_FULL)
			to_chat(user, span_purple("В ОДНУ СТОРОНУ ([target.name])"))

/*
 *	Proc used to calculate the relative position of victims and attackers
 *	Simillar to /obj/item/assembly/flash/proc/calculate_deviation in flash logic
 *  Taken from the Paradise vampire glare logic
 */
/datum/action/cooldown/spell/aoe/shadowling/glare/proc/calculate_deviation(atom/victim, atom/attacker)

	// If the victim was looking at the attacker, this is the direction they'd have to be facing.
	var/attacker_to_victim = get_dir(attacker, victim)
	// The victim's dir is necessarily a cardinal value.
	var/attacker_dir = attacker.dir

	// - - -
	// - V - Attacker facing south
	// # # #
	// Attacker within 45 degrees of where the victim is facing.
	if(attacker_dir & attacker_to_victim)
		return DEVIATION_NONE
	// Are they on the same tile? This is probably the victim crawling under the vampire, and looking down shouldn't be too tough.
	if(victim.loc == attacker.loc)
		return DEVIATION_NONE
	// # # #
	// - V - Attacker facing south
	// - - -
	// Victim at 135 or more degrees of where the victim is facing.
	if(attacker_dir & attacker_to_victim)
		return DEVIATION_FULL
	// - - -
	// # V # Attacker facing south
	// - - -
	// Victim lateral to the victim.
	return DEVIATION_PARTIAL


