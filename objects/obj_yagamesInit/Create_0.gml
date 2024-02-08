first_room = r_menu

var _fnt = fnt_YaGamesInit

draw_set_font(_fnt)
draw_set_color(c_white)
draw_set_valign(fa_middle)
draw_set_halign(fa_center)

points_array = ["",".","..","..."]
target_point = 0
alarm[0] = 20

var _lang = os_get_language()
text = (_lang == "ru" ? "Загрузка" : "Loading")

global.lang = _lang

var _isWindows = (os_browser == browser_not_a_browser)
if (_isWindows)
{
	room_goto(first_room)
}