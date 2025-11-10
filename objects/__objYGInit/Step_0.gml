image_angle--

if (waiting_answer) then exit;

switch (state) {
	case E_INIT_STATE.SDK_NOT_INIT :
		show_debug_message($"-- Init state : SDK_NOT_INIT")
		
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		sdk_is_ready = YaGames_getInitStatus()
		if (sdk_is_ready) then state++
	break;
		
	case E_INIT_STATE.SDK_INITED :
		show_debug_message($"-- Init state : SDK_INITED")
	
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_environment = YaGames_getEnvironment()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.ENVIRONMENT_GETTED :
		show_debug_message($"-- Init state : ENVIRONMENT_GETTED")
	
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_playerInit = YaGames_Player_Init()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.PLAYER_INITED :
		show_debug_message($"-- Init state : PLAYER_INITED")
		
		var _callback = function() {
			__objYGInit.state++
			__objYGInit.waiting_answer = false
			__objYGInit.met_statsGetted()
		}
		
		waiting_answer = true
		yg_data.met_get_all_stats(_callback, _callback)
	break;
		
	case E_INIT_STATE.STATS_GETTED :
		show_debug_message($"-- Init state : STATS_GETTED")
	
		_callback = function() {
			__objYGInit.state++
			__objYGInit.waiting_answer = false
			__objYGInit.met_dataGetted()
		}
		
		waiting_answer = true
		yg_data.met_get_all_data(_callback, _callback)
	break;
		
	case E_INIT_STATE.DATA_GETTED :
		show_debug_message($"-- Init state : DATA_GETTED")
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_flags = YaGames_GetFlags(json_stringify(YG.flags))
		waiting_answer = true
	break;
	
	case E_INIT_STATE.FLAGS_GETTED :
		show_debug_message($"-- Init state : FLAGS_GETTED")
	
		call_later(0.1, time_source_units_seconds, function() {
			YaGames_GameReadyOn()
		})
		
		instance_create_depth(0,0, -100000, yg_adv)
		instance_create_depth(0,0, -100000, yg_audio)
		room_goto(YG_FIRST_ROOM)
	break;
}