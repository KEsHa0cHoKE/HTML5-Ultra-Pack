///@desc Конструктор, отвечающий за анимацию.
///Переменные для анимации необходимо добавлять в 
///экземпляр конструктора через метод met_add_var.
///Состояния анимации (var_state): 0/false -> не анимируется | >=1/true -> анимируется.
function class_animation() constructor
{
	#region Переменные
	
	// Хранит состояние анимации в формате int. 
	// Содержит число от 0 (не анимируется) до максимального кол-ва ключевых значений анимации
	var_state					= false
	
	// Хранит id экземпляра объекта, к которому привязан экземпляр конструктора
	var_target_instance_id		= undefined
	// Хранит название анимируемых переменных в виде строки
	var_names_to_anim			= []
	
	// Хранят в себе скорость анимации (значение, прибавляемое за один кадр) 
	// при ее активном исполнении. При завершении анимации вновь становятся undefined
	var_speed_frames			= undefined
	var_speed_frames_overall	= undefined
	var_speed_time				= undefined
	var_speed_time_overall		= undefined
	
	// Хранит в себе метод/функцию которая будет исполнена при окончании анимации (опционально)
	var_callback_method			= undefined
	
	#endregion
	
	
	#region Методы
	
		#region Массив переменных для анимации
	
		///@desc Добавляет переменную/массив переменных для их последующей анимации
		///@arg {Id.Instance} _id id экземпляра объекта
		///@arg {Any} _varsString имя/массив имен переменных для добавления
		met_vars_add = function(_id, _varsString)
		{
			target_instance_id = _id
		
			if (!is_array(_varsString))
			{
				array_push(var_names_to_anim, _varsString)
				var _value = variable_instance_get(_id, _varsString)
			}
			else
			{
				for (var i=0; i<array_length(_varsString); i++)
				{
					array_push(var_names_to_anim, _varsString[i])
					var _value = variable_instance_get(_id, _varsString[i])
				}
			}
		}
	
		///@desc Очищает массив анимируемых переменных
		met_vars_clear = function()
		{
			array_resize(var_names_to_anim, 0)
		}
	
		#endregion
		
		
		#region Callback
	
		///@desc Устанавливает функцию/метод, которая будет выполнена при окончании анимации
		met_callback_set = function(_methodOrFunc)
		{
			if (!is_callable(_methodOrFunc))
			{
				show_error("Ошибка в met_callback_set. Аргумент не является методом/функцией", true)
			}
		
			var_callback_method = method(undefined, _methodOrFunc)
		}
	
		///@desc Сбрасывает установленную функцию/метод
		met_callback_clear = function()
		{
			var_callback_method = undefined
		}
	
		#endregion
		
		
		#region Контроль анимации
	
		///@desc Запускает анимацию
		met_control_start = function()
		{
			var_state = 1
		}
	
		///@desc Принудительно завершает анимацию. 
		///Анимируемые переменные остаются в состоянии на момент принудительного завершения
		met_control_end = function()
		{
			var_state = 0
		}
		
		///@desc Сбрасывает установленную скорость для ее перерасчета
		///с текущего значения анимируемой переменной
		met_control_speed_reset = function()
		{
			var_speed_frames			= undefined
			var_speed_frames_overall	= undefined
			var_speed_time				= undefined
			var_speed_time_overall		= undefined
		}
	
		#endregion
		
		
		#region Обработка анимаций (вставлять эти методы в степ объекта)
	
		///@desc Анимирует переменные, используя скорость анимации. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		met_anim_speed = function(_valuesArray, _spd)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
			
			if (_value < _targetValue)
			{
				_value += _spd
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= _spd
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value == _targetValue)
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			}
		}
	
		///@desc Анимирует переменные, используя кол-во кадров, за которое должно достигаться одно значение. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		met_anim_frames = function(_valuesArray, _frames)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
		
			if (is_undefined(var_speed_frames))
			{
				var_speed_frames = abs(_targetValue-_value)/_frames
			}
			
			if (_value < _targetValue)
			{
				_value += var_speed_frames
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_frames = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_frames
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_frames = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value == _targetValue)
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
					var_speed_frames = undefined
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			}
		}
	
		///@desc Анимирует переменные, используя кол-во кадров, за которое должна проиграться вся анимация. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		met_anim_frames_overall = function(_valuesArray, _frames)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
		
			if (is_undefined(var_speed_frames_overall))
			{
				var_speed_frames_overall = (abs(_targetValue-_value)/_frames)*array_length(_valuesArray)
			}
			
			if (_value < _targetValue)
			{
				_value += var_speed_frames_overall
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_frames_overall = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_frames_overall
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_frames_overall = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value == _targetValue)
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
					var_speed_frames_overall = undefined
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			}
		}
	
		///@desc Анимирует переменные, используя время в секундах, за которое должно достигаться одно значение. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		met_anim_time = function(_valuesArray, _seconds)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
		
			if (is_undefined(var_speed_time))
			{
				var_speed_time = abs(_targetValue-_value)/(_seconds*game_get_speed(gamespeed_fps))
			}
			
			if (_value < _targetValue)
			{
				_value += var_speed_time
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_time = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_time
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_time = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value == _targetValue)
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
					var_speed_time = undefined
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			}
		}
	
		///@desc Анимирует переменные, используя время в секундах, за которое должна проиграться вся анимация. 
		///Первый аргумент принимает массив значений для анимации.
		met_anim_time_overall = function(_valuesArray, _seconds)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
		
			if (is_undefined(var_speed_time_overall))
			{
				var_speed_time_overall = (abs(_targetValue-_value)/(_seconds*game_get_speed(gamespeed_fps)))*array_length(_valuesArray)
			}
			
			if (_value < _targetValue)
			{
				_value += var_speed_time_overall
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_time_overall = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_time_overall
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					if (++var_state > array_length(_valuesArray))
					{
						var_state = 0
						var_speed_time_overall = undefined
					
						if (!is_undefined(var_callback_method))
						{
							var_callback_method()
						}
					}
				}

				_updateVarsValues(_value)
			}
			else if (_value == _targetValue)
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
					var_speed_time_overall = undefined
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			}
		}
	
		///@desc Анимирует переменные, используя множитель интерполяции. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		///Третий - максимальную разницу в значениях при достижении которой значение сразу меняется на целевое
		met_anim_lerp = function(_valuesArray, _lerp, _maxDifference = 0.01)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в met_anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
		
			var _updateVarsValues = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
			
			if (abs(_targetValue-_value) > _maxDifference)
			{
				_value = lerp(_value, _targetValue, _lerp)

				_updateVarsValues(_value)
			}
			else
			{	
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
				
					if (!is_undefined(var_callback_method))
					{
						var_callback_method()
					}
				}
			
				_updateVarsValues(_targetValue)
			}
		}
	
		#endregion
		
	#endregion
}