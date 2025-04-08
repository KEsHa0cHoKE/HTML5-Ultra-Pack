if (instance_exists(yg_adv) && yg_adv.met_is_adv_active()) then exit;


if ((async_load[? "type"] == YaGames_AsyncEvent) && (async_load[? "request_id"] == YaGames_RequestIdGameApi))
{
	switch (async_load[? "event"]) 
	{
		case YaGames_CallGameApiPause:
			audio_master_gain(0)
			can_play_audio = false
			show_debug_message("-- CallGameApiPause")
		break;
		
		case YaGames_CallGameApiResume:
			audio_master_gain(1)
			can_play_audio = true
			show_debug_message("-- CallGameApiResume")
		break;
	}
}