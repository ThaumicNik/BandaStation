/// Each admin gets an independent window bound to their client and the target mind.
/datum/mind/proc/open_admin_ambitions_panel(mob/user)
	if(!user?.client || !check_rights_for(user.client, R_ADMIN) || QDELETED(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, span_warning("Амбиции можно редактировать только во время раунда."), confidential = TRUE)
		return
	for(var/datum/ambitions_panel/admin/panel as anything in admin_ambitions_panels)
		if(panel.editor == user.client)
			panel.ui_interact(user)
			return
	var/datum/ambitions_panel/admin/panel = new(src, user.client)
	panel.ui_interact(user)
	log_admin("[key_name(user)] opened the ambitions panel for [name] ([key]).")

/datum/ambitions_panel/admin
	var/client/editor

/datum/ambitions_panel/admin/New(datum/mind/new_owner, client/new_editor)
	..(new_owner)
	editor = new_editor
	owner_mind.admin_ambitions_panels += src

/datum/ambitions_panel/admin/Destroy(force)
	if(owner_mind)
		owner_mind.admin_ambitions_panels -= src
	editor = null
	return ..()

/datum/ambitions_panel/admin/can_access(mob/user)
	return !QDELETED(owner_mind) && user?.client && user.client == editor && check_rights_for(user.client, R_ADMIN) && SSticker.current_state == GAME_STATE_PLAYING

/datum/ambitions_panel/admin/can_admin_edit(mob/user)
	return can_access(user)

/datum/ambitions_panel/admin/on_ambition_changed(mob/user, action, datum/ambition/ambition)
	log_admin("[key_name(user)] [action] an ambition for [owner_mind.name] ([owner_mind.key]): [ambition.title] ([ambition.difficulty]/3) - [ambition.description]")
	return ..()

/// Link beside Show Teams in the Traitor Panel; management opens in TGUI.
/datum/mind/proc/get_ambitions_admin_link()
	if(!usr?.client || !check_rights_for(usr.client, R_ADMIN))
		return ""
	return " | <a href='byond://?_src_=holder;[HrefToken()];admin_ambitions=[REF(src)]'>Ambitions</a>"

/datum/admins/Topic(href, href_list)
	if(!href_list["admin_ambitions"])
		return ..()
	if(usr?.client != owner || !check_rights(R_ADMIN) || !CheckAdminHref(href, href_list))
		return
	var/datum/mind/target = locate(href_list["admin_ambitions"])
	if(!istype(target) || QDELETED(target))
		to_chat(usr, span_warning("Персонаж больше не существует."), confidential = TRUE)
		return
	target.open_admin_ambitions_panel(usr)
