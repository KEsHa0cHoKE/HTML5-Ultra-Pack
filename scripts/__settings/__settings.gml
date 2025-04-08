function __settings()
{
	#macro YG_FIRST_ROOM						__rmInit // Стартовая комната вашей игры
	#macro YG_DEBUG_LANGUAGE					"ru" // Язык, который будет использован для тестовых билдов и помещён в YG.lang
	
	#macro YG_SAVING_ACTIVE						true // Сохранять данные на сервер в релизном билде
	
	#macro YG_SAVING_DEBUG_ACTIVE				true // Имитировать сохранение/загрузку прогресса на сервер в тестовом билде (сохраняет сейвы в локальные файлы)
	#macro YG_SAVING_DEBUG_PERIOD				1 // Время сохранения данных в секундах, используемое для имитации задержки перед присланным ответом от сервера в тестовом билде
	#macro YG_SAVING_DEBUG_GENERATE_ERROR_SEND	false // Имитировать ошибку сохранения данных на сервер в режиме тестового билда
	#macro YG_SAVING_DEBUG_GENERATE_ERROR_GET	false // Имитировать ошибку получения данных с сервера в режиме тестового билда
												
	#macro YG_DATA_FILENAME						"__data.json" // Имя файла data для дебаг сейвов
	#macro YG_STATS_FILENAME					"__stats.json" // Имя файла stats для дебаг сейвов
												
	#macro YG_ACTIVE_CAMERA_ON					false // Использует ли игра активную камеру (!В РАЗРАБОТКЕ!)
	
	
	// Инициализация сейвов
	var _ygData = { /* Вставьте сюда дефолтные значения, которые будут помещены в YG.data, если сейвов на сервере нет */ }
	var _ygStats = { /* Вставьте сюда дефолтные значения, которые будут помещены в YG.stats, если сейвов на сервере нет */ }
	
	// Дефолтные флаги
	var _ygFlagsDefault = { /* Вставьте сюда дефолтные значения, которые будут использованы, если нужные флаги не пришли с сервера */ }
	
	
	
	#region НЕ МЕНЯТЬ ЗНАЧЕНИЯ (здесь можете увидеть, из чего состоит структура доступных после инициализации данных)
	
	globalvar YG;
	YG = {
		data : _ygData,
		stats : _ygStats,
		flags : _ygFlagsDefault,
		lang : "ru",
		device_type : E_DEVICE_TYPE.PC,
		is_release_build : (os_browser != browser_not_a_browser && GM_build_type == "exe")
	}
	
	enum E_DEVICE_TYPE
	{
		PC,
		MOBILE
	}
	
	#endregion
}