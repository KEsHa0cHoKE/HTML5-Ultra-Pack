///@desc

__settings()

#region Настройки

	///@func met_dataGetted(_struct)
	///@desc Метод, который выполняется при получении data с сервера
	met_dataGetted = function(_struct)
	{
		YG.data = _struct
		
		// place here some code
	}
	
	///@func met_statsGetted(_struct)
	///@desc Метод, который выполняется при получении stats с сервера
	met_statsGetted = function(_struct)
	{
		YG.stats = _struct
		
		// place here some code
	}
	
	///@func met_flagsGetted(_struct)
	///@desc Метод, который выполняется при получении flags с сервера
	met_flagsGetted = function(_struct)
	{
		YG.flags = _struct
		
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
state = E_INIT_STATE.SDK_NOT_INIT



#region Прелоад

sdk_is_ready = YaGames_getInitStatus()

waiting_answer = false
reqId_getStats = undefined
reqId_getData = undefined
reqId_playerInit = undefined
reqId_flags = undefined

#endregion



#region Девайс

switch (os_type)
{
	case os_windows:
	case os_linux:
	case os_macosx:
		YG.device_type = E_DEVICE_TYPE.PC
	break;
	
	default:
		YG.device_type = E_DEVICE_TYPE.MOBILE
	break;
}

#endregion


#region Переход в дебаг мод для виндовс и тестового билда

if (!YG.is_release_build)
{
	YG.lang = YG_DEBUG_LANGUAGE
	
	state = E_INIT_STATE.FLAGS_GETTED
}

#endregion


met_loading_failed = function(_failedInfoString = "undefined_reason")
{
	room_goto(__rmLoadingFailed)
	
	YMW_reachGoal("dataLoading_failed")
	YMW_params(json_stringify({loading_failed : _failedInfoString}))
}