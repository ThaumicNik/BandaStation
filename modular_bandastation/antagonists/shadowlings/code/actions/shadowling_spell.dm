// BASIC

/datum/action/cooldown/spell/shadowling
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	spell_requirements = NONE
	school = SCHOOL_NECROMANCY

/datum/action/cooldown/spell/shadowling/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	return TRUE

// AOE

/datum/action/cooldown/spell/aoe/shadowling
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	spell_requirements = NONE
	school = SCHOOL_NECROMANCY

/datum/action/cooldown/spell/aoe/shadowling/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	return TRUE
