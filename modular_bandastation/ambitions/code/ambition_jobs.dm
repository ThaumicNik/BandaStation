// Each job owns its own static list. Add job-specific ambition types here.
/datum/job
	var/list/ambition_types = list()

/datum/job/botanist
	ambition_types = list(
		/datum/ambition/farmers_market,
		/datum/ambition/botanical_decor,
	)

/datum/job/station_engineer
	ambition_types = list(
		/datum/ambition/infrastructure,
		/datum/ambition/engineering_tour,
	)

/datum/job/doctor
	ambition_types = list(
		/datum/ambition/medical_checkup,
		/datum/ambition/public_first_aid,
	)
