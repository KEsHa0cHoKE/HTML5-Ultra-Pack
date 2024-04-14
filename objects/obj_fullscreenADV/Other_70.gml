if ((async_load[? "type"] == "YaGames") and (async_load[? "request_id"] == req_id)) 
{
	switch (async_load[? "event"]) 
	{
        case YaGames_CallAdClosed:
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
			audio_resume_all()
        break;
		
        case YaGames_CallAdOpened:
			adv_state = E_ADV_STATE.SHOWING_ADV
			audio_pause_all()
        break;

        case YaGames_CallOfflineMode:
			//show_message("Fullscreen ADV error: offlineMode")
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
		break;
        case YaGames_CallAdError:
			//show_message("Fullscreen ADV error: adError")
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
		break;
        case YaGames_CallNotInitSDK:
			show_message("Fullscreen ADV error: notInitSDK")
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
        break;
        case YaGames_CallRuntimeError:
			show_message("Fullscreen ADV error: RuntimeError")
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
        break;
    }
}