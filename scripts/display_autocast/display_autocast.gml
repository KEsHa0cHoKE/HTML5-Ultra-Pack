function display_set(_center = 0,_width = room_width,_height = room_height)
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

function display_refresh(_center = 1,_width = room_width,_height = room_height)
{
	if (os_browser == browser_not_a_browser)
	{
		var tmp_width  = window_get_width();
		var tmp_height = window_get_height();
	}
	else
	{
		var tmp_width  = browser_width;
		var tmp_height = browser_height;
	}
	
	if (os_is_paused() || window_has_focus() == false) || (tmp_width != current_width || tmp_width != current_height)
	{
		display_autocast(_center,_width,_height);

		current_width  = tmp_width;
		current_height = tmp_height;
	}	
}
function display_autocast(_center = 1,_width = room_width,_height = room_height)
{	
	if (!view_enabled)
	{
		view_enabled    = true;
	    view_visible[0] = true;
		
		//view_set_wport(0, room_width)
		//view_set_hport(0, room_height)
		
		if (camera_get_view_width(view_camera[0]) > room_width || camera_get_view_height(view_camera[0]) > room_height)
		{
			camera_set_view_size(view_camera[0],room_width,room_height);
		}
	}
	else
	{
		if (_width == room_width && _height == room_height)
		{
			if (!variable_instance_exists(id,"cam_w_self"))
			{
				cam_w_self = camera_get_view_width(view_camera[0]);
			}
			if (!variable_instance_exists(id,"cam_h_self"))
			{
				cam_h_self = camera_get_view_height(view_camera[0]);
			}
			
			_width  = cam_w_self;
			_height = cam_h_self;
		}
		
		//if (_center == 1)
		//{
		//	_center = 0;
		//}
		
		var target = camera_get_view_target(view_camera[0]);
			
		//show_debug_message(string(object_get_name(target.object_index)))
		if (instance_exists(target))
		{
			camera_set_view_border(view_camera[0],
			target.x - camera_get_view_width(view_camera[0])/2, 
			target.y - camera_get_view_height(view_camera[0])/2 );
		}
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
		
		if (_center)
		{
			camera_set_view_pos(view_camera[0], 
			(_width - camera_get_view_width(view_camera[0])) / 2,
			(_height - camera_get_view_height(view_camera[0])) / 2);
		}
		
		surface_resize(application_surface,camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]));
	}
	else
	{		
		var coeff_w = browser_width/browser_height / (_width/_height);
		var _x =      _width * coeff_w;
		var coeff_h = browser_height/browser_width / (_height/_width);
		var _y = _height * coeff_h;
		
		if (_x <= _width)
		{
			camera_set_view_size(view_camera[0], _width, round(_y));
			var _cam_xPos = (camera_get_view_width(view_camera[0]) - _width)/2;
			var _cam_yPos = (_height - camera_get_view_height(view_camera[0])) / 2
			if (_center)
			{
				camera_set_view_pos(view_camera[0],_cam_xPos,_cam_yPos);
			}
		}	
		if (_x > _width)
		{
			camera_set_view_size(view_camera[0], round(_x), _height);
			var _cam_xPos = (_width - camera_get_view_width(view_camera[0]))/2;
			var _cam_yPos = (_height - camera_get_view_height(view_camera[0])) / 2
			if (_center)
			{
				camera_set_view_pos(view_camera[0],_cam_xPos,_cam_yPos);
			}
		}
		
		window_set_position(0,0);
		
		var w = browser_width;
		var h = browser_height;

		var rz = browser_get_device_pixel_ratio();
		var rw = w * rz;
		var rh = h * rz;

		view_wport[0] = rw;
		view_hport[0] = rh;
	
		if (rw < 2000 && rh < 2000)
		{
			if (application_surface_is_enabled()) 
			{
			    surface_resize(application_surface, rw, rh);
			}
		}

		window_set_size(rw, rh);

		browser_stretch_canvas(w, h);		
	}
}