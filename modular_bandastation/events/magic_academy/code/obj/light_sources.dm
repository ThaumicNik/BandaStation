// MARK: Candles
/obj/structure/candle
	layer = WALL_OBJ_LAYER
	light_color = "#ffd59e"
	icon = 'modular_bandastation/events/magic_academy/icons/floating_candles.dmi'
	icon_state = "six"

// MARK: Floating Candles
/obj/structure/candle/floating
	name = "floating candles"
	desc = "Левитирующая кучка свечей, будто насмехающаяся над жалкими Спящими, которым нужно электричество для освещения."
	icon = 'modular_bandastation/events/magic_academy/icons/floating_candles.dmi'
	icon_state = "six"
	anchored = TRUE
	light_power = 1
	light_range = 10
	light_angle = 360

/obj/structure/candle/floating/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_DEFAULT)


// MARK: Wall Candlesticks

/obj/structure/candle/wall_candlestick
	name = "настенный канделябр"
	desc = "Подставка под свечку. Выглядит очень безопасно для расположения в возгораемом помещении."
	icon = 'modular_bandastation/events/magic_academy/icons/obj/wall_candlestick.dmi'
	icon_state = "wall_candlestick"
	anchored = TRUE
	light_color = "#ffd59e"
	light_power = 1
	light_range = 8
	light_angle = 360

/obj/structure/candle/wall_candlestick/update_icon(updates)
	. = ..()
	if(dir == SOUTH)
		pixel_y = 16
	else
		pixel_y = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/candle/wall_candlestick, 0)

/obj/structure/candle/wall_candlestick/directional/north
	pixel_y = 16
