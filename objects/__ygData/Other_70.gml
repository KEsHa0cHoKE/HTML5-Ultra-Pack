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
			
			if (struct_names_count(_data) > 0)
				__met_append_getted_data(_data, YG.stats)
			
			if (is_callable(getStats_callback))
			{
				getStats_callback()
				getStats_callback = undefined
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
			
			if (struct_names_count(_data) > 0)
				__met_append_getted_data(_data, YG.data)
			
			if (is_callable(getData_callback))
			{
				getData_callback()
				getData_callback = undefined
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
        case YaGames_CallPlayerSetData:
			// Успех
			
			if (is_callable(sendData_callback))
			{
				sendData_callback()
				sendData_callback = undefined
			}
			
        break;
		
        case YaGames_CallPlayerSetDataError:
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



#region PG SEND DATA

if (async_load[? "type"] == "playgama_bridge_storage_set_callback") {
	var _metFailed = function() {
		if (is_callable(sendData_callback_failed)) {
			sendData_callback_failed()
			sendData_callback_failed = undefined
		}
	}
	
	
    if (async_load[? "success"]) {
        // Успех
		show_debug_message("-- PlayGama Send Data Success")
			
		if (is_callable(sendData_callback)) {
			sendData_callback()
			sendData_callback = undefined
		}
    }
	else {
		show_debug_message("-- PlayGama Send Data Failed")
		
		_metFailed()
	}
}

#endregion



#region PG GET DATA

if (async_load[? "type"] == "playgama_bridge_storage_get_callback") {
	var _metFailed = function()
	{
		if (is_callable(getData_callback_failed))
		{
			getData_callback_failed()
			getData_callback_failed = undefined
		}
	}
	
	
    if (async_load[? "success"]) {
		show_debug_message("-- PlayGama GetData Success")
		
		var _values = json_parse(async_load[? "data"])
		//show_debug_message(_values)
		
		for (var i=0; i<array_length(_values); i++) {
			var _value = _values[i]
			if (__met_is_json(_value))
				_value = json_parse(_value)
			
			if (!is_undefined(_value))
				YG.data[$ self.pg_string_keys_ordered[i]] = _value
		}
		
		if (is_callable(getData_callback))
		{
			getData_callback()
			getData_callback = undefined
		}
    }
	else {
		show_debug_message("-- PlayGama GetData Failed")
		
		_metFailed()
	}
	
	
	pg_string_keys_ordered = []
}

#endregion