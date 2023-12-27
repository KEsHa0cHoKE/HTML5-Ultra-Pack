if (black_start_alpha > 0)
{
	draw_set_alpha(black_start_alpha)
	draw_set_color(c_black)

	draw_rectangle(0,0, room_width, room_height, false)

	draw_set_alpha(1)
	draw_set_color(c_white)
}