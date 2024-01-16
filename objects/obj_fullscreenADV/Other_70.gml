if ((async_load[? "type"] == "YaGames") and (async_load[? "request_id"] == req_id)) 
{
	switch (async_load[? "event"]) 
	{
        case "adClosed":
			adv_state = ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
			audio_resume_all()
        break;
		
        case "adOpened":
			adv_state = ADV_STATE.SHOWING_ADV
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