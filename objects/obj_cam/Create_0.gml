///@desc

#region Настройки

	cam_width  = 1280
	cam_height = 720

	// Объект который отслеживаем
	targ_inst = noone

	// Отступ до объекта
	offset_x = -(cam_width/2)
	offset_y = -(cam_height/2)

#endregion

if (!view_enabled)
{
	view_visible[0] = true
	view_enabled    = true
	camera_set_view_size(view_camera[0], cam_width, cam_height)
}

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

///@desc Изменить отступ камеры до отслеживаемого объекта
met_set_offset = function(_offsetX, _offsetY)
{
	offset_x = _offsetX
	offset_y = _offsetY
}

///@desc Изменить отслеживаемый объект
met_set_targetInst = function(_instId)
{
	targ_inst = _instId
}