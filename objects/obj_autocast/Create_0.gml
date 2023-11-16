display_set(1)

application_surface_enable(false)
surface_depth_disable(true)
device_mouse_dbclick_enable(false)
exception_unhandled_handler(function(ex)
{
	show_message(ex)
})

b_w = browser_width
b_h = browser_height