///@desc

met_loading_failed = function(_failedInfoString = "undefined_reason")
{
	room_goto(r_loadingFailed)
	
	//YMW_reachGoal("dataLoading_failed")
	//YMW_params(json_stringify({loading_failed : _failedInfoString}))
}

#endregion

#region Настройки

	// Первая комната, куда надо перейти после загрузки игры	
	first_room = rm_game // Вставьте название комнаты
	// Флаги, используемые если не получили флаги с сервера, или на windows
	flags_default = json_stringify({})
	// Язык, который используется для теста на windows
	windows_lang = "ru"
	
	///@func met_dataGetted(_struct)
	///@desc Метод, который выполняется при получении data с сервера
	met_dataGetted = function(_struct)
	{
		// place here some code
	}
	
	///@func met_statsGetted(_struct)
	///@desc Метод, который выполняется при получении stats с сервера
	met_statsGetted = function(_struct)
	{
		// place here some code
	}
	
	///@func met_flagsGetted(_struct)
	///@desc Метод, который выполняется при получении flags с сервера
	met_flagsGetted = function(_struct)
	{
		// place here some code
	}

#endregion


enum E_INIT_STATE
{
	SDK_NOT_INIT,
	SDK_INITED,
	ENVIRONMENT_GETTED,
	PLAYER_INITED,
	STATS_GETTED,
	DATA_GETTED,
	FLAGS_GETTED,
}

globalvar YG_INIT;
YG_INIT = {
	flags : {},
	lang : "ru",
	device_type : E_DEVICE_TYPE.PC
}

state = E_INIT_STATE.SDK_NOT_INIT


#region Прелоад

sdk_is_ready = YaGames_getInitStatus()

waiting_answer = false
reqId_getStats = undefined
reqId_getData = undefined
reqId_playerInit = undefined
reqId_flags = undefined
environment = {}

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
	YG_INIT.lang = windows_lang
	YG_INIT.flags = json_parse(flags_default)
	
	state = E_INIT_STATE.FLAGS_GETTED
}

#endregion