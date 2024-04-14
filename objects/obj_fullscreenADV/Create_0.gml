req_id = YaGames_showFullscreenAdv()

enum E_ADV_STATE
{
	CANNOT_SHOW,
	CAN_SHOW,
	SHOWING_WARNING,
	SHOWING_ADV
}
adv_state = E_ADV_STATE.CANNOT_SHOW

adv_periodicity_in_sec = 105
game_speed = game_get_speed(gamespeed_fps)
fnt = fnt_YaGamesInit

///@desc Возвращает, прошло ли достаточно времени, чтобы можно было показать рекламу
met_is_adv_showable = function()
{
	return (adv_state == E_ADV_STATE.CAN_SHOW)
}

///@desc Запускает предупреждение о скором показе рекламы, а через 3 секунды саму рекламу
met_show_adv = function()
{
	if (met_is_adv_showable())
	{
		adv_state = E_ADV_STATE.SHOWING_WARNING
		alarm[1] = 3*game_speed
	}
}

///@desc Возвращает, показывается ли сейчас реклама или предупреждение о скором показе рекламы
met_is_adv_active = function()
{
	return (adv_state >= E_ADV_STATE.SHOWING_WARNING)
}