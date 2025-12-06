if (!is_audio_system_initialized)
{
	is_audio_system_initialized = audio_system_is_available()
	exit;
}

can_play_audio = (!YG.adv.is_active() && !YG.platform.is_paused &&
YG.platform.is_visible && YG.platform.is_audio_enabled)

audio_master_gain(can_play_audio ? volume : 0)