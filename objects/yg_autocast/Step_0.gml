var _bw = browser_width
var _bh = browser_height
if (_bw != b_w || _bh != b_h)
{
	b_w = _bw
	b_h = _bh
	
	var _width = (active_camera_on ? yg_cam.cam_width : room_width)
	var _height = (active_camera_on ? yg_cam.cam_height : room_height)

	display_autocast(true, _width, _height)
	display_center(_width, _height)
}