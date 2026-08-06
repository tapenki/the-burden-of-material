extends Button

var current_speed = 0

func _on_pressed() -> void:
	get_node("/root/Game").play_sound("Click", 1)
	current_speed = (current_speed + 1) % 3
	Engine.physics_ticks_per_second = 20 * (current_speed + 1)
	text = tr("ui_speed_button").format({speed = current_speed + 1})
