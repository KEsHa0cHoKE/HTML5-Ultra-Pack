///@desc Конструктор, отвечающий за анимацию.
///Состояния анимации (var_state): 0/false -> не анимируется | >=1/true -> анимируется.
function class_animation(_id, _varsStringToAnimate) constructor
{
	#region Переменные
	
	// Хранит состояние анимации в формате int. 
	// Содержит число от 0 (не анимируется) до максимального кол-ва ключевых значений анимации
	var_state					= 0
	
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
	
	// Массив хранит в себе методы/функции которые будут выполнены на указанных стадиях анимации (опционально)
	var_callback_methods		= []
	
	// Макрос на случай, если необходимо добавить метод к концу анимации
	#macro						  ANIM_END -1
	// Хранит метод/функцию для использования в конце анимации
	var_callback_method_animEnd = undefined
	
	#endregion
	
	
	#region Методы
	
		#region Массив переменных для анимации
		
		///@func met_vars_add(_id, _varsString)
		///@desc Добавляет переменную/массив переменных для их последующей анимации
		///@arg {Id.Instance} _id id экземпляра объекта
		///@arg {Any} _varsString имя/массив имен переменных для добавления
		static met_vars_add = function(_id, _varsString)
		{
			target_instance_id = _id
			
			if (!is_array(_varsString))
			{
				if (!is_string(_varsString))
				{
					show_error("Ошибка в met_vars_add. Предоставленное значение/значения не являются НАЗВАНИЕМ переменной в формате строки. Используйте функцию nameof() для добавления переменных", true)
				}
				
				array_push(var_names_to_anim, _varsString)
				var _value = variable_instance_get(_id, _varsString)
			}
			else
			{
				if (!is_string(_varsString[0]))
				{
					show_error("Ошибка в met_vars_add. Предоставленное значение/значения не являются НАЗВАНИЕМ переменной в формате строки. Используйте функцию nameof() для добавления переменных", true)
				}
				
				for (var i=0; i<array_length(_varsString); i++)
				{
					array_push(var_names_to_anim, _varsString[i])
					var _value = variable_instance_get(_id, _varsString[i])
				}
			}
		}
		
		///@func met_vars_clear()
		///@desc Очищает массив анимируемых переменных
		static met_vars_clear = function()
		{
			array_resize(var_names_to_anim, 0)
		}
		
		///@func met_vars_is_anim_active()
		///@desc Возвращает, воспроизводится ли анимация
		static met_vars_is_anim_active = function()
		{
			return (var_state > 0)
		}
	
		#endregion
		
		
		#region Callback
		
		///@func met_callback_set(_keyframe, _methodOrFunc)
		///@desc Устанавливает функцию/метод, который будет выполнен на предоставленном в первом аргументе
		///ключевом кадре анимации. Индексация начинается с 0.
		///Если необходимо связать метод с концом анимации, в аргументе _keyframe можно использовать
		///макрос ANIM_END или просто значение -1
		///@arg {Real} _keyframe Ключевой кадр. Если конец анимации то ANIM_END или -1
		///@arg {Function} _methodOrFunc Функция/метод
		static met_callback_set = function(_keyframe, _methodOrFunc)
		{
			if (!is_callable(_methodOrFunc))
			{
				show_error("Ошибка в met_callback_set. Аргумент не является методом/функцией", true)
			}
			
			if (_keyframe == ANIM_END)
			{
				var_callback_method_animEnd = method(undefined, _methodOrFunc)
				exit;
			}
		
			var_callback_methods[_keyframe] = method(undefined, _methodOrFunc)
		}
		
		///@func met_callback_delete(_keyframe)
		///@desc Удаляет функцию/метод, привязанный к кадру анимации
		static met_callback_delete = function(_keyframe)
		{
			if (_keyframe == ANIM_END)
			{
				var_callback_method_animEnd = undefined
				exit;
			}
			
			if (_keyframe > array_length(var_callback_methods)-1)
			{
				show_error("Ошибка в met_callback_delete. Попытка удалить значение, которое больше чем кол-во ключевых кадров анимации", true)
			}
			
			var_callback_methods[_keyframe] = undefined
		}
		
		///@func met_callback_clear()
		///@desc Сбрасывает ВСЕ установленные функции/методы
		static met_callback_clear = function()
		{
			array_resize(var_callback_methods, 0)
			
			var_callback_method_animEnd = undefined
		}
		
		#endregion
		
		
		#region Контроль анимации
		
		///@func met_control_start()
		///@desc Запускает анимацию
		static met_control_start = function()
		{
			var_state = 1
		}
		
		///@func met_control_end()
		///@desc Принудительно завершает анимацию. 
		///Анимируемые переменные остаются в состоянии на момент принудительного завершения
		static met_control_end = function()
		{
			var_state = 0
		}
		
		///@func met_control_speed_reset()
		///@desc Сбрасывает установленную скорость для ее перерасчета
		///с текущего значения анимируемой переменной
		static met_control_speed_reset = function()
		{
			var_speed_frames			= undefined
			var_speed_frames_overall	= undefined
			var_speed_time				= undefined
			var_speed_time_overall		= undefined
		}
	
		#endregion
		
		
		#region Обработка анимаций (вставлять эти методы в степ объекта)
			
			#region Вспомогательные методы (!!!НЕ ДЛЯ ИСПОЛЬЗОВАНИЯ!!!)
			
			///@ignore
			static __met_next_state = function(_valuesArray)
			{
				if (!is_undefined(var_callback_methods))
				{
					if (
						(array_length(var_callback_methods)-1 >= var_state-1) &&
						(is_callable(var_callback_methods[var_state-1]))
					   )
					{
						method_call(var_callback_methods[var_state-1], [])
					}
				}
			
				if (++var_state > array_length(_valuesArray))
				{
					var_state = 0
				
					if (is_callable(var_callback_method_animEnd))
					{
						var_callback_method_animEnd()
					}
				}
			}
		
			///@ignore
			static __met_update_vars_values = function(_value)
			{
				for (var i=0; i<array_length(var_names_to_anim); i++)
				{
					variable_instance_set(target_instance_id, var_names_to_anim[i], _value)
				}
			}
			
			#endregion
		
		///@func anim_speed(_valuesArray, _spd)
		///@desc Анимирует переменные, используя скорость анимации. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		static anim_speed = function(_valuesArray, _spd)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
			
			if (_value < _targetValue)
			{
				_value += _spd
			
				if (_value >= _targetValue)
				{
					_value = _targetValue
					
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= _spd
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value == _targetValue)
			{	
				__met_next_state(_valuesArray)
			}
		}
		
		///@func anim_frames(_valuesArray, _frames)
		///@desc Анимирует переменные, используя кол-во кадров, за которое должно достигаться одно значение. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		static anim_frames = function(_valuesArray, _frames)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
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
					
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_frames
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value == _targetValue)
			{	
				__met_next_state(_valuesArray)
			}
		}
		
		///@func anim_frames_overall(_valuesArray, _frames)
		///@desc Анимирует переменные, используя кол-во кадров, за которое должна проиграться вся анимация. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		static anim_frames_overall = function(_valuesArray, _frames)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
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
					
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_frames_overall
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value == _targetValue)
			{	
				__met_next_state(_valuesArray)
			}
		}
		
		///@func anim_time(_valuesArray, _seconds)
		///@desc Анимирует переменные, используя время в секундах, за которое должно достигаться одно значение. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		static anim_time = function(_valuesArray, _seconds)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
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
					
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_time
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value == _targetValue)
			{	
				__met_next_state(_valuesArray)
			}
		}
		
		///@func anim_time_overall(_valuesArray, _seconds)
		///@desc Анимирует переменные, используя время в секундах, за которое должна проиграться вся анимация. 
		///Первый аргумент принимает массив значений для анимации.
		static anim_time_overall = function(_valuesArray, _seconds)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
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
					
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value > _targetValue)
			{
				_value -= var_speed_time_overall
				
				if (_value <= _targetValue)
				{
					_value = _targetValue
				
					__met_next_state(_valuesArray)
				}

				__met_update_vars_values(_value)
			}
			else if (_value == _targetValue)
			{	
				__met_next_state(_valuesArray)
			}
		}
		
		///@func anim_lerp(_valuesArray, _lerp, [_maxDifference = 0.01])
		///@desc Анимирует переменные, используя множитель интерполяции. 
		///Первый аргумент принимает массив ключевых значений для анимации.
		///Третий - максимальную разницу в значениях при достижении которой значение сразу меняется на целевое,
		///чтобы избежать длительного "простаивания" анимации на одном значении (по умолчанию - 0.01)
		static anim_lerp = function(_valuesArray, _lerp, _maxDifference = 0.01)
		{
			if (var_state == 0) then exit;
		
			if (array_length(var_names_to_anim) < 1)
			{
				show_error("Ошибка в anim_*. Не заданы переменные для анимации в экземпляре конструктора. Воспользуйтесь методом met_vars_add для их добавления", true)
			}
			
			var _value			= variable_instance_get(target_instance_id, var_names_to_anim[0])
			var _targetValue	= _valuesArray[var_state-1]
			
			if (abs(_targetValue-_value) > _maxDifference)
			{
				_value = lerp(_value, _targetValue, _lerp)

				__met_update_vars_values(_value)
			}
			else
			{	
				__met_next_state(_valuesArray)
			
				__met_update_vars_values(_targetValue)
			}
		}
		
		#endregion
	
	#endregion
	
	met_vars_add(_id, _varsStringToAnimate)
}










