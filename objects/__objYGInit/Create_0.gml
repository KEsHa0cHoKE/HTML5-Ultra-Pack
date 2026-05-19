///@desc

__YGsettings()


enum E_INIT_STATE_UNION {
	NOTHING_INITED,
	SDK_INITED,
	PLAYER_ENVIRONMENT_FLAGS_LEADERBOARDS_INITED,
	STATS_DATA_GETTED,
	sizeof
}
union_state = E_INIT_STATE_UNION.NOTHING_INITED
UNION_LAST_STATE = E_INIT_STATE_UNION.sizeof-1
union_drawing_percent = 0

union_state_expected_completed_reqIds_array = [ 0, 4, 2, 0 ]
union_state_completed_requests_on_this_state = 0

met_next_state = function() {
	union_state++
	union_state_completed_requests_on_this_state = 0
	waiting_answer = false
}

met_is_can_go_next_state_after_resolve_reqId = function() {
	union_state_completed_requests_on_this_state++
	
	//show_debug_message($"union_state_completed_requests_on_this_state = {union_state_completed_requests_on_this_state}")
	
	return (
		union_state_completed_requests_on_this_state == 
		union_state_expected_completed_reqIds_array[union_state]
	)
}

__callbackDataStats = function() {
	if (met_is_can_go_next_state_after_resolve_reqId()) {
		met_next_state()
	}
}


#region Прелоад

sdk_is_ready 		= (YG_MODE == E_YG_MODE.YANDEX_GAMES && YG.is_release_build ? 
	bool(YaGames_getInitStatus()) : true) 

waiting_answer 		= false

reqId_environment 	= undefined
reqId_leaderboards 	= undefined
//reqId_payments 		= undefined
reqId_getStats 		= undefined
reqId_getData 		= undefined
reqId_playerInit 	= undefined
reqId_flags 		= undefined

#endregion



met_loading_failed = function(_failedInfoString = "undefined_reason")
{
	room_goto(__rmLoadingFailed)
	
	YMW_reachGoal("dataLoading_failed")
	YMW_params(json_stringify({loading_failed : _failedInfoString}))
}