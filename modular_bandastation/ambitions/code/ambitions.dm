#define MAX_MIND_AMBITIONS 5
#define MAX_AMBITION_LENGTH 500
#define MAX_AMBITION_TITLE_LENGTH 80
#define HUD_MOB_AMBITIONS "mob_ambitions"
#define ui_human_ambitions_menu "EAST-4:22,SOUTH+1:24"

GLOBAL_LIST_EMPTY(admin_ambition_pool)
GLOBAL_LIST_EMPTY(admin_ambition_pool_panels)

/datum/ambition
	var/title = "Амбиция"
	var/description = ""
	/// 1: quick idea, 2: involved goal, 3: round-long undertaking.
	var/difficulty = 1
	/// A personal completion mark, set manually. No objective checks or rewards.
	var/completed = FALSE
	/// Presentation category; ordinary ambitions derive their colour from this source.
	var/source = "custom"
	var/datum/mind/holder_mind
	var/datum/ambition/admin/admin_template
	var/list/claimed_ambitions = list()

/datum/ambition/Destroy()
	if(admin_template)
		admin_template.claimed_ambitions -= src
		admin_template.refresh_pool_viewers()
	for(var/datum/ambition/claim as anything in claimed_ambitions)
		claim.admin_template = null
	claimed_ambitions.Cut()
	admin_template = null
	holder_mind = null
	return ..()

/datum/ambition/proc/apply_edit(list/params)
	var/new_title = params["title"]
	var/new_description = params["description"]
	var/new_difficulty = params["difficulty"]
	if(!isnum(new_difficulty))
		new_difficulty = text2num(new_difficulty)
	if(!istext(new_title) || !istext(new_description))
		return FALSE
	if(!isnum(new_difficulty) || new_difficulty != round(new_difficulty) || new_difficulty < 1 || new_difficulty > 3)
		return FALSE
	new_title = trim(copytext_char(new_title, 1, MAX_AMBITION_TITLE_LENGTH + 1))
	new_description = trim(copytext_char(new_description, 1, MAX_AMBITION_LENGTH + 1))
	if(!length(new_title) || !length(new_description))
		return FALSE
	title = new_title
	description = new_description
	difficulty = new_difficulty
	return TRUE

/datum/ambition/proc/get_card_data(index)
	return list(
		"id" = index,
		"ref" = REF(src),
		"title" = title,
		"description" = description,
		"difficulty" = difficulty,
		"completed" = completed,
		"source" = source,
	)

/datum/mind
	/// Personal roleplay notes for this character, kept across body transfers.
	var/list/ambitions = list()
	var/datum/ambitions_panel/ambitions_panel
	/// Admin windows are separate from the character's private window.
	var/list/admin_ambitions_panels = list()

/datum/mind/Destroy()
	QDEL_NULL(ambitions_panel)
	QDEL_LIST(admin_ambitions_panels)
	QDEL_LIST(ambitions)
	return ..()

