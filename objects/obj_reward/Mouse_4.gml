yg_adv.met_show_reward(function(){
	obj_click.clicks += 100
	YG.data.clicks = obj_click.clicks
	yg_data.met_send_data()
	show_debug_message("Rewarded")
}, function(){
	show_debug_message("Not rewarded")
})