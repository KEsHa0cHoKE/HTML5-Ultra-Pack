///@desc

reqId_getData = undefined
getData_callback = undefined
getData_callback_failed = undefined
target_data_struct = undefined

reqId_sendData = undefined
sendData_callback = undefined
sendData_callback_failed = undefined

reqId_getStats = undefined
getStats_callback = undefined
getStats_callback_failed = undefined
target_stats_struct = undefined

reqId_sendStats = undefined
sendStats_callback = undefined
sendStats_callback_failed = undefined


///@func met_send_data
///@desc Сохраняет данные data на сервер яндекса, либо в локальные файлы при тесте
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
///@param {Struct} _struct Передаваемая структура для сохранения
met_send_data = function(_callback = undefined, _callbackFailed = undefined, _struct = YG.data) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_sendData = YaGames_Player_SetData(json_stringify(_struct))
		
		sendData_callback = _callback
		sendData_callback_failed = _callbackFailed
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed, _struct} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_SEND)
			{
				struct_save_to_file(_struct, YG_DATA_FILENAME)
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
		show_debug_message("-- Saves Inactive")
	}
}

///@func met_send_stats
///@desc Сохраняет данные stats на сервер яндекса, либо в локальные файлы при тесте
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
///@param {Struct} _struct Передаваемая структура для сохранения
met_send_stats = function(_callback = undefined, _callbackFailed = undefined, _struct = YG.stats) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_sendStats = YaGames_Player_SetData(json_stringify(_struct))
		
		sendStats_callback = _callback
		sendStats_callback_failed = _callbackFailed
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed, _struct} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_SEND)
			{
				struct_save_to_file(_struct, YG_DATA_FILENAME)
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
		show_debug_message("-- Saves Inactive")
	}
}



///@func met_delete_all_data
///@desc Отправляет на сервер яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
met_delete_all_data = function() 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		YaGames_Player_SetData(json_stringify({}))
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		struct_save_to_file({}, YG_DATA_FILENAME)
	}
	else
	{
		show_debug_message("-- Saves Inactive")
	}
}

///@func met_delete_all_stats
///@desc Отправляет на сервер яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
met_delete_all_stats = function() 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		YaGames_Player_SetStats(json_stringify({}))
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		struct_save_to_file({}, YG_STATS_FILENAME)
	}
	else
	{
		show_debug_message("-- Saves Inactive")
	}
}



///@func met_get_all_data
///@desc Асинхронно получает данные сохранений data с сервера яндекса. Можно указать коллбек, выполнится при получении
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
///@param {Struct} _structToSaveIn Структура, в которую будет сохранен полученный с сервера json, путём перезаписи
met_get_all_data = function(_callback = undefined, _callbackFailed = undefined, _structToSaveIn = YG.data /* пока работает сохранение ТОЛЬКО в YG.data */) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_getData = YaGames_Player_GetAllData()
		
		target_data_struct = _structToSaveIn
		getData_callback = _callback
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed, _structToSaveIn} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				if (!file_exists(YG_DATA_FILENAME))
				{
					//struct_save_to_file(_structToSaveIn, YG_DATA_FILENAME)
					struct_save_to_file(YG.data, YG_DATA_FILENAME)
				}
				else
				{
					//_structToSaveIn = struct_get_from_file(YG_DATA_FILENAME)
					YG.data = struct_get_from_file(YG_DATA_FILENAME)
				}

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
		show_debug_message("-- Saves Inactive")
	}
}

///@func met_get_all_stats
///@desc Асинхронно получает данные сохранений stats с сервера яндекса. Можно указать коллбек, выполнится при получении
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
///@param {Struct} _structToSaveIn Структура, в которую будет сохранена полученный с сервера json, путём перезаписи
met_get_all_stats = function(_callback = undefined, _callbackFailed = undefined, _structToSaveIn = YG.stats /* пока работает сохранение ТОЛЬКО в YG.stats */) 
{
	if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_getStats = YaGames_Player_GetAllStats()
		
		target_stats_struct = _structToSaveIn
		getStats_callback = _callback
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE)
	{
		with {_callback, _callbackFailed, _structToSaveIn} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				if (!file_exists(YG_STATS_FILENAME))
				{
					//struct_save_to_file(_structToSaveIn, YG_STATS_FILENAME)
					struct_save_to_file(YG.stats, YG_STATS_FILENAME)
				}
				else
				{
					//_structToSaveIn = struct_get_from_file(YG_STATS_FILENAME)
					YG.stats = struct_get_from_file(YG_STATS_FILENAME)
				}
				
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
		show_debug_message("-- Saves Inactive")
	}
}