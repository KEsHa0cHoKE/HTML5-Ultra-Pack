#region Настройки

fullscreen = true
adv_periodicity_in_sec = 91

#endregion

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

req_id = YaGames_showFullscreenAdv()
req_idReward = undefined

var _isWindows = (os_browser == browser_not_a_browser)
adv_state = (_isWindows ? E_ADV_STATE.CANNOT_SHOW : E_ADV_STATE.SHOWING_ADV)
reward_state = E_REWARD_STATE.NOT_SHOW

game_speed = game_get_speed(gamespeed_fps)
fnt = __fntYG

///@func met_is_inter_showable()
///@desc Возвращает, прошло ли достаточно времени, чтобы можно было показать рекламу
met_is_inter_showable = function()
{
	return (adv_state == E_ADV_STATE.CAN_SHOW)
}

///@func met_show_inter([_showWarning], [_callback])
///@desc Если true в аргументе то запускает предупреждение о скором показе рекламы, а через 3 секунды саму рекламу.
///Если указать в аргументе false, то запускает рекламу без предупреждения
inter_callback = undefined
met_show_inter = function(_showWarning = true, _callback = undefined)
{
	if (met_is_inter_showable())
	{
		if (os_browser == browser_not_a_browser)
		{
			adv_state = E_ADV_STATE.CANNOT_SHOW
			alarm[0] = adv_periodicity_in_sec*game_speed
			exit;
		}
		
		if (_showWarning)
		{
			adv_state = E_ADV_STATE.SHOWING_WARNING
			alarm[1] = 2*game_speed
		}
		else
		{
			adv_state = E_ADV_STATE.SHOWING_ADV
			alarm[1] = 1
		}
		
		if (is_callable(_callback))
		{
			inter_callback = _callback
		}
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