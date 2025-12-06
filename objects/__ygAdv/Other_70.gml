#region INTERSTITIAL

#region Yandex Games

if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_id)) 
{
	var _setUpNewTimer = function()
	{
		adv_state = E_ADV_STATE.CANNOT_SHOW
		alarm[0] = (YG.is_release_build ? adv_periodicity_in_sec*game_get_speed(gamespeed_fps) : debug_adv_periodicity_in_sec*game_get_speed(gamespeed_fps))
		
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

#region PlayGama

if (async_load[? "type"] == "playgama_bridge_advertisement_interstitial_state_changed") {
    var _setUpNewTimer = function()
	{
		adv_state = E_ADV_STATE.CANNOT_SHOW
		alarm[0] = (YG.is_release_build ? adv_periodicity_in_sec*game_get_speed(gamespeed_fps) : debug_adv_periodicity_in_sec*game_get_speed(gamespeed_fps))
		
		if (is_callable(inter_callback))
		{
			inter_callback()
			inter_callback = undefined
		}
	}
	
	switch (async_load[? "data"]) {
        case "loading":
			adv_state = E_ADV_STATE.SHOWING_ADV
        break;
		
        case "opened":
            adv_state = E_ADV_STATE.SHOWING_ADV
        break;
		
        case "closed":
            _setUpNewTimer()
        break;
		
        case "failed":
			show_debug_message("-- PlayGama Inter error: failed")
            _setUpNewTimer()
        break;
    }
}

#endregion

#endregion



#region REWARD

#region Yandex Games

if ((async_load[? "type"] == YaGames_AsyncEvent) and (async_load[? "request_id"] == req_idReward)) 
{
	switch (async_load[? "event"]) 
	{
	    case YaGames_CallRewardOpened:
			reward_state = E_REWARD_STATE.SHOWING
	    break;
		
	    case YaGames_CallRewardReceived:
			reward_received = true
	    break;
		
	    case YaGames_CallRewardClosed:
			if (reward_received)
			{
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
			
			reward_received = false
			reward_state = E_REWARD_STATE.NOT_SHOW
	    break;
		
	    case YaGames_CallRewardError:
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error")
	    break;
			
	    case YaGames_CallNotInitSDK:
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error: Not init SDK")
	    break;
		
	    case YaGames_CallRuntimeError:
			reward_state = E_REWARD_STATE.NOT_SHOW
			show_debug_message("-- Reward error: Runtime Error")
	    break;
	}
}

#endregion

#region PlayGama

if (async_load[? "type"] == "playgama_bridge_advertisement_rewarded_state_changed") {
    switch (async_load[? "data"]) {
        case "loading":
            reward_state = E_REWARD_STATE.SHOWING
        break;
		
        case "opened":
            reward_state = E_REWARD_STATE.SHOWING
        break;
		
        case "rewarded":
            reward_received = true
        break;
		
        case "closed":
            if (reward_received)
			{
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
			
			reward_received = false
			reward_state = E_REWARD_STATE.NOT_SHOW
        break;
		
        case "failed":
            reward_state = E_REWARD_STATE.NOT_SHOW
        break
    }
}

#endregion

#endregion