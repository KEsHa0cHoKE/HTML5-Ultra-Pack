// Основано на "Aвто - масштабирование" от GMLab
// ссылка на оригинал : https://boosty.to/gamemakerboost/posts/950c20a3-1143-453d-a06c-09629daabb61


function display_autocast(_width = room_width, _height = room_height)
{
	if (!view_enabled)
	{
	    view_visible[0] = true;
	    view_enabled    = true;
		camera_set_view_size(view_camera[0],room_width,room_height);
	}
	
	if (os_browser == browser_not_a_browser)
	{
		var coeff_w = (window_get_width() / window_get_height()) / (_width/_height);
		var _x = _width * coeff_w;
		var coeff_h = (window_get_height() / window_get_width()) / (_height/_width);
		var _y = _height * coeff_h;
		
		if (_x <= _width)
		{
			camera_set_view_size(view_camera[0], _width, round(_y));
		}	
		if (_x > _width)
		{
			camera_set_view_size(view_camera[0], round(_x), _height);
		}
		
		surface_resize(application_surface,camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]));
	}
	else
	{
		var _browserW = browser_width
		var _browserH = browser_height
		
		// Advanced Banner is an overlay and does not reduce browser_height.
		// Shrink the actual GameMaker canvas so the banner gets its own area,
		// reproducing the old sticky-banner behaviour.
		var _bannerCssH = 0
		if (YG_MODE == E_YG_MODE.PLAYGAMA &&
			YG.adv.banner.is_supported &&
			YG.adv.banner.is_active) {
			_bannerCssH = round(_browserH * 0.125)
		}
		
		var _canvasH = max(1, _browserH - _bannerCssH)
		
		var coeff_w = (_browserW / _canvasH) / (_width/_height);
		var _x = _width * coeff_w;
		var coeff_h = (_canvasH / _browserW) / (_height/_width);
		var _y = _height * coeff_h;
		
		if (_x <= _width)
		{
			camera_set_view_size(view_camera[0], _width, round(_y));
		}	
		if (_x > _width)
		{
			camera_set_view_size(view_camera[0], round(_x), _height);
		}
		
		window_set_position(0,0);
		
		var _pixelRatio = browser_get_device_pixel_ratio();
		var _renderW = _browserW * _pixelRatio;
		var _renderH = _canvasH * _pixelRatio;
		
		view_wport[0] = _renderW;
		view_hport[0] = _renderH;
	
		if (application_surface_is_enabled()) 
		{
			surface_resize(application_surface, _renderW, _renderH);
		}

		window_set_size(_renderW, _renderH);

		browser_stretch_canvas(_browserW, _canvasH);
	}
}

function display_center(_width = room_width,_height = room_height)
{
	var _camPosX = (_width - camera_get_view_width(view_camera[0])) / 2
	var _camPosY = (_height - camera_get_view_height(view_camera[0])) / 2
	if (!__ygAutocast.active_camera_on)
	{
		camera_set_view_pos(view_camera[0], _camPosX, _camPosY)
	}
	else if (instance_exists(__ygCamera))
	{
		__ygCamera.autocast_base_x = _camPosX
		__ygCamera.autocast_base_y = _camPosY
	}
	else
	{
		show_error("Активная камера включена, но объект камеры не существует", true)
	}
}

/// @desc Центрирует камеру с учётом смещения под баннер
/// @param _width {real} Ширина комнаты (по умолчанию room_width)
/// @param _height {real} Высота комнаты (по умолчанию room_height)
function display_center_with_playgama_banner(_width = room_width, _height = room_height, _yPosFromScreenStart = false) {
	var _camPosX = (_width - camera_get_view_width(view_camera[0])) / 2
	var _camPosY = (_height - camera_get_view_height(view_camera[0])) / 2
	
	// Bottom Advanced Banner has its own physical area below the canvas.
	// For a top banner the canvas would need a CSS Y offset, so preserve
	// the old top-placement compensation for now.
	if (YG.adv.banner.position == E_BANNER_PG_POS.TOP) {
		var _bannerH = YG.adv.banner.get_height_playgama(_height)
		_camPosY -= _bannerH
	}
	
	if (_yPosFromScreenStart && YG.adv.banner.position == E_BANNER_PG_POS.BOTTOM)
		_camPosY = 0
	
	camera_set_view_pos(view_camera[0], round(_camPosX), round(_camPosY))
}

