/// Only administrator-authored ambitions have configurable presentation and capacity.
/datum/ambition/admin
	source = "admin"
	/// Zero means unlimited. Counts distinct minds currently holding a linked copy.
	var/participant_limit = 0
	var/card_color = "purple"

/datum/ambition/admin/proc/get_participants()
	var/list/participants = list()
	for(var/datum/ambition/claim as anything in claimed_ambitions)
		if(!QDELETED(claim.holder_mind))
			participants |= claim.holder_mind
	return participants

/datum/ambition/admin/proc/has_available_slot()
	return !participant_limit || length(get_participants()) < participant_limit

/// A mind may hold one linked copy of each offer, including completed copies.
/datum/ambition/admin/proc/can_be_claimed_by(datum/mind/character)
	if(QDELETED(character))
		return FALSE
	var/list/participants = get_participants()
	return !(character in participants) && (!participant_limit || length(participants) < participant_limit)

/// Open catalogues immediately reflect filled or released slots.
/datum/ambition/admin/proc/refresh_pool_viewers()
	for(var/datum/mind/character as anything in SSticker.minds)
		if(!QDELETED(character))
			character.refresh_ambitions_panels()
	for(var/datum/ambitions_panel/panel as anything in GLOB.admin_ambition_pool_panels.Copy())
		SStgui.update_uis(panel)

/datum/ambition/admin/get_card_data(index)
	. = ..()
	.["cardColor"] = card_color

/// Pool settings are only accepted by the administrator pool, never by personal edits.
/datum/ambition/admin/proc/apply_pool_edit(list/params)
	var/new_limit = params["participantLimit"]
	if(!isnum(new_limit))
		new_limit = text2num(new_limit)
	var/new_color = params["cardColor"]
	if(!isnum(new_limit) || new_limit != round(new_limit) || new_limit < 0)
		return FALSE
	if(!(new_color in list("blue", "green", "red", "purple", "amber", "teal")))
		return FALSE
	if(!apply_edit(params))
		return FALSE
	participant_limit = new_limit
	card_color = new_color
	return TRUE

ADMIN_VERB(manage_ambition_pool, R_ADMIN, "Ambitions Pool", "Manage round-local ambitions available to all players.", ADMIN_CATEGORY_GAME)
	for(var/datum/ambitions_panel/admin_pool/panel as anything in GLOB.admin_ambition_pool_panels)
		if(panel.editor == user)
			panel.ui_interact(user.mob)
			return
	var/datum/ambitions_panel/admin_pool/panel = new(null, user)
	panel.ui_interact(user.mob)
	log_admin("[key_name(user)] opened the admin ambitions pool.")

/datum/ambitions_panel/admin_pool
	var/client/editor

/datum/ambitions_panel/admin_pool/New(datum/mind/unused_owner, client/new_editor)
	..()
	editor = new_editor
	GLOB.admin_ambition_pool_panels += src

/datum/ambitions_panel/admin_pool/Destroy(force)
	GLOB.admin_ambition_pool_panels -= src
	editor = null
	return ..()

/datum/ambitions_panel/admin_pool/can_access(mob/user)
	return user?.client && user.client == editor && check_rights_for(user.client, R_ADMIN) && SSticker.current_state < GAME_STATE_FINISHED

/datum/ambitions_panel/admin_pool/can_admin_edit(mob/user)
	return can_access(user)

/datum/ambitions_panel/admin_pool/ui_data(mob/user)
	if(!can_access(user))
		return list()
	var/list/entries = list()
	for(var/datum/ambition/admin/template as anything in GLOB.admin_ambition_pool)
		var/list/entry = template.get_card_data()
		var/list/takers = list()
		for(var/datum/mind/character as anything in template.get_participants())
			takers += "[character.name] ([character.key])"
		entry["takers"] = takers
		entry["participantLimit"] = template.participant_limit
		entry["participantCount"] = length(takers)
		entries += list(entry)
	var/list/data = editor_limits()
	data["ambitions"] = entries
	data["offers"] = list()
	data["adminOffers"] = list()
	data["poolMode"] = TRUE
	data["adminMode"] = TRUE
	data["maxAmbitions"] = 0
	return data

/datum/ambitions_panel/admin_pool/handle_action(action, list/params)
	if(action != "add" && action != "edit" && action != "remove")
		return FALSE
	var/datum/ambition/admin/template
	if(action == "add")
		template = new
		template.source = "admin"
	else
		template = locate(params["ref"]) in GLOB.admin_ambition_pool
		if(!template)
			return FALSE
	if(action != "remove")
		if(!template.apply_pool_edit(params))
			if(action == "add")
				qdel(template)
			return FALSE
	if(action == "add")
		GLOB.admin_ambition_pool += template
	else if(action == "edit")
		for(var/datum/ambition/admin/claim as anything in template.claimed_ambitions)
			claim.title = template.title
			claim.description = template.description
			claim.difficulty = template.difficulty
			claim.card_color = template.card_color
			claim.holder_mind?.refresh_ambitions_panels()
	else
		GLOB.admin_ambition_pool -= template
	log_admin("[key_name(usr)] performed [action] in the ambitions pool: [template.title] ([template.difficulty]/3, participant limit: [template.participant_limit], colour: [template.card_color]) - [template.description]")
	if(action == "remove")
		qdel(template)
	for(var/datum/mind/character as anything in SSticker.minds)
		character.refresh_ambitions_panels()
	for(var/datum/ambitions_panel/panel as anything in GLOB.admin_ambition_pool_panels.Copy())
		SStgui.update_uis(panel)
	return TRUE
