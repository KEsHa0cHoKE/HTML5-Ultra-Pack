if (!is_audio_system_initialized)
{
	is_audio_system_initialized = audio_system_is_available()
	exit;
}


var _isAdvActive = (yg_adv.met_is_adv_active())
can_play_audio = (!_isAdvActive && !game_is_paused)

audio_master_gain(can_play_audio ? volume : 0)