/mob/proc/open_ambitions_panel()
	if(!mind || SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(!mind.ambitions_panel)
		mind.ambitions_panel = new(mind)
	mind.ambitions_panel.ui_interact(src)

/datum/ambitions_panel
	var/datum/mind/owner_mind
	var/interface_name = "Ambitions"
	/// Temporary choices for this open panel. No acquisition history is retained.
	var/list/offered_ambitions = list()
	var/datum/job/offered_for_job

/datum/ambitions_panel/New(datum/mind/new_owner)
	. = ..()
	owner_mind = new_owner

/datum/ambitions_panel/Destroy(force)
	clear_offers()
	if(owner_mind?.ambitions_panel == src)
		owner_mind.ambitions_panel = null
	owner_mind = null
	return ..()

/datum/ambitions_panel/proc/clear_offers()
	QDEL_LIST(offered_ambitions)
	offered_ambitions = list()
	offered_for_job = null

/datum/ambitions_panel/ui_close(mob/user)
	qdel(src)

/datum/ambitions_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/ambitions_panel/proc/can_access(mob/user)
	return user?.client && !QDELETED(owner_mind) && user.mind == owner_mind && SSticker.current_state == GAME_STATE_PLAYING

/datum/ambitions_panel/proc/can_admin_edit(mob/user)
	return FALSE

/datum/ambitions_panel/proc/editor_limits()
	return list("maxLength" = MAX_AMBITION_LENGTH, "maxTitleLength" = MAX_AMBITION_TITLE_LENGTH)

/datum/ambitions_panel/proc/on_ambition_changed(mob/user, action, datum/ambition/ambition)
	owner_mind.refresh_ambitions_panels()
	if(ambition.admin_template)
		ambition.admin_template.refresh_pool_viewers()
	for(var/datum/ambitions_panel/panel as anything in GLOB.admin_ambition_pool_panels.Copy())
		SStgui.update_uis(panel)

/datum/mind/proc/refresh_ambitions_panels()
	if(ambitions_panel)
		SStgui.update_uis(ambitions_panel)
	for(var/datum/ambitions_panel/admin/panel as anything in admin_ambitions_panels.Copy())
		SStgui.update_uis(panel)

/datum/ambitions_panel/ui_status(mob/user, datum/ui_state/state)
	if(!can_access(user))
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/ambitions_panel/ui_interact(mob/user, datum/tgui/ui)
	if(!can_access(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_name)
		ui.open()

/datum/ambitions_panel/ui_data(mob/user)
	var/list/entries = list()
	if(!can_access(user))
		return list()
	if(offered_for_job != owner_mind.assigned_role)
		clear_offers()
	for(var/index in 1 to length(owner_mind.ambitions))
		var/datum/ambition/ambition = owner_mind.ambitions[index]
		var/list/entry = ambition.get_card_data(index)
		entry["ref"] = REF(ambition)
		entries += list(entry)
	var/list/offers = list()
	for(var/index in 1 to length(offered_ambitions))
		var/datum/ambition/offer = offered_ambitions[index]
		offers += list(offer.get_card_data(index))
	var/list/admin_offers = list()
	for(var/datum/ambition/admin/offer as anything in GLOB.admin_ambition_pool)
		if(offer.can_be_claimed_by(owner_mind))
			admin_offers += list(offer.get_card_data())
	return list(
		"ambitions" = entries,
		"offers" = offers,
		"maxAmbitions" = MAX_MIND_AMBITIONS,
		"maxLength" = MAX_AMBITION_LENGTH,
		"maxTitleLength" = MAX_AMBITION_TITLE_LENGTH,
		"characterName" = owner_mind.name,
		"adminMode" = can_admin_edit(user),
		"poolMode" = FALSE,
		"adminOffers" = admin_offers,
	)

/datum/ambitions_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!can_access(usr))
		return FALSE
	return handle_action(action, params)

/// Dispatch after the shared TGUI and access checks; the pool has no owner mind.
/datum/ambitions_panel/proc/handle_action(action, list/params)
	var/index
	var/datum/ambition/target_ambition
	if(action == "edit" || action == "remove" || action == "toggle_completed")
		if(params["ref"])
			target_ambition = locate(params["ref"]) in owner_mind.ambitions
		else
			index = text2num(params["id"])
			if(isnum(index) && index == round(index) && index >= 1 && index <= length(owner_mind.ambitions))
				target_ambition = owner_mind.ambitions[index]
		if(!target_ambition)
			return FALSE

	switch(action)
		if("toggle_completed")
			target_ambition.completed = !target_ambition.completed
			on_ambition_changed(usr, target_ambition.completed ? "marked completed" : "unmarked completed", target_ambition)
			return TRUE

		if("find")
			if(length(owner_mind.ambitions) >= MAX_MIND_AMBITIONS)
				return FALSE
			clear_offers()
			var/list/pool = GLOB.general_ambition_types.Copy()
			if(length(owner_mind.assigned_role?.ambition_types))
				pool += owner_mind.assigned_role.ambition_types
			var/list/unique_options = list()
			var/list/seen_texts = list()
			for(var/ambition_type in pool)
				if(!ispath(ambition_type, /datum/ambition))
					continue
				var/datum/ambition/candidate = new ambition_type
				candidate.source = (ambition_type in GLOB.general_ambition_types) ? "general" : "job"
				var/text_key = "[candidate.title]\n[candidate.description]"
				if(seen_texts[text_key])
					qdel(candidate)
					continue
				seen_texts[text_key] = TRUE
				unique_options += candidate
			unique_options = shuffle(unique_options)
			offered_ambitions = unique_options.Copy(1, 4)
			if(length(unique_options) > 3)
				for(var/unused_index in 4 to length(unique_options))
					qdel(unique_options[unused_index])
			offered_for_job = owner_mind.assigned_role
			return TRUE

		if("cancel")
			clear_offers()
			return TRUE

		if("choose")
			if(length(owner_mind.ambitions) >= MAX_MIND_AMBITIONS || offered_for_job != owner_mind.assigned_role)
				return FALSE
			index = text2num(params["index"])
			if(!isnum(index) || index != round(index) || index < 1 || index > length(offered_ambitions))
				return FALSE
			var/datum/ambition/chosen = offered_ambitions[index]
			offered_ambitions.Cut(index, index + 1)
			owner_mind.ambitions += chosen
			chosen.holder_mind = owner_mind
			clear_offers()
			on_ambition_changed(usr, "added", chosen)
			return TRUE

		if("choose_admin")
			if(length(owner_mind.ambitions) >= MAX_MIND_AMBITIONS)
				return FALSE
			var/datum/ambition/admin/template = locate(params["ref"]) in GLOB.admin_ambition_pool
			if(!template || !template.can_be_claimed_by(owner_mind))
				return FALSE
			var/datum/ambition/admin/claim = new
			claim.title = template.title
			claim.description = template.description
			claim.difficulty = template.difficulty
			claim.card_color = template.card_color
			claim.source = "admin"
			claim.admin_template = template
			claim.holder_mind = owner_mind
			template.claimed_ambitions += claim
			owner_mind.ambitions += claim
			on_ambition_changed(usr, "added", claim)
			return TRUE

		if("edit", "add")
			if(action == "add" && length(owner_mind.ambitions) >= MAX_MIND_AMBITIONS)
				return FALSE
			var/datum/ambition/edited = target_ambition
			if(action == "add")
				edited = new
			if(!edited.apply_edit(params))
				if(action == "add")
					qdel(edited)
				return FALSE
			if(action == "add")
				edited.holder_mind = owner_mind
				owner_mind.ambitions += edited
			on_ambition_changed(usr, action == "add" ? "added" : "edited", edited)
			return TRUE

		if("remove")
			owner_mind.ambitions -= target_ambition
			if(target_ambition.admin_template)
				target_ambition.admin_template.claimed_ambitions -= target_ambition
			on_ambition_changed(usr, "removed", target_ambition)
			qdel(target_ambition)
			return TRUE
	return FALSE

/atom/movable/screen/ambitions
	name = "Ambitions"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "ambitions"
	screen_loc = ui_human_ambitions_menu
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/ambitions/Click()
	if(!isliving(usr))
		return TRUE
	usr.open_ambitions_panel()
	return TRUE

/datum/hud/human/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/ambitions, HUD_MOB_AMBITIONS, HUD_GROUP_STATIC, ui_style, ui_human_ambitions_menu)

