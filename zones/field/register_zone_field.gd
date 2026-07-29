extends Node

func _init() -> void:
	Registry.register_zone("field", 0)
	
	Registry.register_encounter("bandit", {
		enemies = [
			{
				character = preload("res://zones/field/bandit/bandit.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "shiv",
						position = Vector2(2, 3),
						rotation = 0,
					}, {
						type = "bandana",
						position = Vector2(3, 3),
						rotation = 0,
					}]
			}
		]
	}, ["field"])
	
	Registry.register_encounter("flower", {
		enemies = [
			{
				character = preload("res://zones/field/flower/flower.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "roots",
						position = Vector2(3, 5),
						rotation = 0,
					}, {
						type = "flower",
						position = Vector2(3, 3),
						rotation = 0,
					}]
			}
		]
	}, ["field"])
	
	Registry.register_encounter("scarecrow", {
		enemies = [
			{
				character = preload("res://zones/field/scarecrow/scarecrow.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "pitchfork",
						position = Vector2(2, 4),
						rotation = 1,
					},
					{
						type = "straw_hat",
						position = Vector2(3, 2),
						rotation = 0,
					},]
			}
		]
	}, ["field"])
	
	Registry.register_encounter("cow", {
		enemies = [
			{
				character = preload("res://zones/field/cow/cow.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "cow_slam",
						position = Vector2(2, 2),
						rotation = 0,
					}, {
						type = "beef",
						position = Vector2(4, 4),
						rotation = 0,
					}]
			}
		]
	}, ["field"])
