///@desc

is_audio_system_initialized = audio_system_is_available()
game_is_paused = false

can_play_audio = false

volume = 1


///@func met_set_volume
///@param {Real} _value
///@desc Установить уровень громкости для главного аудиоканала (без учёта отключения звука во время рекламы)
met_set_volume = function(_value) {
	volume = _value
}

///@func met_get_volume
/// Возвращает уровень громкости (без учёта отключения звука во время рекламы)
met_get_volume = function() {
	return volume
}


///@func met_play_audio
///@desc Аналог audio_play_sound
met_play_audio = function(_soundId, _priority, _loop, _gain = 1, _offset = 0, _pitch = 1)
{
	if (!can_play_audio) then exit;
	
	return audio_play_sound(_soundId, _priority, _loop, _gain, _offset, _pitch)
}


#region Ignore

///@ignore
__met_api_pause = function() {
	game_is_paused = true
	show_debug_message("-- CallGameApiPause")
}

///@ignore
__met_api_resume = function() {
	game_is_paused = false
	show_debug_message("-- CallGameApiResume")
}

#endregion