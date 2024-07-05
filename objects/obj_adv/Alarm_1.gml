///@desc Запуск рекламы
req_id = YaGames_showFullscreenAdv()

if (os_browser == browser_not_a_browser)
{
	adv_state = E_ADV_STATE.CANNOT_SHOW
	alarm[0] = adv_periodicity_in_sec*game_speed
}