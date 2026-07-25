extends Button

func _on_game_battle_initiated() -> void:
	visible = false

func _on_game_battle_ended() -> void:
	visible = true

func _on_pressed() -> void:
	visible = false
	get_node("/root/Game").proceed()
