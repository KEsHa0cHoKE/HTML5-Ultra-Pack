///@desc

is_audio_system_initialized = audio_system_is_available()

can_play_audio = false

volume = 1


///@func met_set_volume
///@param {Real} _value
///@desc Установить уровень громкости для главного аудиоканала (без учёта отключения звука во время рекламы)
met_set_volume = function(_value) {
	volume = _value
}

///@func met_get_volume
///@desc Возвращает уровень громкости (без учёта отключения звука во время рекламы)
met_get_volume = function() {
	return volume
}