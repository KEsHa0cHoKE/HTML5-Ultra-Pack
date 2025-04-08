#region INTERSTITIAL

if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_id)) 
{
	var _setUpNewTimer = function()
	{
		audio_master_gain(1)
		
		adv_state = E_ADV_STATE.CANNOT_SHOW
		alarm[0] = adv_periodicity_in_sec*game_get_speed(gamespeed_fps)
		
		if (is_callable(inter_callback))
		{
			inter_callback()
			inter_callback = undefined
		}
	}
	
	switch (async_load[? "event"]) 
	{
        case YaGames_CallAdClosed:
			_setUpNewTimer()
        break;
		
        case YaGames_CallAdOpened:
			audio_master_gain(0)
			adv_state = E_ADV_STATE.SHOWING_ADV
        break;

        case YaGames_CallOfflineMode:
			show_debug_message("-- Fullscreen ADV error: offlineMode")
			_setUpNewTimer()
		break;
        case YaGames_CallAdError:
			show_debug_message("-- Fullscreen ADV error: adError")
			_setUpNewTimer()
		break;
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Fullscreen ADV error: not Init SDK")
			_setUpNewTimer()
        break;
        case YaGames_CallRuntimeError:
			show_debug_message("-- Fullscreen ADV error: Runtime Error")
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
			audio_master_gain(0)
			reward_state = E_REWARD_STATE.SHOWING
	    break;
	    case YaGames_CallRewardReceived:
			reward_received = true
	    break;
	    case YaGames_CallRewardClosed:
			audio_master_gain(1)
			if (reward_received)
			{
				reward_received = false
				
				if (is_callable(reward_callback)) 
				{
					reward_callback()
					reward_callback = undefined
				}
				else
				{
					show_error("yg_adv : async_social -> невозможно вызвать reward_callback", true)
				}
			}
			else 
			{
				if (is_callable(reward_callback_without_reward)) 
				{
					reward_callback_without_reward()
					reward_callback_without_reward = undefined
				}
			}
			reward_state = E_REWARD_STATE.NOT_SHOW
	    break;
	    case YaGames_CallRewardError:
			audio_master_gain(1)
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error")
	    break;
			
	    case YaGames_CallNotInitSDK:
			audio_master_gain(1)
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error: Not init SDK")
	    break;
	    case YaGames_CallRuntimeError:
			audio_master_gain(1)
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error: Runtime Error")
	    break;
	}
}

#endregion