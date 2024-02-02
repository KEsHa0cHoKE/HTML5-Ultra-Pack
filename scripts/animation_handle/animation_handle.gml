///@desc Анимирует переменную объекта, используя для контроля анимации его переменную-состояние анимации, 
///которая принимается в первом аргументе в формате названия переменной в виде строки. 
///Ее состояния могут быть: 0/false -> не анимируется, 1/true -> первая стадия, 2 -> вторая стадия. 
///Второй аргумент принимает название/массив названий переменных в виде строк, которые нужно анимировать. 
///Эту функцию необходимо вставить в step-эвент объекта и менять 
///переменную-состояние анимации объекта на true тогда, когда необходимо проиграть анимацию.
function animation_handle(_varAnimStateString, _varToAnimateString, _firstValue, _secondValue, _spd/*, _lerpMultiplier = 1*/)
{
	var _animState	= variable_instance_get(id, _varAnimStateString)
	var _valueOfAnimatedVar = variable_instance_get(id, _varToAnimateString)
	
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
					variable_instance_set(id, _varAnimStateString, 2)
					
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
					variable_instance_set(id, _varAnimStateString, 2)
					
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
					variable_instance_set(id, _varAnimStateString, 0)
					
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
					variable_instance_set(id, _varAnimStateString, 0)
					
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
				}
			}
			else // Если второе значение равно первому
			{
				variable_instance_set(id, _varToAnimateString, _secondValue)
				variable_instance_set(id, _varAnimStateString, 0)
			}
		}
	}
}