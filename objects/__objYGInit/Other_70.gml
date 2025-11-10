#region ENVIRONMENT

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_environment))
{
	switch (async_load[? "event"]) 
	{
		case YaGames_CallEnvironment:
			// Успех
			
			var _data = json_parse(async_load[? "data"])
			YG.lang = _data.i18n.lang
		break;
		
		case YaGames_CallNotInitSDK:
			show_debug_message("-- environment SDK not initialized")
			YMW_params(json_stringify({loading_failed : "environment SDK not initialized"}))
			
			YG.lang = "ru"
		break;
		
		case YaGames_CallRuntimeError:
			show_debug_message("-- environment SDK runtime error")
			YMW_params(json_stringify({loading_failed : "environment SDK runtime error"}))
			
			YG.lang = "ru"
		break;
	}
	
	state++
	waiting_answer = false
}

#endregion


#region PLAYER INIT

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_playerInit)) 
{
    switch (async_load[? "event"]) 
	{
        case YaGames_CallPlayerInit:
			// Успех
        break;
        case YaGames_CallPlayerInitError:	
			show_debug_message("-- player initialization error")
			met_loading_failed("player initialization error")
        break;
			
        case YaGames_CallNotInitSDK:
			show_debug_message("-- player SDK not initialized")
			met_loading_failed("player SDK not initialized")
        break;
        case YaGames_CallRuntimeError:
			show_debug_message("-- player SDK runtime error")
			met_loading_failed("player SDK runtime error")
        break;
    }
	
	state++
	waiting_answer = false
}

#endregion


#region FLAGS

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_flags)) 
{
    switch (async_load[? "event"]) 
	{
        case YaGames_CallGetFlags:
			// Успех
			
			var _data = json_parse(async_load[? "data"])
			// Если флаги не пустые
			if (struct_names_count(_data) > 0)
			{
				met_flagsGetted(_data)
			}
        break;
        case YaGames_CallGetFlagsError:	
			show_debug_message("-- Flags request error")
			YMW_params(json_stringify({loading_failed : "Flags request error"}))
        break;
			
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Flags SDK not initialized")
			YMW_params(json_stringify({loading_failed : "Flags SDK not initialized"}))
        break;
        case YaGames_CallRuntimeError:
			show_debug_message("-- Flags SDK runtime error")
			YMW_params(json_stringify({loading_failed : "Flags SDK runtime error"}))
        break;
    }
	
	state++
	waiting_answer = false
}

#endregion