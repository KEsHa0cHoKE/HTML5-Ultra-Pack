#region STATS

if ((async_load[? "type"]== YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_getStats))
{
	switch (async_load[? "event"]) 
	{	
        case YaGames_CallPlayerGetData:
			// Успех
			
			var _data = json_parse(async_load[? "data"])
			// Если сохранение не пустое
			if (struct_names_count(_data) > 0)
			{
				met_statsGetted(_data)
			}
        break;
        case YaGames_CallPlayerGetDataError:
			show_message("Data request error")
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_message("Player in SDK not initialized")
        break;
        case YaGames_CallNotInitSDK:
			show_message("SDK not initialized")
        break;
        case YaGames_CallRuntimeError:
			show_message("SDK runtime error")
        break;
    }
	
	state++
	waiting_answer = false
}

#endregion

#region DATA

if ((async_load[? "type"]== YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_getData))
{
	switch (async_load[? "event"]) 
	{	
        case YaGames_CallPlayerGetStats:
            // Успех
			
			var _data = json_parse(async_load[? "data"])
			// Если сохранение не пустое
			if (struct_names_count(_data) > 0)
			{
				met_dataGetted(_data)
			}
        break;
        case YaGames_CallPlayerGetStatsError:
			show_message("Data request error")
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_message("Player in SDK not initialized")
        break;
        case YaGames_CallNotInitSDK:
			show_message("SDK not initialized")
        break;
        case YaGames_CallRuntimeError:
			show_message("SDK runtime error")
        break;
    }
	
	state++
	waiting_answer = false
}

#endregion

#region PLAYER INIT

if ((async_load[? "type"]== YaGames_AsyncEvent) and (async_load[? "request_id"] == reqId_playerInit)) 
{
    switch (async_load[? "event"]) 
	{
        case YaGames_CallPlayerInit:
			// Успех
        break;
        case YaGames_CallPlayerInitError:	
			show_message("player Leaderboard initialization error")
        break;
			
        case YaGames_CallNotInitSDK:
			show_message("player SDK not initialized")
        break;
        case YaGames_CallRuntimeError:
			show_message("player SDK runtime error")
        break;
    }
	
	state++
	waiting_answer = false
}

#endregion