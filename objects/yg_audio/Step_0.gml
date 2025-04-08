if (!is_audio_system_initialized)
{
	is_audio_system_initialized = audio_system_is_available()
	can_play_audio = is_audio_system_initialized
}