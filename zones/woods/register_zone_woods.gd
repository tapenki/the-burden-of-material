extends Node

func _init() -> void:
	Registry.register_zone("woods", 1)
	
	Registry.register_encounter("wise_mystical_tree", {
		enemies = [
			{
				character = preload("res://zones/woods/wise_mystical_tree/wise_mystical_tree.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, true , true , false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, true , true , false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "wood",
						position = Vector2(2, 3),
						rotation = 1,
					}, {
						type = "wood",
						position = Vector2(5, 3),
						rotation = 1,
					}, {
						type = "wise_words",
						position = Vector2(3, 3),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(3, 5),
						rotation = 0,
					}]
			}
		]
	}, ["woods"])
	
	Registry.register_encounter("bees", {
		enemies = [
			{
				character = preload("res://zones/woods/bees/bees.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, true , true , false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "stinger",
						position = Vector2(2, 3),
						rotation = 0,
					}, {
						type = "beehive",
						position = Vector2(3, 4),
						rotation = 0,
					}, {
						type = "honeycomb",
						position = Vector2(3, 3),
						rotation = 0,
					}, {
						type = "flower",
						position = Vector2(3, 1),
						rotation = 0,
					}]
			}
		]
	}, ["woods"])
