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

// Переменная для хранения порядка ключей из структуры сохранений. Заполняется перед ожиданием коллбека для получения даты, потом очищается
pg_string_keys_ordered = []

#region PlayGama

///@ignore
///@func __met_is_json
///@param {Any} _value
__met_is_json = function(_value) 
{
	return (
		is_string(_value) &&
		string_length(_value) > 0 &&
		(string_copy(_value, 1, 1) == "[" || string_copy(_value, 1, 1) == "{")
	)
}

///@ignore
///@func __met_send_data_pg
///@param {Struct} _struct Передаваемая структура для сохранения
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
__met_send_data_pg = function(_struct, _callback = undefined, _callbackFailed = undefined) 
{
	sendData_callback = _callback
	sendData_callback_failed = _callbackFailed
	
	var _keys = struct_get_names(_struct)
	var _values = []
	for (var i=0; i<array_length(_keys); i++) {
		var _key = _keys[i]
		var _value = _struct[$ _key]
		
		if (is_array(_value) || is_struct(_value))
			_value = json_stringify(_value)
		//else if (is_bool(_value))
		//	_value = real(_value)
		
		//show_message($"{_key}: {_value}")
		array_push(_values, _value)
	}
	
	//show_message(json_stringify(_values))
	playgama_bridge_storage_set(json_stringify(_keys), json_stringify(_values))
}

///@ignore
///@func __met_get_data_pg
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
///@desc ОЧЫН ВАЖНА КАРОЧЕ ЧТОБЫ НА МОМЕНТ ИНЫЦИЛЫЗАЦЫ ИГРЫ ВСЕ ТРЕБУМЫ ДЛЯ ЗГРУЗК КЛЮЧИ В YG.data БЫЛИ НА МЕСТИ ИНАЧЕ АБСЁР :)
__met_get_data_pg = function(_callback = undefined, _callbackFailed = undefined) 
{
	getData_callback = _callback
	getData_callback_failed = _callbackFailed
	
	
	var _keysNames = struct_get_names(YG.data)
	for (var i=0; i<array_length(_keysNames); i++) {
		array_push(self.pg_string_keys_ordered, _keysNames[i])
	}
	
	//show_debug_message(json_stringify(self.pg_string_keys_ordered))
	playgama_bridge_storage_get(json_stringify(self.pg_string_keys_ordered))
}

#endregion



#region Методы отправки данных



///@func met_send_data
///@desc Сохраняет данные data на сервер яндекса, либо в локальные файлы при тесте
///@param {Struct} _struct Передаваемая структура для сохранения
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_send_data = function(_struct, _callback = undefined, _callbackFailed = undefined)
{
	var _structToSend = variable_clone(_struct)
	
	if (YG.is_release_build && YG_MODE == E_YG_MODE.PLAYGAMA) 
	{
		__met_send_data_pg(_struct, _callback, _callbackFailed)
	}
	else if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_sendData = YaGames_Player_SetData(json_stringify(_structToSend))
		
		sendData_callback = _callback
		sendData_callback_failed = _callbackFailed
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
	if (!YG.storage.stats.is_supported)
		show_error("yg_data : met_send_stats() -> Stats недоступны на этой платформе", true)
	
	
	var _structToSend = variable_clone(_struct)
	
	if (YG.is_release_build && YG_SAVING_ACTIVE) 
	{
		reqId_sendStats = YaGames_Player_SetStats(json_stringify(_structToSend))
		
		sendStats_callback = _callback
		sendStats_callback_failed = _callbackFailed
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
	if (!YG.storage.stats.is_supported)
		show_error("yg_data : met_send_stats() -> Stats недоступны на этой платформе", true)
	
	
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
		show_debug_message("yg_data -> met_delete_all_stats : Saves Inactive")
	}
}

#endregion


#region Методы получения данных

///@func __met_append_getted_data
///@ignore
__met_append_getted_data = function(_gettedStruct, _targetStruct) {
	var _dataKeys = struct_get_names(_gettedStruct)
	
	for (var i=0; i<array_length(_dataKeys); i++) {
		var _key = _dataKeys[i]
		var _value = _gettedStruct[$ _key]
				
		_targetStruct[$ _key] = _value
	}
}

///@func met_get_all_data
///@desc Асинхронно получает данные сохранений data с сервера яндекса. Результат запишется в структуру YG.data. Можно указать коллбек, выполнится при получении
///@param {Function} _callback Коллбек при успешном получении сейвов
///@param {Function} _callbackFailed Коллбек при неудаче
met_get_all_data = function(_callback = undefined, _callbackFailed = undefined) 
{
	if (YG.is_release_build && YG_MODE == E_YG_MODE.PLAYGAMA) 
	{
		__met_get_data_pg(_callback, _callbackFailed)
	}
	else if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_getData = YaGames_Player_GetAllData()
		
		getData_callback = _callback
		getData_callback_failed = _callbackFailed
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE) 
	{
		with {_callback, _callbackFailed} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function() {
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				var _struct = struct_get_from_file(YG_DATA_FILENAME)
				
				if (struct_names_count(_struct) > 0)
					__ygData.__met_append_getted_data(_struct, YG.data)
				
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
	if (!YG.storage.stats.is_supported)
		show_debug_message("yg_data : met_get_all_stats -> Stats недоступны на этой платформе", true)
	
	
	if (YG.is_release_build && YG_SAVING_ACTIVE)
	{
		reqId_getStats = YaGames_Player_GetAllStats()
		
		getStats_callback = _callback
		getStats_callback_failed = _callbackFailed
	}
	else if (!YG.is_release_build && YG_SAVING_DEBUG_ACTIVE)
	{
		with {_callback, _callbackFailed} call_later(YG_SAVING_DEBUG_PERIOD, time_source_units_seconds, function(){
			if (!YG_SAVING_DEBUG_GENERATE_ERROR_GET)
			{
				var _struct = struct_get_from_file(YG_STATS_FILENAME)
				
				if (struct_names_count(_struct) > 0)
					__ygData.__met_append_getted_data(_struct, YG.stats)
				
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