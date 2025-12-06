image_angle--

if (waiting_answer) then exit;

switch (state) {
	case E_INIT_STATE.SDK_NOT_INIT :
		if (!YG.is_release_build || YG_MODE == E_YG_MODE.PLAYGAMA) {
			state++
			show_debug_message($"-- SDK_INITING SKIPPED")
			exit;
		}
		
		show_debug_message($"-- Init state : SDK_NOT_INIT")
		
		sdk_is_ready = bool(YaGames_getInitStatus())
		if (sdk_is_ready) then state++
	break;
		
	case E_INIT_STATE.SDK_INITED :
		if (!YG.is_release_build || YG_MODE == E_YG_MODE.PLAYGAMA) {
			state++
			show_debug_message($"-- ENVIRONMENT_GETTING SKIPPED")
			exit;
		}
		
		show_debug_message($"-- Init current state : SDK_INITED")
		
		reqId_environment = YaGames_getEnvironment()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.ENVIRONMENT_GETTED :
		if (!YG.is_release_build || YG_MODE == E_YG_MODE.PLAYGAMA) {
			state++
			show_debug_message($"-- PLAYER_INITING SKIPPED")
			exit;
		}
		
		show_debug_message($"-- Init current state : ENVIRONMENT_GETTED")
		
		reqId_playerInit = YaGames_Player_Init()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.PLAYER_INITED :
		if (YG_MODE == E_YG_MODE.PLAYGAMA) {
			state++
			show_debug_message($"-- STATS_GETTING SKIPPED")
			exit;
		}
		
		show_debug_message($"-- Init current state : PLAYER_INITED")
		
		var _callback = function() {
			__objYGInit.state++
			__objYGInit.waiting_answer = false
		}
		
		waiting_answer = true
		YG.storage.stats.get(_callback, _callback)
	break;
		
	case E_INIT_STATE.STATS_GETTED :
		show_debug_message($"-- Init current state : STATS_GETTED")
	
		_callback = function() {
			__objYGInit.state++
			__objYGInit.waiting_answer = false
		}
		
		waiting_answer = true
		YG.storage.data.get(_callback, _callback)
	break;
		
	case E_INIT_STATE.DATA_GETTED :
		if (!YG.is_release_build || YG_MODE == E_YG_MODE.PLAYGAMA) {
			state++
			show_debug_message($"-- FLAGS_GETTING SKIPPED")
			exit;
		}
		
		show_debug_message($"-- Init current state : DATA_GETTED")
		
		reqId_flags = YaGames_GetFlags(json_stringify(YG.flags))
		waiting_answer = true
	break;
	
	case E_INIT_STATE.FLAGS_GETTED :
		show_debug_message($"-- Init current state : FLAGS_GETTED")
	
		call_later(0.1, time_source_units_seconds, function() {
			if (YG_MODE == E_YG_MODE.YANDEX_GAMES)
				YaGames_GameReadyOn()
			else
				playgama_bridge_platform_send_message("game_ready")
		})
		
		
		instance_create_depth(0,0, -100000, __ygAdv)
		instance_create_depth(0,0, -100000, __ygAudio)
		instance_create_depth(0,0, -100000, __ygEventListener)
		room_goto(YG_FIRST_ROOM)
	break;
}