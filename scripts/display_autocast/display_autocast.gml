// Основано на "Aвто - масштабирование" от GMLab
// ссылка на оригинал : https://boosty.to/gamemakerboost/posts/950c20a3-1143-453d-a06c-09629daabb61


function display_autocast(_width = room_width, _height = room_height)
{
	_height += (YG.adv.banner.is_active ? YG.adv.banner.get_height_playgama() : 0)
	
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
		var coeff_w = (browser_width / browser_height) / (_width/_height);
		var _x = _width * coeff_w;
		var coeff_h = (browser_height / browser_width) / (_height/_width);
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
		
		var w = browser_width;
		var h = browser_height;

		var rz = browser_get_device_pixel_ratio();
		var rw = w * rz;
		var rh = h * rz;

		view_wport[0] = rw;
		view_hport[0] = rh;
	
		if (application_surface_is_enabled()) 
		{
			surface_resize(application_surface, rw, rh);
		}

		window_set_size(rw, rh);

		browser_stretch_canvas(w, h);
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
	
	if (_yPosFromScreenStart) {
		if (YG.adv.banner.position == E_BANNER_PG_POS.BOTTOM) 
			camera_set_view_pos(view_camera[0], _camPosX, 0)
		else
			camera_set_view_pos(view_camera[0], _camPosX, -YG.adv.banner.get_height_playgama())
		
		exit;
	}
	
	
	var _freeHeight = camera_get_view_height(view_camera[0]) - _height
	
	var _camPosY
	if (_freeHeight/2 > YG.adv.banner.get_height_playgama()) {
		_camPosY = (_height - camera_get_view_height(view_camera[0])) / 2
	}
	else {
		_camPosY = YG.adv.banner.position == E_BANNER_PG_POS.BOTTOM ? 
		(_height - camera_get_view_height(view_camera[0]) + YG.adv.banner.get_height_playgama()) :
		(-YG.adv.banner.get_height_playgama())
	}

	camera_set_view_pos(view_camera[0], round(_camPosX), round(_camPosY))
}