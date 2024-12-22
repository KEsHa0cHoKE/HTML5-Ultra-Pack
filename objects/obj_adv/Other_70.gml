#region INTERSTITIAL

if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_id)) 
{
	var _setUpNewTimer = function()
	{
		audio_resume_all()
		
		adv_state = E_ADV_STATE.CANNOT_SHOW
		alarm[0] = adv_periodicity_in_sec*game_speed
			
		if (is_callable(inter_callback))
		{
			inter_callback()
		}
		inter_callback = undefined
	}
	
	switch (async_load[? "event"]) 
	{
        case YaGames_CallAdClosed:
			_setUpNewTimer()
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
			//show_message("Fullscreen ADV error: not Init SDK")
			_setUpNewTimer()
        break;
        case YaGames_CallRuntimeError:
			//show_message("Fullscreen ADV error: Runtime Error")
			_setUpNewTimer()
        break;
    }
}

#endregion

#region REWARD

if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_idReward)) 
{
	switch (async_load[? "event"]) 
	{
	    case YaGames_CallRewardOpened:
			audio_pause_all()
			reward_state = E_REWARD_STATE.SHOWING
	    break;
	    case YaGames_CallRewardReceived:
			if (is_callable(reward_callback))
			{
				reward_callback()
			}
			else
			{
				show_error("reward_callback не является методом/функцией", true)
			}
	    break;
	    case YaGames_CallRewardClosed:
			audio_resume_all()
			reward_state = E_REWARD_STATE.NOT_SHOW
	    break;
	    case YaGames_CallRewardError:
			reward_state = E_REWARD_STATE.NOT_SHOW
			audio_resume_all()
			//show_message("Reward error")
	    break;
			
	    case YaGames_CallNotInitSDK:
			reward_state = E_REWARD_STATE.NOT_SHOW
			audio_resume_all()
			//show_message("Reward error: Not init SDK")
	    break;
	    case YaGames_CallRuntimeError:
			reward_state = E_REWARD_STATE.NOT_SHOW
			audio_resume_all()
			//show_message("Reward error: Runtime Error")
	    break;
	}
}

#endregion