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
	var _text = (YG_INIT.lang == "ru" ?
	"Сейчас будет показана реклама" :
	"An advertisement will be shown now")
	
	var _x = _dw/2
	var _y = _dh/2
	var _fntSize = font_get_size(fnt)
	var _sep = _fntSize+(_fntSize/2)
	draw_text_ext(_x, _y, _text, _sep, _dw)
}