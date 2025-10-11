// MARK: Base
/obj/structure/floating_candles
	name = "floating candles"
	desc = "Левитирующая кучка свечей, будто насмехающаяся над жалкими Спящими, которым нужно электричество для освещения."
	icon = 'modular_bandastation/fantasy/icons/floating_candles.dmi'
	icon_state = "six"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	light_color = "#ffeac4"
	light_power = 1
	light_range = 10
	light_angle = 360

/obj/structure/floating_candles/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_DEFAULT)
