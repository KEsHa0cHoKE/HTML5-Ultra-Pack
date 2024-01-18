if (black_start_alpha > 0)
{
	draw_set_alpha(black_start_alpha)
	draw_set_color(c_black)

	var _dw = display_get_gui_width()
	var _dh = display_get_gui_height()
	draw_rectangle(0, 0, _dw, _dh, false)

	draw_set_alpha(1)
	draw_set_color(c_white)
}