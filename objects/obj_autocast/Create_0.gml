active_camera_on = true
transition_active = true

#region Камера

if (active_camera_on)
{
	var _camWidth = view_wport[0]
	var _camHeight = view_hport[0]

	instance_create_depth(0,0, -10000, obj_cam, {
		cam_width  : _camWidth,
		cam_height : _camHeight
	})
}

#endregion

#region Блекскрин

if (transition_active)
{
	instance_create_depth(0,0, -10000, obj_transition)
}

#endregion

#region Автокаст

var _width = (active_camera_on ? obj_cam.cam_width : room_width)
var _height = (active_camera_on ? obj_cam.cam_height : room_height)

display_set(true, _width, _height)
display_center(_width, _height)

#endregion

surface_depth_disable(true)
device_mouse_dbclick_enable(false)