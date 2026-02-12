#macro YG global.__YG

global.__YG = {
	data  : {},
	stats : {},
	flags : {},
	
	lang				 : YG_DEBUG_LANGUAGE,
	device_type			 : E_DEVICE_TYPE.PC,
	is_release_build	 : GM_build_type == "exe",
	
	storage : {
		data : {
			///@func send
			///@desc Сохраняет данные data на сервер яндекса, либо в локальные файлы при тесте
			///@param {Struct} _dataStruct Структура для сохранения
			///@param {Function} _callback Коллбек при успешном получении сейвов
			///@param {Function} _callbackFailed Коллбек при неудаче
			send : function(_dataStruct = YG.data, _callback = undefined, _callbackFailed = undefined) 
			{ return __ygData.met_send_data(_dataStruct, _callback, _callbackFailed) },
			
			///@func get
			///@desc Асинхронно получает данные сохранений data с сервера яндекса. Результат запишется в структуру YG.data. Можно указать коллбек, выполнится при получении
			///@param {Function} _callback Коллбек при успешном получении сейвов
			///@param {Function} _callbackFailed Коллбек при неудаче
			get  : function(_callback = undefined, _callbackFailed = undefined) 
			{ return __ygData.met_get_all_data(_callback, _callbackFailed) },
			
			///@func deleteAll
			///@desc Отправляет на сервер яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
			deleteAll : function() 
			{ return __ygData.met_delete_all_data() }
		},
		
		stats : {
			is_supported : true, // Для Yandex Games SDK всегда true, для PlayGama всегда false
			
			///@func send
			///@desc Сохраняет данные stats на сервер яндекса, либо в локальные файлы при тесте
			///@param {Struct} _statsStruct Коллбек при успешном получении сейвов
			///@param {Function} _callback Коллбек при успешном получении сейвов
			///@param {Function} _callbackFailed Коллбек при неудаче
			send : function(_statsStruct = YG.stats, _callback = undefined, _callbackFailed = undefined) 
			{ return __ygData.met_send_stats(_statsStruct, _callback, _callbackFailed) },
			
			///@func get
			///@desc Асинхронно получает данные сохранений stats с сервера яндекса. Результат запишется в структуру YG.stats. Можно указать коллбек, выполнится при получении
			///@param {Function} _callback Коллбек при успешном получении сейвов
			///@param {Function} _callbackFailed Коллбек при неудаче
			get  : function(_callback = undefined, _callbackFailed = undefined) 
			{ return __ygData.met_get_all_stats(_callback, _callbackFailed) },
			
			///@func deleteAll
			///@desc Отправляет на сервер яндекса пустую структуру stats, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл
			deleteAll : function() 
			{ return __ygData.met_delete_all_stats() }
		}
	},
	
	adv : {
		///@func is_active
		///@desc Возвращает, показывается ли сейчас реклама, или предупреждение о скором показе рекламы, или ревард, или ожидается ответ сервера на запрос показать ревард
		is_active : function() { return __ygAdv.met_is_adv_active() },
		
		interstitial : {
			is_supported : true, // Для Yandex Games SDK всегда true
			
			///@func is_showable
			///@desc Возвращает, прошло ли достаточно времени, чтобы можно было показать рекламу
			is_showable : function() { return __ygAdv.met_is_inter_showable() },
			
			///@func show
			///@desc Показать полноэкранную рекламу
			///@param {Function} _callback коллбек, выполнится когда игрок закроет рекламу
			///@param {Bool} _showWarning если true - запускает предупреждение о скором показе рекламы, а через 2 секунды саму рекламу. False по умолчанию
			show : function(_callback = undefined, _showWarning = false) 
			{ return __ygAdv.met_show_inter(_showWarning, _callback) }
		},
		
		reward : {
			is_supported : true, // Для Yandex Games SDK всегда true
			
			///@func show
			///@desc Запускает ревард. В аргументе указывается метод/функция, которая выполнится при успешном просмотре реварда
			///@param {Function} _callback коллбек, если игрок досмотрел рекламу
			///@param {Function} _callbackWithoutReward коллбек, если игрок закрыл рекламу прежде чем она закончилась
			show : function(_callback, _callbackWithoutReward = undefined) 
			{ return __ygAdv.met_show_reward(_callback, _callbackWithoutReward) }
		},
		
		banner : {
			is_supported : true,
			is_active : false,
			position : E_BANNER_PG_POS.BOTTOM,
			
			///@func show
			///@desc Показывает стики баннер
			///@param {Constant.E_BANNER_PG_POS} _pgBannerPosEnum позиция (E_BANNER_PG_POS.BOTTOM по умолчанию)
			show : function(_pgBannerPosEnum = E_BANNER_PG_POS.BOTTOM)
			{ return __ygAdv.met_show_banner(_pgBannerPosEnum) },
			
			///@func hide
			///@desc Скрывает стики баннер
			hide : function()
			{ return __ygAdv.met_hide_banner() },
			
			///@func get_height_playgama
			///@desc Возвращает высоту баннера с учётом размера экрана с игрой
			get_height_playgama : function()
			{ if (!instance_exists(__ygAdv)) return 0; return __ygAdv.met_banner_get_height_playgama() }
		}
	},
	
	audio : {
		///@func getVolume
		///@desc Возвращает уровень громкости главного аудиоканала (без учёта отключения звука во время рекламы)
		getVolume : function()
		{ return __ygAudio.met_get_volume() },
		
		///@func setVolume
		///@param {Real} _value
		///@desc Устанавливает уровень громкости для главного аудиоканала (без учёта отключения звука во время рекламы)
		setVolume : function(_value)
		{ return __ygAudio.met_set_volume(_value) },
	},
	
	platform : {
		id : PG_PLATFORM_YANDEX, // type : PG_PLATFORM_*
		
		is_audio_enabled : true, // Всегда true для Yandex Games SDK
		is_paused : false,
		is_visible : true // Всегда true для Yandex Games SDK
	},
}



