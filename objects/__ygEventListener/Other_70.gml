#region Yandex Games

// Pause
if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == YaGames_RequestIdGameApi))
{
	switch (async_load[? "event"]) 
	{
		case YaGames_CallGameApiPause:
			__met_pause()
		break;
		
		case YaGames_CallGameApiResume:
			__met_resume()
		break;
	}
}

#endregion

#region PlayGama

// Audio state
if (async_load[? "type"] == "playgama_bridge_platform_audio_state_changed") {
    if (async_load[? "data"]) {
        YG.platform.is_audio_enabled = true
    } else {
        YG.platform.is_audio_enabled = false
    }
}

// Pause
if (async_load[? "type"] == "playgama_bridge_platform_pause_state_changed") {
    if (async_load[? "data"]) {
        __met_pause()
    } else {
        __met_resume()
    }
}

// Tab visibility
if (async_load[? "type"] == "playgama_bridge_game_visibility_state_changed") {
    switch (async_load[? "data"]) {
        case "visible":
            YG.platform.is_visible = true
        break;
		
        case "hidden":
            YG.platform.is_visible = false
        break;
    }
}