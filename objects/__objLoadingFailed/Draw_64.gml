var _font = __fntYG
draw_set_font(_font)
draw_set_valign(fa_middle)
draw_set_halign(fa_center)
draw_set_color(c_black)
var _dw = display_get_gui_width()
var _dh = display_get_gui_height()
draw_text_ext(_dw/2, _dh/2, text, font_get_size(_font)*1.5, _dw)

draw_set_valign(fa_top)
draw_set_halign(fa_left)