enum E_YG_MODE
{
	YANDEX_GAMES,
	PLAYGAMA
}

enum E_DEVICE_TYPE
{
	PC,
	MOBILE
}



#macro PG_PLATFORM_PLAYGAMA				"playgama"
#macro PG_PLATFORM_VK					"vk"
#macro PG_PLATFORM_OK					"ok"
#macro PG_PLATFORM_YANDEX				"yandex"
#macro PG_PLATFORM_FACEBOOK				"facebook"
#macro PG_PLATFORM_CRAZY_GAMES			"crazy_games"
#macro PG_PLATFORM_GAME_DISTRIBUTION	"game_distribution"
#macro PG_PLATFORM_PLAYDECK				"playdeck"
#macro PG_PLATFORM_TELEGRAM				"telegram"
#macro PG_PLATFORM_Y8					"y8"
#macro PG_PLATFORM_LAGGED				"lagged"
#macro PG_PLATFORM_MSN					"msn"
#macro PG_PLATFORM_POKI					"poki"
#macro PG_PLATFORM_QA_TOOL				"qa_tool"
#macro PG_PLATFORM_DISCORD				"discord"
#macro PG_PLATFORM_GAMEPUSH				"gamepush"
#macro PG_PLATFORM_BITQUEST				"bitquest"
#macro PG_PLATFORM_HUAWEI				"huawei"
#macro PG_PLATFORM_JIO_GAMES			"jio_games"
#macro PG_PLATFORM_REDDIT				"reddit"
#macro PG_PLATFORM_YOUTUBE				"youtube"
#macro PG_PLATFORM_MOCK					"mock"



#region Остаточная инициализация

if (YG_MODE == E_YG_MODE.PLAYGAMA && YG.is_release_build) {
	YG.lang								= playgama_bridge_platform_language()
	
	YG.adv.interstitial.is_supported	= bool(playgama_bridge_advertisement_is_interstitial_supported())
	YG.adv.reward.is_supported			= bool(playgama_bridge_advertisement_is_rewarded_supported())
	YG.adv.banner.is_supported			= bool(playgama_bridge_advertisement_is_banner_supported())
	
	YG.storage.stats.is_supported		= false
	
	YG.platform.id						= playgama_bridge_platform_id() // type : PG_PLATFORM_*
	YG.platform.is_audio_enabled		= playgama_bridge_platform_is_audio_enabled()
	YG.platform.is_visible				= (playgama_bridge_game_visibility_state() == "visible")
}

switch (os_type)
{
	case os_windows:
	case os_linux:
	case os_macosx:
		YG.device_type = E_DEVICE_TYPE.PC
	break;
	
	default:
		YG.device_type = E_DEVICE_TYPE.MOBILE
	break;
}
	
#endregion