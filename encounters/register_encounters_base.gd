extends Node

func register() -> void:
	Registry.register_encounter("bandit", {
		enemies = [
			{
				character = preload("res://encounters/bandit/bandit.png"),
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
	}, [1])
	
	Registry.register_encounter("flower", {
		enemies = [
			{
				character = preload("res://encounters/flower/flower.png"),
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
	}, [1])
	
	Registry.register_encounter("scarecrow", {
		enemies = [
			{
				character = preload("res://encounters/scarecrow/scarecrow.png"),
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
	}, [2])
	
	Registry.register_encounter("cow", {
		enemies = [
			{
				character = preload("res://encounters/cow/cow.png"),
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
	}, [2])
	
	Registry.register_encounter("bees", {
		enemies = [
			{
				character = preload("res://encounters/bees/bees.png"),
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
	}, [3])
	
	Registry.register_encounter("bear", {
		enemies = [
			{
				character = preload("res://encounters/bear/bear.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "pillow",
						position = Vector2(1, 3),
						rotation = 0,
					}, {
						type = "fish",
						position = Vector2(4, 4),
						rotation = 0,
					}, {
						type = "berries",
						position = Vector2(4, 3),
						rotation = 0,
					}, {
						type = "honeycomb",
						position = Vector2(5, 3),
						rotation = 0,
					}]
			}
		]
	}, [3])
	
	Registry.register_encounter("wise_mystical_tree", {
		enemies = [
			{
				character = preload("res://encounters/wise_mystical_tree/wise_mystical_tree.png"),
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
						rotation = 3,
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
	}, [4])
	
	Registry.register_encounter("woodsman", {
		enemies = [
			{
				character = preload("res://encounters/woodsman/woodsman.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "axe",
						position = Vector2(1, 3),
						rotation = 0,
					}, {
						type = "wood",
						position = Vector2(2, 5),
						rotation = 0,
					}, {
						type = "hunting_rifle",
						position = Vector2(3, 4),
						rotation = 0,
					}]
			}
		]
	}, [4])
	
	Registry.register_encounter("snail", {
		enemies = [
			{
				character = preload("res://encounters/snail/snail.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "sippy_straw",
						position = Vector2(1, 4),
						rotation = 1,
					}, {
						type = "slime",
						position = Vector2(1, 3),
						rotation = 0,
					}, {
						type = "snail_shell",
						position = Vector2(3, 3),
						rotation = 0,
					}, {
						type = "mushroom",
						position = Vector2(5, 4),
						rotation = 0,
					}, {
						type = "mushroom",
						position = Vector2(6, 4),
						rotation = 0,
					}, {
						type = "flower",
						position = Vector2(5, 2),
						rotation = 0,
					}, ]
			}
		]
	}, [5])
	
	Registry.register_encounter("worm", {
		enemies = [
			{
				character = preload("res://encounters/worm/worm.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "shovel",
						position = Vector2(0, 3),
						rotation = 3,
					}, {
						type = "shovel",
						position = Vector2(0, 4),
						rotation = 1,
					}, {
						type = "roots",
						position = Vector2(0, 5),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(2, 5),
						rotation = 0,
					},{
						type = "regenerative_tissue",
						position = Vector2(5, 2),
						rotation = 0,
					},]
			}
		]
	}, [5])
	
	Registry.register_encounter("witch", {
		enemies = [
			{
				character = preload("res://encounters/witch/witch.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, true , true , true , true , false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "cauldron",
						position = Vector2(3, 4),
						rotation = 0,
					}, {
						type = "mushroom",
						position = Vector2(2, 2),
						rotation = 1,
					}, {
						type = "mushroom",
						position = Vector2(2, 3),
						rotation = 1,
					}, {
						type = "mushroom",
						position = Vector2(4, 2),
						rotation = 1,
					}, {
						type = "mushroom",
						position = Vector2(4, 3),
						rotation = 1,
					}, {
						type = "magic_broom",
						position = Vector2(2, 6),
						rotation = 1,
					},]
			}
		]
	}, [6])
	
	Registry.register_encounter("skeleton", {
		enemies = [
			{
				character = preload("res://encounters/skeleton/skeleton.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , false, true , true , false, true ,false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, true , true , true , true , false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "skull",
						position = Vector2(3, 1),
						rotation = 0,
					}, {
						type = "bones",
						position = Vector2(3, 3),
						rotation = 0,
					}, {
						type = "trumpet",
						position = Vector2(1, 1),
						rotation = 1,
					}, {
						type = "milk",
						position = Vector2(6, 1),
						rotation = 0,
					}, {
						type = "shiv",
						position = Vector2(2, 5),
						rotation = 0,
					}, {
						type = "shiv",
						position = Vector2(5, 5),
						rotation = 0,
					}]
			}
		]
	}, [6])
	
	Registry.register_encounter("cactus", {
		enemies = [
			{
				character = preload("res://encounters/cactus/cactus.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[true , true , true , true , true , true , true , true ],
					[false, false, false, false, false, false, false, false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "cactus",
						position = Vector2(0, 3),
						rotation = 0,
					}, {
						type = "flower",
						position = Vector2(2, 3),
						rotation = 0,
					}, {
						type = "cactus",
						position = Vector2(4, 3),
						rotation = 0,
					}, {
						type = "flower",
						position = Vector2(6, 3),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(0, 5),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(2, 5),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(4, 5),
						rotation = 0,
					}, {
						type = "roots",
						position = Vector2(6, 5),
						rotation = 0,
					},]
			}
		]
	}, [7])
	
	Registry.register_encounter("slot_machine", {
		enemies = [
			{
				character = preload("res://encounters/slot_machine/slot_machine.png"),
				layout = [
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false],
					[false, false, true , true , true , true , false, false]
				],
				equipment = [{
						type = "slots",
						position = Vector2(2, 1),
						rotation = 0,
					},{
						type = "slots",
						position = Vector2(3, 2),
						rotation = 0,
					},{
						type = "poker_chip",
						position = Vector2(5, 1),
						rotation = 0,
					},{
						type = "poker_chip",
						position = Vector2(2, 2),
						rotation = 0,
					},{
						type = "sheet_metal",
						position = Vector2(2, 4),
						rotation = 0,
					},{
						type = "sheet_metal",
						position = Vector2(3, 6),
						rotation = 0,
					},]
			}
		]
	}, [7])
	
	Registry.register_encounter("sun", {
		enemies = [
			{
				character = preload("res://encounters/sun/sun.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "laser_eyes",
						position = Vector2(1, 2),
						rotation = 0,
					},{
						type = "laser_eyes",
						position = Vector2(3, 2),
						rotation = 0,
					},{
						type = "sunglasses",
						position = Vector2(2, 1),
						rotation = 0,
					},{
						type = "spinach",
						position = Vector2(5, 2),
						rotation = 0,
					},{
						type = "spinach",
						position = Vector2(5, 3),
						rotation = 0,
					},{
						type = "plasma_core",
						position = Vector2(4, 4),
						rotation = 0,
					},{
						type = "globe",
						position = Vector2(1, 5),
						rotation = 0,
					},]
			}
		]
	}, [8])
	
	Registry.register_encounter("police", {
		enemies = [
			{
				character = preload("res://encounters/police/police.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "riot_shield",
						position = Vector2(1, 1),
						rotation = 0,
					}, {
						type = "baton",
						position = Vector2(3, 1),
						rotation = 0,
					}, {
						type = "baton",
						position = Vector2(4, 1),
						rotation = 0,
					}, {
						type = "sulphur",
						position = Vector2(6, 1),
						rotation = 3,
					}, {
						type = "sulphur",
						position = Vector2(6, 2),
						rotation = 3,
					}, {
						type = "sulphur",
						position = Vector2(6, 3),
						rotation = 3,
					}, {
						type = "badge",
						position = Vector2(5, 2),
						rotation = 0,
					}, {
						type = "bulletproof_vest",
						position = Vector2(1, 5),
						rotation = 0,
					}, {
						type = "bulletproof_vest",
						position = Vector2(3, 5),
						rotation = 0,
					}, {
						type = "deal_with_the_devil",
						position = Vector2(5, 5),
						rotation = 0,
					},]
			}
		]
	}, [9])
	
	Registry.register_encounter("grey_goo", {
		enemies = [
			{
				character = preload("res://encounters/grey_goo/grey_goo.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "attack_drone",
						position = Vector2(1, 2),
						rotation = 0,
					}, {
						type = "attack_drone",
						position = Vector2(4, 5),
						rotation = 0,
					}, {
						type = "defense_drone",
						position = Vector2(4, 2),
						rotation = 0,
					}, {
						type = "defense_drone",
						position = Vector2(1, 5),
						rotation = 0,
					}, {
						type = "slime",
						position = Vector2(2, 1),
						rotation = 0,
					}, {
						type = "slime",
						position = Vector2(5, 1),
						rotation = 0,
					}, {
						type = "slime",
						position = Vector2(2, 4),
						rotation = 0,
					}, {
						type = "slime",
						position = Vector2(5, 4),
						rotation = 0,
					},]
			}
		]
	}, [9])
	
	Registry.register_encounter("president", {
		enemies = [
			{
				character = preload("res://encounters/president/president.png"),
				layout = [
					[false, false, false, false, false, false, false, false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, true , true , true , true , true , true , false],
					[false, false, false, false, false, false, false, false]
				],
				equipment = [{
						type = "attack_drone",
						position = Vector2(1, 2),
						rotation = 0,
					}, {
						type = "defense_drone",
						position = Vector2(4, 1),
						rotation = 0,
					}, {
						type = "globe",
						position = Vector2(1, 5),
						rotation = 0,
					}, {
						type = "beef",
						position = Vector2(3, 5),
						rotation = 0,
					}, {
						type = "deal_with_the_devil",
						position = Vector2(5, 5),
						rotation = 0,
					}, {
						type = "cheese",
						position = Vector2(4, 4),
						rotation = 0,
					}, {
						type = "spinach",
						position = Vector2(1, 1),
						rotation = 0,
					}, {
						type = "spinach",
						position = Vector2(6, 4),
						rotation = 0,
					}, {
						type = "sulphur",
						position = Vector2(1, 4),
						rotation = 0,
					}, {
						type = "sulphur",
						position = Vector2(2, 4),
						rotation = 0,
					}, {
						type = "sulphur",
						position = Vector2(3, 4),
						rotation = 0,
					}, {
						type = "sunglasses",
						position = Vector2(2, 1),
						rotation = 0,
					}, {
						type = "nuclear_launch_codes",
						position = Vector2(4, 3),
						rotation = 0,
					},]
			}
		]
	}, [10])
