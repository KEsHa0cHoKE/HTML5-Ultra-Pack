var _text = undefined
if (!is_undefined(global.lang))
{
	_text = (global.lang == "ru" ? "Загрузка" : "Loading")
}
else
{
	_text = ""
}

draw_text(room_width/2, room_height/2, _text+points_array[target_point])