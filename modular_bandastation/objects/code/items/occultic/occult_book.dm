// MARK: Periods
// Books are separated based on different periods of history

/// 599 AD - 11th c.
#define OCCULT_PERIOD_DAWN "Dawn"
/// 11th c. - 16th c.
#define OCCULT_PERIOD_ROADS "Roads"
/// 16th c. - 20th c.
#define OCCULT_PERIOD_WONDERS "Wonders"
/// 20th c. - 23th c.
#define OCCULT_PERIOD_ECLYPSE "Eclypse"
/// 23th c. - Today
#define OCCULT_PERIOD_INTRUSION "Intrusion"

// MARK: Occult book
/obj/item/book/granter
// "Why you don't use /obj/item/book/granter?"
// Granters have specific logic that is center around gameplay value of books.
// They posses limited uses and their flavor texts are randomized
// Also, the mechanism of their granting logic is a bit hard to override, because we need additional checks for languages
// That's why I created subtype of book, not granter

/obj/item/book/occult
	unique = TRUE
	/// Text messages that must be shown to a player during reading
	var/list/lores = list()
	/// In which period this book was written?
	var/period = OCCULT_PERIOD_INTRUSION
	/// Which language is required to read it?
	var/datum/language/language = /datum/language/common
	/// Time is required to read one of book lores
	var/reading_time = 8 SECONDS
	/// A list that contains a pool of sound effect for books
	var/static/list/book_sounds = list(
		'sound/effects/page_turn/pageturn1.ogg',
		'sound/effects/page_turn/pageturn2.ogg',
		'sound/effects/page_turn/pageturn3.ogg',
	)
	/// Sanity check
	var/reading = FALSE

/obj/item/book/occult/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("Вы уже читаете это!"))
		return FALSE
	if(user.is_blind())
		to_chat(user, span_warning("Вы слепы и не можете ничего прочесть!"))
		return FALSE
	if(!isliving(user) || !user.can_read(src))
		return FALSE
	if(!has_language(language, UNDERSTOOD_LANGUAGE))
		to_chat(user, span_warning("Вы не знаете этого языка!"))
		return FALSE
	if(!on_reading_start(user))
		return
	reading = TRUE
	for(var/message in lores)
		if(do_after(user, reading_time, src))
			to_chat(user, span_notice(message))
		else
			on_reading_stopped()
			reading = FALSE
			return
	on_reading_finished(user)
	reading = FALSE

	return TRUE

/// Called when the user starts to read the granter.
/obj/item/book/occult/proc/on_reading_start(mob/living/user)
	to_chat(user, span_notice("Вы начинаете читать [name]..."))
	return TRUE

/// Called when the reading is interrupted without finishing.
/obj/item/book/occult/proc/on_reading_stopped(mob/living/user)
	to_chat(user, span_notice("Вы прекращаете читать..."))

/// Called when the reading is completely finished.
/obj/item/book/occult/proc/on_reading_finished(mob/living/user)
	to_chat(user, span_notice("Вы закончили прочтение [name]!"))

/obj/item/book/occult/examine(mob/user)
	. = ..()
	switch(period)
		if(OCCULT_PERIOD_DAWN)
			. += span_info("Данный текст был написан в период <b>Рассвета</b>, - меж 600-х годов до нашей эры и 11-го века этой эры. Эпоха <b>Славы</b> и <i>Тех</i>, кто вышел из неё.")
		if(OCCULT_PERIOD_ROADS)
			. += span_info("Данный текст был написан в период <b>Войны Дорог</b>, её причин и последствий, - меж 11-м и 16-м веками. Эпоха, что окончилась расколом <b>Солнца-В-Зените.</b>")
		if(OCCULT_PERIOD_WONDERS)
			. += span_notice("Данный текст был написан в период <b>Чудес</b>, - меж 16-м и 20-м веками. Эпоха, когда свет <b>Славы</b>, казалось, никогда не затухнет.")
		if(OCCULT_PERIOD_ECLYPSE)
			. += span_notice("Данный текст был написан в период <b>Затмения</b>, - меж 20-м и 23-м веками. Эпоха без света, веры и <b>Знания</b>.")
		if(OCCULT_PERIOD_INTRUSION)
			. += span_notice("Данный текст был написан в период <b>Интрузии</b>, - с 23-го века и по наш день. Эпоха, когда <b>Ничто</b> излилось в <b>Дом</b>.")
		else
			. += span_notice("Данный текст был написан в <b>неизвестный</b> период.")

#undef OCCULT_PERIOD_DAWN
#undef OCCULT_PERIOD_ROADS
#undef OCCULT_PERIOD_WONDERS
#undef OCCULT_PERIOD_ECLYPSE
#undef OCCULT_PERIOD_INTRUSION


