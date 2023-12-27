if (can_show)
{
	draw_set_color(c_black)
	draw_set_alpha(0.8)
	draw_rectangle(0, 0, room_width, room_height, false)
	
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt)
	var _text = (global.lang == "ru" ?
	"Сейчас будет показана реклама" :
	"An advertisement will be shown now")
	draw_text(room_width/2, room_height/2, _text)
}