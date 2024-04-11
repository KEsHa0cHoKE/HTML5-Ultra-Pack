(function(d) {
	if (window.gp == null) {
		console.log('YandexMetrica start load script');
		if (Number(YMetricaWeb_project_id) === null) {
			console.error('YandexMetrica ID not found!');
		}
		else 
		{
			(function(m,e,t,r,i,k,a){
			m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
			m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],
			k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
			(window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

			ym(Number(YMetricaWeb_project_id), "init", {
			clickmap:true,
			trackLinks:true,
			accurateTrackBounce:true,
			webvisor:true
			});
		}
	}
})(document);


function YM_send(t,s) {
	ym(Number(YMetricaWeb_project_id), t, s);
	alert(String(Number(YMetricaWeb_project_id)) + " " + String(t) + " " + String(s));
}
