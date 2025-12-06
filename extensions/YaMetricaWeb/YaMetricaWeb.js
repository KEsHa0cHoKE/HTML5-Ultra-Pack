(function(d) {
	if (window.gp == null) {
		console.log('YandexMetrica start load script');
		if (Number(YMW_project_id) === null) {
			console.error('YandexMetrica ID not found!');
		}
		else 
		{
			(function(m,e,t,r,i,k,a){
			m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
			m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],
			k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
			(window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");
			
			ym(Number(YMW_project_id), "init", JSON.parse(YMW_init_struct));
			
			console.log('YandexMetrica loaded!');
		}
	}
})(document);


function YMW_extLink(url) {
	ym(Number(YMW_project_id), 'extLink', url);
}

function YMW_getClientID() {
	ym(Number(YMW_project_id), 'getClientID', function(clientId){
		let map = {};
		map["type"] = 'YMW_clientId';
		map["answer"] = clientId;
		GMS_API.send_async_event_social(map);
	});

	return 'YMW_clientId';
}

function YMW_notBounce() {
	ym(Number(YMW_project_id), 'notBounce');
}

function YMW_params(params) {
	ym(Number(YMW_project_id), 'params', JSON.parse(params));
}

function YMW_reachGoal(target) {
	ym(Number(YMW_project_id), 'reachGoal', target);
}

function YMW_reachGoal_ext(target, params) {
	ym(Number(YMW_project_id), 'reachGoal', target, JSON.parse(params));
}

function YMW_setUserID(userId) {
	if (typeof(userId) != "string")
	{
		userId = String(userId);
	}
	ym(Number(YMW_project_id), 'setUserID', userId);
}

function YMW_userParams(params) {
	ym(Number(YMW_project_id), 'userParams', JSON.parse(params));
}