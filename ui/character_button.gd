extends Button

@export var character_name = "swordsman"

func _on_pressed() -> void:
	var player_equipment = get_node("/root/Game/PlayerEquipment")
	var character_data = Registry.character_data[character_name]
	player_equipment.character.texture = character_data["character"]
	player_equipment.layout = character_data["layout"].duplicate(true)
	player_equipment.equipment = character_data["equipment"].duplicate(true)
	player_equipment.load_grid()
