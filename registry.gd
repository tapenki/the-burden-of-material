extends Node

var item_data = {
	shiv = {
		scene = preload("res://equipment/shiv/shiv.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 25
		},
		active_ability = func(grid, this): ## example active ability
	var enemy = grid.get_enemy()
	var damage = grid.get_item_stat(this, "damage")
	grid.deal_damage(enemy, damage)
	},
	boomerang = {
		scene = preload("res://equipment/boomerang/boomerang.tscn"),
		shape = [
			[true , true ],
			[false, true ],
		]
	},
	axe = {
		scene = preload("res://equipment/axe/axe.tscn"),
		shape = [
			[true , true ],
			[true , false],
			[true , false]
		],
		connections = [
			{
				active = preload("res://equipment/diamonds_connection_active.tscn"),
				inactive = preload("res://equipment/diamonds_connection_inactive.tscn"),
				shape = [
					[true , true ],
					[true , true ]
				],
				offset = Vector2i(1, 1)
			}
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this): ## example ability boosting the damage of all connected items
		if stat == "damage" and grid.get_connected_items(this, 0).has(item):
			modifiers["base"] += 2
		}
	},
}

var encounter_data = {
	bandit = {
		enemies = [
			{
				character = preload("res://equipment/characters/swordsman.png"),
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
						position = Vector2(2, 2),
						rotation = 0,
					},
					{
						type = "axe",
						position = Vector2(4, 2),
						rotation = 0,
					}]
			}
		]
	}
}

var zone_data = {
	field = {
		encounters = [
			["bandit"],
			["bandit"],
			["bandit"],
			["bandit"],
		],
		bosses = ["bandit"]
		}
}
