///@desc


#region Настройки
//TODO : редактировать draw gui и эвенты draw у конструкторов
fullscreen = true // FALSE ПОКА НЕ ПОДДЕРЖИВАЕТСЯ, НЕ МЕНЯТЬ ИНАЧЕ СЛЕТЯТ ФЕЙК ИНТЕРЫ/РЕВАРДЫ

#endregion


debug_adv_periodicity_in_sec = YG_INTER_PERIOD_DEBUG
adv_periodicity_in_sec = YG_INTER_PERIOD


#region Конструкторы для имитации рекламы в тестовом билде

///@func CloseButton
///@ignore
CloseButton = function(_parId, _x, _y) constructor
{
	x = _x
	y = _y
	par_id = _parId
	rad = 30
		
	met_clicked = function()
	{
		self.par_id.met_destroy()
	}
		
	event_step = function()
	{
		var _mouseOn = point_in_rectangle(mouse_x, mouse_y, self.x-self.rad, self.y-self.rad, self.x+self.rad, self.y+self.rad)
		if (_mouseOn && mouse_check_button_pressed(mb_left))
		{
			self.met_clicked()
		}
	}
		
	event_draw = function()
	{
		draw_set_color(c_gray)
		draw_set_alpha(0.5)
		draw_circle(self.x, self.y, self.rad, false)
		
		draw_set_color(c_white)
		draw_line_width(self.x-rad/2, self.y-rad/2, self.x+rad/2, self.y+rad/2, 4)
		draw_line_width(self.x+rad/2, self.y-rad/2, self.x-rad/2, self.y+rad/2, 4)
		
		draw_set_alpha(1)
	}
}

///@func Inter
///@ignore
Inter = function(_x, _y, _parId) constructor 
{
	par_id = _parId
	x = _x
	y = _y
	width = 500
	height = 350
	
	close_button = new par_id.CloseButton(self, self.x+self.width/2, self.y-self.height/2)
	
	
	audio_master_gain(0)
	par_id.adv_state = E_ADV_STATE.SHOWING_ADV
	
	
	event_step = function()
	{
		close_button.event_step()
	}
	
	event_draw = function()
	{
		draw_set_color(c_white)
		draw_rectangle(self.x-width/2, self.y-height/2, self.x+width/2, self.y+height/2, false)
		
		draw_set_color(c_black)
		draw_set_font(__fntYG)
		draw_set_valign(fa_middle)
		draw_set_halign(fa_center)
		draw_text(x, y, YG.lang == "ru" ? "Реклама" : "Advertisement")
		
		close_button.event_draw()
	}
	
	met_destroy = function()
	{
		audio_master_gain(1)
		
		par_id.adv_state = E_ADV_STATE.CANNOT_SHOW
		par_id.alarm[0] = (YG.is_release_build ? par_id.adv_periodicity_in_sec*game_get_speed(gamespeed_fps) : par_id.debug_adv_periodicity_in_sec*game_get_speed(gamespeed_fps))
		
		if (is_callable(par_id.inter_callback))
		{
			par_id.inter_callback()
			par_id.inter_callback = undefined
		}
		
		par_id.adv_state = E_ADV_STATE.CANNOT_SHOW
		
		
		delete close_button
		close_button = undefined
		par_id.struct_inter = undefined
	}
}

///@func Reward
///@ignore
Reward = function(_x, _y, _parId) constructor 
{
	par_id = _parId
	x = _x
	y = _y
	width = 500
	height = 350
	
	timer = YG_REWARD_DEBUG_TIMER
	
	close_button = new par_id.CloseButton(self, self.x+self.width/2, self.y-self.height/2)
	
	
	audio_master_gain(0)
	par_id.reward_state = E_REWARD_STATE.SHOWING
	
	
	event_step = function()
	{
		timer -= 1/game_get_speed(gamespeed_fps)
		if (timer <= 0)
		{
			par_id.reward_received = true
		}
		
		close_button.event_step()
	}
	
	event_draw = function()
	{
		draw_set_color(c_white)
		draw_rectangle(self.x-width/2, self.y-height/2, self.x+width/2, self.y+height/2, false)
		
		draw_set_color(c_black)
		draw_set_font(__fntYG)
		draw_set_valign(fa_middle)
		draw_set_halign(fa_center)
		draw_text(x, y, YG.lang == "ru" ? "Ревард" : "Reward")
		
		var _watched = (timer <= 0)
		draw_text(x, y+self.height/2-font_get_size(__fntYG)/1.5, (_watched ? (YG.lang == "ru" ? "Просмотрено" : "Watched") : $"{ceil(timer)}"))
		
		close_button.event_draw()
	}
	
	met_destroy = function()
	{
		audio_master_gain(1)
		if (par_id.reward_received)
		{	
			if (is_callable(par_id.reward_callback)) 
			{
				par_id.reward_callback()
				par_id.reward_callback = undefined
			}
			else
			{
				show_error("yg_adv : async_social -> невозможно вызвать reward_callback", true)
			}
		}
		else 
		{
			if (is_callable(par_id.reward_callback_without_reward)) 
			{
				par_id.reward_callback_without_reward()
				par_id.reward_callback_without_reward = undefined
			}
		}
		par_id.reward_received = false
		par_id.reward_state = E_REWARD_STATE.NOT_SHOW
		
		
		delete close_button
		close_button = undefined
		par_id.struct_reward = undefined
	}
}

