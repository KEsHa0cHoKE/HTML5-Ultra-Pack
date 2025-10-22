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
			if (YG_SAVING_DEBUG_ACTIVE) {
				waiting_answer = true
				
				if (!file_exists(YG_STATS_FILENAME) || struct_names_count(struct_get_from_file(YG_STATS_FILENAME)) <= 0) {
					struct_save_to_file(YG.stats, YG_STATS_FILENAME)
					waiting_answer = false
					state++
				}
				else {
					YG.stats = struct_get_from_file(YG_STATS_FILENAME)
					call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
						__objYGInit.state++
						__objYGInit.waiting_answer = false
					})
				}
				
				//yg_data.met_get_all_stats(function(){
				//	__objYGInit.state++
				//	__objYGInit.waiting_answer = false
				//})
			}
			else {
				state++
			}
			
			exit;
		}
		
		reqId_getStats = YaGames_Player_GetAllStats()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.STATS_GETTED :
		if (!YG.is_release_build) {
			if (YG_SAVING_DEBUG_ACTIVE) {
				waiting_answer = true
				
				if (!file_exists(YG_DATA_FILENAME) || struct_names_count(struct_get_from_file(YG_DATA_FILENAME)) <= 0) {
					struct_save_to_file({}, YG_DATA_FILENAME)
					waiting_answer = false
					state++
				}
				else {
					YG.data = struct_get_from_file(YG_DATA_FILENAME)
					call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
						__objYGInit.state++
						__objYGInit.waiting_answer = false
					})
				}
				
				//yg_data.met_get_all_data(function(){
				//	__objYGInit.state++
				//	__objYGInit.waiting_answer = false
				//})
			}
			else {
				state++
			}
			
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