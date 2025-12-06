///@desc Запуск рекламы

// Feather disable GM1063
req_id = YG.is_release_build ?
(YG_MODE == E_YG_MODE.YANDEX_GAMES ? YaGames_showFullscreenAdv() : playgama_bridge_advertisement_show_interstitial()) :
__met_create_fakeInter()