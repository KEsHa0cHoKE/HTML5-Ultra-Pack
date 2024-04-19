if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_id)) 
{
	var _setUpNewTimer = function()
	{
		adv_state = E_ADV_STATE.CANNOT_SHOW
		alarm[0] = adv_periodicity_in_sec*game_speed
	}
	
	switch (async_load[? "event"]) 
	{
        case YaGames_CallAdClosed:
			_setUpNewTimer()
			audio_resume_all()
        break;
		
        case YaGames_CallAdOpened:
			adv_state = E_ADV_STATE.SHOWING_ADV
			audio_pause_all()
        break;

        case YaGames_CallOfflineMode:
			//show_message("Fullscreen ADV error: offlineMode")
			_setUpNewTimer()
		break;
        case YaGames_CallAdError:
			//show_message("Fullscreen ADV error: adError")
			_setUpNewTimer()
		break;
        case YaGames_CallNotInitSDK:
			show_message("Fullscreen ADV error: notInitSDK")
			_setUpNewTimer()
        break;
        case YaGames_CallRuntimeError:
			show_message("Fullscreen ADV error: RuntimeError")
			_setUpNewTimer()
        break;
    }
}