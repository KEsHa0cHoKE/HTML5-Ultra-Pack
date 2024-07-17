#region Настройки

	active_camera_on = false
	transition_active = true

#endregion

#region Камера

if (active_camera_on)
{
	instance_create_depth(0,0, -10000, obj_cam)
}

#endregion

#region Блекскрин

if (transition_active)
{
	instance_create_depth(0,0, -10000, obj_transition)
}

#endregion

#region Автокаст

b_w = browser_width
b_h = browser_height

var _width = (active_camera_on ? obj_cam.cam_width : room_width)
var _height = (active_camera_on ? obj_cam.cam_height : room_height)

display_set(true, _width, _height)
display_center(_width, _height)

#endregion

//surface_depth_disable(true)
device_mouse_dbclick_enable(false)