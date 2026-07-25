extends FlowContainer

func _ready() -> void:
	var first = false
	for character_name in Registry.character_data.keys():
		var character_data = Registry.character_data[character_name]
		var button_instance = character_data["button_scene"].instantiate()
		add_child(button_instance)
		if not first:
			first = true
			button_instance._on_pressed()
