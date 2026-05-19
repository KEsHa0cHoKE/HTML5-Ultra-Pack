image_angle--
union_drawing_percent = round(lerp(union_drawing_percent, (union_state/UNION_LAST_STATE)*100, .25))

if (waiting_answer) then exit;
	

switch (union_state) {
	case E_INIT_STATE_UNION.NOTHING_INITED :
		show_debug_message("-- Current State : E_INIT_STATE_UNION.NOTHING_INITED")
		
		if (sdk_is_ready || YaGames_getInitStatus()) {
			met_next_state()
		}
	break;

	case E_INIT_STATE_UNION.SDK_INITED :
		show_debug_message("-- Current State : E_INIT_STATE_UNION.SDK_INITED")
		
		if (!YG.is_release_build || YG_MODE == E_YG_MODE.PLAYGAMA) {
			show_debug_message("-- E_INIT_STATE_UNION.SDK_INITED Skipped")
			met_next_state()
			exit;
		}
		
		reqId_playerInit	= YaGames_Player_Init()
		//reqId_payments		= YaGames_Payments_Init()
		reqId_flags			= YaGames_GetFlags(json_stringify(YG.flags))
		reqId_environment	= YaGames_getEnvironment()
		reqId_leaderboards	= YaGames_Leaderboards_Init()
		
		waiting_answer		= true
	break;

	case E_INIT_STATE_UNION.PLAYER_ENVIRONMENT_FLAGS_LEADERBOARDS_INITED :
		show_debug_message("-- Current State : E_INIT_STATE_UNION.PLAYER_ENVIRONMENT_FLAGS_LEADERBOARDS_INITED")
		
		YG.storage.stats.get(__callbackDataStats, __callbackDataStats)
		YG.storage.data.get(__callbackDataStats, __callbackDataStats)
		
		waiting_answer = true
	break;

	case E_INIT_STATE_UNION.STATS_DATA_GETTED :
		show_debug_message("-- Current State : E_INIT_STATE_UNION.STATS_DATA_GETTED")
		
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