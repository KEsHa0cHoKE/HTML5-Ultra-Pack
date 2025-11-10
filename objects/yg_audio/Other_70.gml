if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == YaGames_RequestIdGameApi))
{
	switch (async_load[? "event"]) 
	{
		case YaGames_CallGameApiPause:
			__met_api_pause()
		break;
		
		case YaGames_CallGameApiResume:
			__met_api_resume()
		break;
	}
}