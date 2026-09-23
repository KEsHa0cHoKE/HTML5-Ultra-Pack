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
	YG.platform.is_audio_enabled = (string(async_load[? "data"]) == "1")
}

// Pause
if (async_load[? "type"] == "playgama_bridge_platform_pause_state_changed") {
	var _isPaused = (string(async_load[? "data"]) == "1")
	
	if (_isPaused)
		__met_pause()
	else
		__met_resume()
}
