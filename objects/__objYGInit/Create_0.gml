///@desc

__YGsettings()

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

sdk_is_ready = (YG_MODE == E_YG_MODE.YANDEX_GAMES ? bool(YaGames_getInitStatus()) : true) 

waiting_answer = false

reqId_environment = undefined
reqId_getStats = undefined
reqId_getData = undefined
reqId_playerInit = undefined
reqId_flags = undefined

#endregion



met_loading_failed = function(_failedInfoString = "undefined_reason")
{
	room_goto(__rmLoadingFailed)
	
	YMW_reachGoal("dataLoading_failed")
	YMW_params(json_stringify({loading_failed : _failedInfoString}))
}