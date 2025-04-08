is_audio_system_initialized = audio_system_is_available()
can_play_audio = false


///@func met_play_audio
met_play_audio = function(_soundId, _priority, _loop, _gain = 1, _offset = 0, _pitch = 1)
{
	if (!can_play_audio) then exit;
	if (instance_exists(yg_adv) && yg_adv.met_is_adv_active()) then exit;
	
	return audio_play_sound(_soundId, _priority, _loop, _gain, _offset, _pitch)
}