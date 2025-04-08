#region GET STATS

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_getStats))
{
	var _metFailed = function()
	{
		if (is_callable(getStats_callback_failed))
		{
			getStats_callback_failed()
			getStats_callback_failed = undefined
		}
	}
	
	switch (async_load[? "event"])
	{
        case YaGames_CallPlayerGetStats:
			// Успех
			
			var _data = json_parse(async_load[? "data"])
			// Если сохранение не пустое
			if (struct_names_count(_data) > 0)
			{
				target_stats_struct = _data
				
				if (is_callable(getStats_callback))
				{
					getStats_callback()
					getStats_callback = undefined
				}
			}
        break;
		
        case YaGames_CallPlayerGetStatsError:
			show_debug_message("-- Stats request error")
			
			_metFailed()
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_debug_message("-- Stats Player in SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Stats SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallRuntimeError:
			show_debug_message("-- Stats SDK runtime error")
			
			_metFailed()
        break;
    }
}

#endregion



#region SEND STATS

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_sendStats))
{
	var _metFailed = function()
	{
		if (is_callable(sendStats_callback_failed))
		{
			sendStats_callback_failed()
			sendStats_callback_failed = undefined
		}
	}
	
	switch (async_load[? "event"])
	{
        case YaGames_CallPlayerSetStats:
			// Успех
			
			if (is_callable(sendStats_callback))
			{
				sendStats_callback()
				sendStats_callback = undefined
			}
			
        break;
		
        case YaGames_CallPlayerSetStatsError:
			show_debug_message("-- Stats request error")
			
			_metFailed()
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_debug_message("-- Stats Player in SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Stats SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallRuntimeError:
			show_debug_message("-- Stats SDK runtime error")
			
			_metFailed()
        break;
    }
}

#endregion



#region GET DATA

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_getData))
{
	var _metFailed = function()
	{
		if (is_callable(getData_callback_failed))
		{
			getData_callback_failed()
			getData_callback_failed = undefined
		}
	}
	
	switch (async_load[? "event"]) 
	{	
        case YaGames_CallPlayerGetData:
            // Успех
			
			var _data = json_parse(async_load[? "data"])
			// Если сохранение не пустое
			if (struct_names_count(_data) > 0)
			{
				target_data_struct = _data
				
				if (is_callable(getData_callback))
				{
					getData_callback()
					getData_callback = undefined
				}
			}
        break;
		
        case YaGames_CallPlayerGetDataError:
			show_debug_message("-- Data request error")
			
			_metFailed()
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_debug_message("-- Data Player in SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Data SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallRuntimeError:
			show_debug_message("-- Data SDK runtime error")
			
			_metFailed()
        break;
    }
}

#endregion



#region SEND DATA

if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == reqId_sendData))
{
	var _metFailed = function()
	{
		if (is_callable(sendData_callback_failed))
		{
			sendData_callback_failed()
			sendData_callback_failed = undefined
		}
	}
	
	switch (async_load[? "event"])
	{
        case YaGames_CallPlayerSetStats:
			// Успех
			
			if (is_callable(sendData_callback))
			{
				sendData_callback()
				sendData_callback = undefined
			}
			
        break;
		
        case YaGames_CallPlayerSetStatsError:
			show_debug_message("-- Stats request error")
			
			_metFailed()
        break;
			
        case YaGames_CallNotPlayerInitSDK:
			show_debug_message("-- Stats Player in SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallNotInitSDK:
			show_debug_message("-- Stats SDK not initialized")
			
			_metFailed()
        break;
		
        case YaGames_CallRuntimeError:
			show_debug_message("-- Stats SDK runtime error")
			
			_metFailed()
        break;
    }
}

#endregion
