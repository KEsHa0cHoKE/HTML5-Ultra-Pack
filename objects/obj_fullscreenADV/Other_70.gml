if ((async_load[? "type"] == "YaGames") and (async_load[? "request_id"] == req_id)) 
{
	switch (async_load[? "event"]) 
	{
        case "adClosed":
			alarm[0] = 105*game_speed
			audio_resume_all()
        break;
		
        case "adOpened":
			can_show = false
			audio_pause_all()
        break;

        case "offlineMode":
		
        break;

        case "adError":

        break;

        case "notInitSDK":

        break;

        case "RuntimeError":

        break;
    }
}