enum E_INIT_STATE
{
	SDK_NOT_INIT,
	SDK_INITED,
	ENVIRONMENT_GETTED,
	PLAYER_INITED,
	STATS_GETTED,
	DATA_GETTED
}

state = E_INIT_STATE.SDK_NOT_INIT
first_room = r_mainMenu

#region Прелоад

sdk_is_ready = YaGames_getInitStatus()

waiting_answer = false
reqId_getStats = undefined
reqId_getData = undefined
reqId_playerInit = undefined
environment = {}
global.lang = undefined

///@desc Метод, который выполняется при получении data с сервера
met_dataGetted = function(_struct)
{
	// place here some code
}

///@desc Метод, который выполняется при получении stats с сервера
met_statsGetted = function(_struct)
{
	// place here some code
}

#endregion

#region Отрисовка

var _fnt = fnt_YaGamesInit

draw_set_font(_fnt)
draw_set_color(c_white)
draw_set_valign(fa_middle)
draw_set_halign(fa_center)

anim_update_time = 20
points_array = ["",".","..","..."]
target_point = 0
alarm[0] = anim_update_time

#endregion

#region Девайс

enum E_DEVICE_TYPE
{
	PC,
	MOBILE
}

switch (os_type)
{
	case os_windows:
	case os_linux:
	case os_macosx:
		global.device_type = E_DEVICE_TYPE.PC
	break;
	
	default:
		global.device_type = E_DEVICE_TYPE.MOBILE
	break;
}

var _isWindows = (os_browser == browser_not_a_browser)
if (_isWindows)
{
	global.lang = "ru"
	room_goto(first_room)
}

#endregion