struct_inter = undefined //new Inter(room_width/2, room_height/2, self)
struct_reward = undefined //new Reward(room_width/2, room_height/2, self)

///@ignore
///@func __met_create_fakeInter
__met_create_fakeInter = function()
{
	var _camX = camera_get_view_x(view_camera[0])
	var _camY = camera_get_view_y(view_camera[0])
	var _camW = camera_get_view_width(view_camera[0])
	var _camH = camera_get_view_height(view_camera[0])
	
	//var _x = (fullscreen ? display_get_gui_width()/2 : _camX+_camW/2)
	//var _y = (fullscreen ? display_get_gui_height()/2 : _camY+_camH/2)
	var _x = _camX+_camW/2
	var _y =  _camY+_camH/2
	struct_inter = new Inter(_x, _y, self)
	
	return -100 // id для req_id
}
///@ignore
///@func __met_create_fakeReward
__met_create_fakeReward = function()
{
	var _camX = camera_get_view_x(view_camera[0])
	var _camY = camera_get_view_y(view_camera[0])
	var _camW = camera_get_view_width(view_camera[0])
	var _camH = camera_get_view_height(view_camera[0])
	
	//var _x = (fullscreen ? display_get_gui_width()/2 : _camX+_camW/2)
	//var _y = (fullscreen ? display_get_gui_height()/2 : _camY+_camH/2)
	var _x = _camX+_camW/2
	var _y =  _camY+_camH/2
	struct_reward = new Reward(_x, _y, self)
	
	return -101 // id для req_id
}

#endregion



enum E_ADV_STATE
{
	CANNOT_SHOW,
	CAN_SHOW,
	SHOWING_WARNING,
	SHOWING_ADV
}
enum E_REWARD_STATE
{
	NOT_SHOW,
	SENDED_REQUEST,
	SHOWING
}

req_id = (YG.is_release_build ? YaGames_showFullscreenAdv() : __met_create_fakeInter())
req_idReward = undefined

adv_state = E_ADV_STATE.SHOWING_ADV
reward_state = E_REWARD_STATE.NOT_SHOW

reward_received = false
reward_callback = undefined
reward_callback_without_reward = undefined

inter_callback = undefined

fnt = __fntYG

///@func met_is_inter_showable()
///@desc Возвращает, прошло ли достаточно времени, чтобы можно было показать рекламу
met_is_inter_showable = function()
{
	return (adv_state == E_ADV_STATE.CAN_SHOW && reward_state == E_REWARD_STATE.NOT_SHOW)
}

///@func met_show_inter
///@desc Показать полноэкранную рекламу
///@param {Bool} _showWarning если true - запускает предупреждение о скором показе рекламы, а через 3 секунды саму рекламу.
///@param {Function} _callback коллбек, выполнится когда игрок закроет рекламу
met_show_inter = function(_showWarning = true, _callback = undefined)
{
	if (!met_is_inter_showable()) then exit;
		
	if (_showWarning)
	{
		adv_state = E_ADV_STATE.SHOWING_WARNING
		alarm[1] = 2*game_get_speed(gamespeed_fps)
	}
	else
	{
		adv_state = E_ADV_STATE.SHOWING_ADV
		alarm[1] = 1
	}
		
	if (is_callable(_callback))
	{
		inter_callback = _callback
	}
}

///@func met_is_adv_active
///@desc Возвращает, показывается ли сейчас реклама или предупреждение о скором показе рекламы или ревард или ожидается ответ сервера на запрос показать ревард
met_is_adv_active = function()
{
	return (adv_state >= E_ADV_STATE.SHOWING_WARNING || reward_state > E_REWARD_STATE.NOT_SHOW)
}

///@func met_show_reward()
///@desc Запускает ревард. В аргументе указывается метод/функция, которая выполнится при успешном просмотре реварда
///@param {Function} _callBack коллбек, если игрок досмотрел рекламу
///@param {Function} _callBackWithoutReward коллбек, если игрок закрыл рекламу прежде чем она закончилась
met_show_reward = function(_callBack, _callBackWithoutReward = undefined)
{
	reward_state = E_REWARD_STATE.SENDED_REQUEST
	req_idReward = (YG.is_release_build ? YaGames_showRewardedVideo() : __met_create_fakeReward())
	
	if (is_callable(_callBack))
	{
		reward_callback = _callBack
	}
	else
	{
		show_error("Указанный аргумент в методе met_show_reward не является методом/функцией", true)
	}
	
	if (is_callable(_callBackWithoutReward))
	{
		reward_callback_without_reward = _callBackWithoutReward
	}
}