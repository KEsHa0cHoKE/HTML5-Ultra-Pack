enum E_INIT_STATE
{
	SDK_NOT_INIT,
	SDK_INITED,
	ENVIRONMENT_GETTED,
	PLAYER_INITED,
	STATS_GETTED,
	DATA_GETTED,
	FLAGS_GETTED
}

globalvar YG_INIT;
YG_INIT = {
	flags : {},
	lang : "ru",
	device_type : E_DEVICE_TYPE.PC
}

state = E_INIT_STATE.SDK_NOT_INIT
first_room = r_mainMenu

#region Прелоад

sdk_is_ready = YaGames_getInitStatus()

waiting_answer = false
reqId_getStats = undefined
reqId_getData = undefined
reqId_playerInit = undefined
reqId_flags = undefined
flags_default = json_stringify({})
environment = {}

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

///@desc Метод, который выполняется при получении flags с сервера
met_flagsGetted = function(_struct)
{
	// place here some code
	
	YG_INIT.flags = _struct
}

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
		YG_INIT.device_type = E_DEVICE_TYPE.PC
	break;
	
	default:
		YG_INIT.device_type = E_DEVICE_TYPE.MOBILE
	break;
}

var _isWindows = (os_browser == browser_not_a_browser)
if (_isWindows)
{
	YG_INIT.lang = "ru"
	YG_INIT.flags = json_parse(flags_default)
	instance_create_depth(0,0, -10000, obj_adv)
	room_goto(first_room)
}

#endregion