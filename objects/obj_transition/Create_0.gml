fullscreen = true
alpha = 1
color = c_black
anim_target_alpha = 0
anim_time = 0.5

anim_transition = new class_animation(id, nameof(alpha))

met_transition_set = function(_time, _startAlpha, _targetAlpha, _color)
{
	alpha = _startAlpha
	anim_target_alpha = _targetAlpha
	anim_time = _time
	color = _color
	anim_transition.met_control_start()
}