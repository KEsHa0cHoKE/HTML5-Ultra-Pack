if (!yg_autocast.active_camera_on) then exit;

if (instance_exists(targ_inst))
{
	target_x = targ_inst.x
	target_y = targ_inst.y
}

#region Перемещение камеры

var _camX = camera_get_view_x(view_camera[0])
var _camY = camera_get_view_y(view_camera[0])
var _camW = camera_get_view_width(view_camera[0])
var _camH = camera_get_view_height(view_camera[0])

var _minX = 0
var _minY = 0
var _maxX = room_width-_camW
var _maxY = room_height-_camH

var _camTargetX = clamp(target_x+autocast_base_x+offset_x, _minX, _maxX)
var _camTargetY = clamp(target_y+autocast_base_y+offset_y, _minY, _maxY)

var _x		= lerp(_camX, _camTargetX, lerp_val)
var _y		= lerp(_camY, _camTargetY, lerp_val)

camera_set_view_pos(view_camera[0], _x, _y)

x = _x
y = _y

#endregion