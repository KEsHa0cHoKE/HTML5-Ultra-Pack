yg_adv.met_show_reward(function() {
	obj_click.clicks += 100
	global.data.clicks = obj_click.clicks
	yg_data.met_send_data(global.data)
	
	show_debug_message("Rewarded")
}, function() {
	show_debug_message("Not rewarded")
})