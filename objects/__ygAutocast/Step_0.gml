var _bw = browser_width
var _bh = browser_height
var _bannerH = YG.adv.banner.get_height_playgama()

if (_bw != b_w || _bh != b_h || past_banner_size != _bannerH)
{
	b_w = _bw
	b_h = _bh
	past_banner_size = _bannerH
	
	var _width = (active_camera_on ? __ygCamera.cam_width : room_width)
	var _height = (active_camera_on ? __ygCamera.cam_height : room_height)
	
	display_autocast(_width, _height)
	
	if (YG_MODE == E_YG_MODE.PLAYGAMA && YG.adv.banner.is_supported && YG.adv.banner.is_active)
		display_center_with_playgama_banner(_width, _height)
	else
		display_center(_width, _height)
}