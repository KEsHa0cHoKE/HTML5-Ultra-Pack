image_angle--

if (waiting_answer) then exit;

switch (state) {
	case E_INIT_STATE.SDK_NOT_INIT :
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		sdk_is_ready = YaGames_getInitStatus()
		if (sdk_is_ready) then state++
	break;
		
	case E_INIT_STATE.SDK_INITED :
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_environment = YaGames_getEnvironment()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.ENVIRONMENT_GETTED :
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_playerInit = YaGames_Player_Init()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.PLAYER_INITED :
		if (!YG.is_release_build) {
			var _callback = function() {
				__objYGInit.state++
				__objYGInit.waiting_answer = false
				__objYGInit.met_statsGetted()
			}
			waiting_answer = true
			yg_data.met_get_all_stats(_callback, _callback)
			
			exit;
		}
		
		reqId_getStats = YaGames_Player_GetAllStats()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.STATS_GETTED :
		if (!YG.is_release_build) {
			var _callback = function() {
				__objYGInit.state++
				__objYGInit.waiting_answer = false
				__objYGInit.met_dataGetted()
			}
			waiting_answer = true
			yg_data.met_get_all_data(_callback, _callback)
			
			exit;
		}
		
		reqId_getData = YaGames_Player_GetAllData()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.DATA_GETTED :
		if (!YG.is_release_build) {
			state++
			exit;
		}
		
		reqId_flags = YaGames_GetFlags(json_stringify(YG.flags))
		waiting_answer = true
	break;
	
	case E_INIT_STATE.FLAGS_GETTED :
		call_later(0.1, time_source_units_seconds, function() {
			YaGames_GameReadyOn()
		})
		
		instance_create_depth(0,0, -10000, yg_adv)
		room_goto(YG_FIRST_ROOM)
	break;
}