/datum/controller/subsystem/ticker/build_roundend_report()
	. = ..()
	var/list/character_entries = list()
	for(var/datum/mind/character as anything in minds)
		if(!length(character.ambitions))
			continue
		var/list/ideas = list()
		for(var/datum/ambition/idea as anything in character.ambitions)
			var/idea_title = html_encode(idea.title)
			var/idea_description = replacetext(html_encode(idea.description), "\n", "<br>")
			var/completion_mark = idea.completed ? " — <span class='greentext'>Выполнено</span>" : ""
			ideas += "<li><b>[idea_title]</b> ([idea.difficulty]/3)[completion_mark]: [idea_description]</li>"
		var/character_name = html_encode(character.name || character.current?.real_name || "Неизвестный персонаж")
		character_entries += "<li><b>[character_name]</b><ul>[ideas.Join()]</ul></li>"
	if(length(character_entries))
		. += "<div class='panel stationborder'><span class='header'>Амбиции персонажей</span><ul class='playerlist'>[character_entries.Join()]</ul></div>"

#undef MAX_MIND_AMBITIONS
#undef MAX_AMBITION_LENGTH
#undef MAX_AMBITION_TITLE_LENGTH
#undef HUD_MOB_AMBITIONS
#undef ui_human_ambitions_menu
