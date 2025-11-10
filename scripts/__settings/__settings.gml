///@ignore
function __settings()
{
	#macro YG_FIRST_ROOM						__your_room__ // Стартовая комната вашей игры
	#macro YG_DEBUG_LANGUAGE					"ru" // Язык, который будет использован для тестовых билдов и помещён в YG.lang
	
	#macro YG_SAVING_ACTIVE						true // Сохранять данные на сервер в релизном билде (если false то не сохраняется прогресс в принципе)
	
	#macro YG_SAVING_DEBUG_ACTIVE				false // Имитировать сохранение/загрузку прогресса на сервер в тестовом билде (сохраняет/загружает сейвы в локальные файлы)
	#macro YG_SAVING_DEBUG_PERIOD				0.2 // Время сохранения данных в секундах, используемое для имитации задержки перед присланным ответом от сервера в тестовом билде
	#macro YG_SAVING_DEBUG_GENERATE_ERROR_SEND	false // Имитировать ошибку сохранения данных на сервер в режиме тестового билда
	#macro YG_SAVING_DEBUG_GENERATE_ERROR_GET	false // Имитировать ошибку получения данных с сервера в режиме тестового билда
	
	#macro YG_INTER_PERIOD						91 // Периодичность, с которой может показываться реклама в секундах (минимум 90, рекомендуется 91 и выше)
	#macro YG_INTER_PERIOD_DEBUG				10 // Периодичность, с которой может показываться фейковая реклама в секундах
	
	#macro YG_REWARD_DEBUG_TIMER				5 // Таймер для фейкового реварда, по истечению которого он будет считаться просмотренным
	
	#macro YG_DATA_FILENAME						"__data.json" // Имя файла data для дебаг сейвов
	#macro YG_STATS_FILENAME					"__stats.json" // Имя файла stats для дебаг сейвов
	
	#macro YG_ACTIVE_CAMERA_ON					false // Использует ли игра активную камеру (!В РАЗРАБОТКЕ!)
	
	
	// Дефолтные флаги
	var _ygFlagsDefault = { /* Вставьте сюда дефолтные значения, которые будут использованы, если нужные флаги не пришли с сервера */ }
	
	// Дефолтная data-структура
	var _ygData = { /* Вставьте сюда дефолтные значения data */ }
	
	// Дефолтная stats-структура
	var _ygStats = { /* Вставьте сюда дефолтные значения stats */ }
	
	
	
	
	#region НЕ МЕНЯТЬ ЗНАЧЕНИЯ (здесь можете увидеть, из чего состоит структура доступных после инициализации данных)
	
	globalvar YG;
	YG = {
		data				: _ygData,
		stats				: _ygStats,
		flags				: _ygFlagsDefault,
		lang				: YG_DEBUG_LANGUAGE,
		device_type			: E_DEVICE_TYPE.PC,
		is_release_build	: GM_build_type == "exe"
	}
	
	enum E_DEVICE_TYPE
	{
		PC,
		MOBILE
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
}