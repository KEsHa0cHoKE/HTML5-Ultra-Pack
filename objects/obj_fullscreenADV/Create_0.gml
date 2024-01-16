req_id = YaGames_showFullscreenAdv()

enum ADV_STATE
{
	CANNOT_SHOW,
	CAN_SHOW,
	SHOWING_WARNING,
	SHOWING_ADV
}
adv_state = ADV_STATE.CANNOT_SHOW

adv_periodicity_in_sec = 105
game_speed = game_get_speed(gamespeed_fps)
fnt = fnt_YaGamesInit

method_show_adv = function()
{
	event_perform(ev_other, ev_user0)
}

method_is_adv_showable = function()
{
	return (adv_state == ADV_STATE.CAN_SHOW)
}