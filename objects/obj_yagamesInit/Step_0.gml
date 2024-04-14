if (waiting_answer) then exit;

switch (state)
{
	case E_INIT_STATE.SDK_NOT_INIT : 
		sdk_is_ready = YaGames_getInitStatus()
		if (sdk_is_ready) then state++
	break;
		
	case E_INIT_STATE.SDK_INITED :
		reqId_environment = YaGames_getEnvironment()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.ENVIRONMENT_GETTED :
		global.lang = environment.i18n.lang
		reqId_playerInit = YaGames_Player_Init()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.PLAYER_INITED :
		reqId_getStats = YaGames_Player_GetAllStats()
		waiting_answer = true
	break;
			
	case E_INIT_STATE.STATS_GETTED :
		reqId_getData = YaGames_Player_GetAllData()
		waiting_answer = true
	break;
		
	case E_INIT_STATE.DATA_GETTED :
		room_goto(first_room)
	break;
}