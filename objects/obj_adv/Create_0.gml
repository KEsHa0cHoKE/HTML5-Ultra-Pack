#region Настройки

fullscreen = true
adv_periodicity_in_sec = 95

#endregion

req_id = YaGames_showFullscreenAdv()
req_idReward = undefined

enum E_ADV_STATE
{
	CANNOT_SHOW,
	CAN_SHOW,
	SHOWING_WARNING,
	SHOWING_ADV
}
enum E_REWARD_STATE
{
	NOT_SHOW,
	SENDED_REQUEST,
	SHOWING
}
adv_state = E_ADV_STATE.SHOWING_ADV
reward_state = E_REWARD_STATE.NOT_SHOW

game_speed = game_get_speed(gamespeed_fps)
fnt = fnt_YaGamesInit

///@func met_is_inter_showable()
///@desc Возвращает, прошло ли достаточно времени, чтобы можно было показать рекламу
met_is_inter_showable = function()
{
	return (adv_state == E_ADV_STATE.CAN_SHOW)
}

///@func met_show_inter()
///@desc Запускает предупреждение о скором показе рекламы, а через 3 секунды саму рекламу
met_show_inter = function()
{
	if (met_is_inter_showable())
	{
		adv_state = E_ADV_STATE.SHOWING_WARNING
		alarm[1] = 3*game_speed
	}
}

///@func met_is_adv_active()
///@desc Возвращает, показывается ли сейчас реклама или предупреждение о скором показе рекламы или ревард
met_is_adv_active = function()
{
	return (adv_state >= E_ADV_STATE.SHOWING_WARNING || reward_state > E_REWARD_STATE.NOT_SHOW)
}


reward_callback = undefined
///@func met_show_reward(_callBack)
///@desc Запускает ревард. В аргументе указывается метод/функция, которая выполнится при успешном просмотре реварда
met_show_reward = function(_callBack)
{
	req_idReward = YaGames_showRewardedVideo()
	reward_state = E_REWARD_STATE.SENDED_REQUEST
	
	if (is_callable(_callBack))
	{
		reward_callback = method(id, _callBack)
	}
	else
	{
		show_error("Указанный аргумент в методе met_show_reward не является методом/функцией", true)
	}
}