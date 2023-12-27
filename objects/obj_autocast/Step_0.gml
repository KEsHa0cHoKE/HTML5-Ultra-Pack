var _newW = browser_width
var _newH = browser_height

if (b_w != _newW || b_h != _newH)
{
	b_w = _newW
	b_h = _newH
	display_autocast()
}

black_start_alpha =
clamp(black_start_alpha-black_start_spd, 0, 1)