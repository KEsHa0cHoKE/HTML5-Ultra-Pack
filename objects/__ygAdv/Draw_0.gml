if (is_struct(struct_inter))
{
	struct_inter.event_draw()
}
if (is_struct(struct_reward))
{
	struct_reward.event_draw()
}

if (YG_MODE == E_YG_MODE.PLAYGAMA && !YG.is_release_build && YG.adv.banner.is_active)
{
	var _camX = camera_get_view_x(view_camera[0])
	var _camY = camera_get_view_y(view_camera[0])
	var _camW = camera_get_view_width(view_camera[0])
	var _camH = camera_get_view_height(view_camera[0])
	
	var _bannerW = _camW/2
	var _bannerH = met_banner_get_height_playgama()
	
	var _bannerX = _camX + _camW/4
	
	var _bannerY = (YG.adv.banner.position == E_BANNER_PG_POS.BOTTOM ? 
	_camY + _camH - _bannerH : _camY)
	
	
	draw_rectangle(_bannerX, _bannerY, _bannerX+_bannerW, _bannerY+_bannerH, false)
	
	draw_set_font(__fntYG)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	draw_set_color(c_black)
	
	draw_text(_bannerX+_bannerW/2, _bannerY+_bannerH/2, "banner")
	
	draw_set_color(c_white)
}

if (fullscreen) then exit;

if (adv_state == E_ADV_STATE.SHOWING_WARNING)
{
	draw_set_color(c_black)
	draw_set_alpha(0.8)
	
	var _dw = room_width
	var _dh = room_height
	draw_rectangle(0, 0, _dw, _dh, false)
	
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt)
	var _text = (YG.lang == "ru" ?
	"Сейчас будет показана реклама" :
	"An advertisement will be shown now")
	
	var _x = _dw/2
	var _y = _dh/2
	var _fntSize = font_get_size(fnt)
	var _sep = _fntSize+(_fntSize/2)
	draw_text_ext(_x, _y, _text, _sep, _dw)
}