///@func animation_handle(_varAnimStateString, _varToAnimateString, _firstValue, _secondValue, _spd)
///@deprecated
///@desc УСТАРЕЛО!!!
///Анимирует переменную объекта, используя для контроля анимации его переменную-состояние анимации, 
///которая принимается в первом аргументе в формате названия переменной в виде строки. 
///Ее состояния могут быть: 0/false -> не анимируется, 1/true -> первая стадия, 2 -> вторая стадия. 
///Второй аргумент принимает название/массив названий переменных в виде строк, которые нужно анимировать. 
///Эту функцию необходимо вставить в step-эвент объекта и менять 
///переменную-состояние анимации объекта на true тогда, когда необходимо проиграть анимацию.
function animation_handle(_varAnimStateString, _varToAnimateString, _firstValue, _secondValue, _spd)
{
	var _animState	= variable_instance_get(id, _varAnimStateString)
	
	var _valueOfAnimatedVar = (
	is_array(_varToAnimateString) ? 
	variable_instance_get(id, _varToAnimateString[0]) : 
	variable_instance_get(id, _varToAnimateString)
	)
	
	if (_animState != 0)
	{
		if (_animState == 1)
		{
			if (_firstValue < _secondValue)
			{
				if (_valueOfAnimatedVar > _firstValue)
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _valueOfAnimatedVar-_spd)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _valueOfAnimatedVar-_spd)
						}
					}
				}
				else
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _firstValue)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _firstValue)
						}
					}
					
					variable_instance_set(id, _varAnimStateString, 2)
				}
			}
			else if (_firstValue > _secondValue)
			{
				if (_valueOfAnimatedVar < _firstValue)
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _valueOfAnimatedVar+_spd)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _valueOfAnimatedVar+_spd)
						}
					}
				}
				else
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _firstValue)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _firstValue)
						}
					}
					
					variable_instance_set(id, _varAnimStateString, 2)
				}
			}
		}
		else if (_animState == 2)
		{
			if (_secondValue < _firstValue)
			{
				if (_valueOfAnimatedVar > _secondValue)
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _valueOfAnimatedVar-_spd)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _valueOfAnimatedVar-_spd)
						}
					}
				}
				else
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _secondValue)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _secondValue)
						}
					}
					
					variable_instance_set(id, _varAnimStateString, 0)
				}
			}
			else if (_secondValue > _firstValue)
			{
				if (_valueOfAnimatedVar < _secondValue)
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _valueOfAnimatedVar+_spd)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _valueOfAnimatedVar+_spd)
						}
					}
				}
				else
				{
					if (!is_array(_varToAnimateString))
					{
						variable_instance_set(id, _varToAnimateString, _secondValue)
					}
					else
					{
						for (var i=0; i<array_length(_varToAnimateString); i++)
						{
							variable_instance_set(id, _varToAnimateString[i], _secondValue)
						}
					}
					
					variable_instance_set(id, _varAnimStateString, 0)
				}
			}
		}
	}
}