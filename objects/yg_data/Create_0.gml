///@desc

reqId_getData = undefined
getData_callback = undefined
getData_callback_failed = undefined

reqId_sendData = undefined
sendData_callback = undefined
sendData_callback_failed = undefined

reqId_getStats = undefined
getStats_callback = undefined
getStats_callback_failed = undefined

reqId_sendStats = undefined
sendStats_callback = undefined
sendStats_callback_failed = undefined


#region Методы отправки данных

///@func met_send_data
///@desc Сохраняет данные data на сервер яндекса, либо в локальные файлы при тесте
///@param {Struct} _struct Передаваемая структура для сохранения
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_send_data = function(_struct, _callback = undefined, _callbackFailed = undefined)
{
	var _structToSend = variable_clone(_struct)
	
	if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_sendData = YaGames_Player_SetData(json_stringify(_structToSend))
		
		sendData_callback = _callback
		sendData_callback_failed = _callbackFailed
		
		//struct_save_to_file(_structToSend, YG_DATA_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed, _structToSend} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_SEND)
			{
				struct_save_to_file(_structToSend, YG_DATA_FILENAME)
				if (is_callable(_callback)) then _callback()
			}
			else
			{
				if (is_callable(_callbackFailed)) then _callbackFailed()
			}
		})
	}
	else
	{
		if (is_callable(_callback)) then _callback()
		show_debug_message("yg_data -> met_send_data : Saves Inactive")
	}
}

///@func met_send_stats
///@desc Сохраняет данные stats на сервер яндекса, либо в локальные файлы при тесте
///@param {Struct} _struct Передаваемая структура для сохранения
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_send_stats = function(_struct, _callback = undefined, _callbackFailed = undefined) 
{
	var _structToSend = variable_clone(_struct)
	
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_sendStats = YaGames_Player_SetStats(json_stringify(_structToSend))
		
		sendStats_callback = _callback
		sendStats_callback_failed = _callbackFailed
		
		//struct_save_to_file(_structToSend, YG_DATA_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed, _structToSend} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_SEND)
			{
				struct_save_to_file(_structToSend, YG_DATA_FILENAME)
				if (is_callable(_callback)) then _callback()
			}
			else
			{
				if (is_callable(_callbackFailed)) then _callbackFailed()
			}
		})
	}
	else
	{
		if (is_callable(_callback)) then _callback()
		show_debug_message("yg_data -> met_send_stats : Saves Inactive")
	}
}

#endregion


#region Методы удаления данных

///@func met_delete_all_data
///@desc Отправляет на сервер яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
met_delete_all_data = function() 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		YaGames_Player_SetData(json_stringify({}))
		//struct_save_to_file({}, YG_DATA_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		struct_save_to_file({}, YG_DATA_FILENAME)
	}
	else
	{
		show_debug_message("yg_data -> met_delete_all_data : Saves Inactive")
	}
}

///@func met_delete_all_stats
///@desc Отправляет на сервер яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
met_delete_all_stats = function() 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		YaGames_Player_SetStats(json_stringify({}))
		//struct_save_to_file({}, YG_STATS_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		struct_save_to_file({}, YG_STATS_FILENAME)
	}
	else
	{
		show_debug_message("yg_data -> met_delete_all_stats : Saves Inactive")
	}
}

#endregion


#region Методы получения данных

///@func met_get_all_data
///@desc Асинхронно получает данные сохранений data с сервера яндекса. Результат запишется в структуру YG.data. Можно указать коллбек, выполнится при получении
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_get_all_data = function(_callback = undefined, _callbackFailed = undefined) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_getData = YaGames_Player_GetAllData()
		
		getData_callback = _callback
		getData_callback_failed = _callbackFailed
		
		//YG.data = struct_get_from_file(YG_DATA_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function() {
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				YG.data = struct_get_from_file(YG_DATA_FILENAME)
				
				if (is_callable(_callback)) then _callback()
			}
			else
			{
				if (is_callable(_callbackFailed)) then _callbackFailed()
			}
		})
	}
	else
	{
		if (is_callable(_callback)) then _callback()
		show_debug_message("yg_data -> met_get_all_data : Saves Inactive")
	}
}

///@func met_get_all_stats
///@desc Асинхронно получает данные сохранений stats с сервера яндекса. Результат запишется в структуру YG.stats. Можно указать коллбек, выполнится при получении
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_get_all_stats = function(_callback = undefined, _callbackFailed = undefined) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_getStats = YaGames_Player_GetAllStats()
		
		getStats_callback = _callback
		getStats_callback_failed = _callbackFailed
		
		//YG.stats = struct_get_from_file(YG_STATS_FILENAME)
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE)
	{
		with {_callback, _callbackFailed} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				YG.stats = struct_get_from_file(YG_STATS_FILENAME)
				
				if (is_callable(_callback)) then _callback()
			}
			else
			{
				if (is_callable(_callbackFailed)) then _callbackFailed()
			}
		})
	}
	else
	{
		if (is_callable(_callback)) then _callback()
		show_debug_message("yg_data -> met_get_all_stats : Saves Inactive")
	}
}

#endregion