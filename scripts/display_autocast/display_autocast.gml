// Автор : Game Maker Boost
// boosty автора : https://boosty.to/gamemakerboost

function display_set(_center = true,_width = room_width,_height = room_height)
{
	//var _first = instance_find(obj_resize,0);
	//if (id != _first)
	//{
	//	instance_destroy();
	//	exit;
	//}

	display_autocast(_center,_width,_height);

	if (os_browser == browser_not_a_browser)
	{
		current_width  = window_get_width();
		current_height = window_get_height();
	}
	else
	{
		current_width  = browser_width;
		current_height = browser_height;
	}	
}

function display_refresh(_center = true,_width = room_width,_height = room_height)
{
	var tmp_width, tmp_height
	
	if (os_browser == browser_not_a_browser)
	{
		tmp_width  = window_get_width();
		tmp_height = window_get_height();
	}
	else
	{
		tmp_width  = browser_width;
		tmp_height = browser_height;
	}
	
	if (os_is_paused() || window_has_focus() == false) || (tmp_width != current_width || tmp_width != current_height)
	{
		display_autocast(_center,_width,_height);

		current_width  = tmp_width;
		current_height = tmp_height;
	}	
}
function display_autocast(_center = true,_width = room_width,_height = room_height)
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
		var coeff_w = (browser_width / browser_height) / (_width/_height);
		var _x = _width * coeff_w;
		var coeff_h = (browser_height / browser_width) / (_height/_width);
		var _y = _height * coeff_h;
		
		
		var _camXPos, _camYPos, _camW, _camH
		
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

function display_instance_repose(_x = xstart,_y = ystart)
{
	var bw = browser_width;
	var bh = browser_height;
	
	if (os_browser == browser_not_a_browser)
	{
		bw = window_get_width();
		bh = window_get_height();
	}

	var _kw = (room_width + camera_get_view_width(view_camera[0])) / bw;
	var _kh = (room_height + camera_get_view_height(view_camera[0])) / bh;
	var k = max(_kw, _kh);
	_kw /= k;
	_kh /= k;

	x = room_width * 0.5 + (_x - room_width * 0.5) / _kw;
	y = room_height * 0.5 + (_y - room_height * 0.5) / _kh;		
}

function display_center(_width = room_width,_height = room_height)
{
	var _camPosX = (_width - camera_get_view_width(view_camera[0])) / 2
	var _camPosY = (_height - camera_get_view_height(view_camera[0])) / 2
	if (!yg_autocast.active_camera_on)
	{
		camera_set_view_pos(view_camera[0], _camPosX, _camPosY)
	}
	else if (instance_exists(yg_cam))
	{
		yg_cam.autocast_base_x = _camPosX
		yg_cam.autocast_base_y = _camPosY
	}
}