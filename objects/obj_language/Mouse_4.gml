image_index = !image_index

global.lang = (global.lang == "ru" ? "en" : "ru")

if (!is_undefined(sound))
{
	audio_play_sound(sound, 0, false)
}