///@desc
if (!view_enabled)
{
	view_visible[0] = true
	view_enabled    = true
	camera_set_view_size(view_camera[0], cam_width, cam_height)
}

// Объект который отслеживаем
targ_inst = obj_wasd

// Отступ до объекта
offset_x = -(cam_width/2)
offset_y = -(cam_height/2)

// Координаты которые отправляет расширение autocast
autocast_base_x = 0
autocast_base_y = 0

// Координаты к которым стремится камера
target_x = 0
target_y = 0

if (targ_inst == noone)
{
	target_x = 0
	target_y = 0
}
else if (instance_exists(targ_inst))
{
	target_x = targ_inst.x
	target_y = targ_inst.y
}

///@desc Устанавливает камеру в указанное положение
met_set_pos = function(_x, _y)
{
	target_x	= _x
	target_y	= _y
	x			= _x+autocast_base_x
	y			= _y+autocast_base_y
	
	camera_set_view_pos(view_camera[0], x, y)
}