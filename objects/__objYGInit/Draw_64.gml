var _x = display_get_gui_width()/2
var _y = display_get_gui_height()/2

draw_sprite_ext(sprite_index, 0, _x, _y,
1, 1, image_angle, c_white, 1)

draw_set_color(c_white)
draw_set_valign(fa_middle)
draw_set_halign(fa_center)

draw_text(_x, _y, $"{union_drawing_percent}%")

draw_set_color(c_black)
draw_set_valign(fa_top)
draw_set_halign(fa_left)