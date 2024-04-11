if (fullscreen) then exit;

if (alpha > 0)
{
	draw_set_alpha(alpha)
	draw_set_color(color)

	var _dw = room_width
	var _dh = room_height
	draw_rectangle(0, 0, _dw, _dh, false)

	draw_set_alpha(1)
	draw_set_color(c_white)
}