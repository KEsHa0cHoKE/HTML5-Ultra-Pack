active_camera_on = YG_ACTIVE_CAMERA_ON

#region Камера

if (active_camera_on)
{
	instance_create_depth(0,0, -10000, __ygCamera)
}

#endregion


#region Автокаст

b_w = browser_width
b_h = browser_height

var _width = (active_camera_on ? __ygCamera.cam_width : room_width)
var _height = (active_camera_on ? __ygCamera.cam_height : room_height)

past_banner_size = (YG.adv.banner.is_active ? YG.adv.banner.get_height_playgama(_height) : 0)

display_autocast(_width, _height)

if (YG_MODE == E_YG_MODE.PLAYGAMA && YG.adv.banner.is_supported && YG.adv.banner.is_active)
	display_center_with_playgama_banner(_width, _height)
else
	display_center(_width, _height)

#endregion

//surface_depth_disable(true)
device_mouse_dbclick_enable(false)

#endregion