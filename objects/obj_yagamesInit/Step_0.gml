if (waiting_answer) then exit;

switch (state)
{
	case E_INIT_STATE.SDK_NOT_INIT : 
		sdk_is_ready = YaGames_getInitStatus()
		if (sdk_is_ready)
		{
			global.lang = YaGames_getBrowserLang()
			state++
		}
		break;
		
	case E_INIT_STATE.SDK_INIT :
		reqId_playerInit = YaGames_Player_Init()
		waiting_answer = true
		break;
			
	case E_INIT_STATE.PLAYER_INIT :
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