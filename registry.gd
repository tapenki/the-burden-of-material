extends Node

var item_data = {}

var encounter_data = {}

var zone_data = {
	field = {
		encounters = [
			[],
			[],
			[],
			[],
			[] ## bosses
		]
		}
}

var character_data = {
	knight = {
		character = preload("res://characters/knight.png"),
		button_scene = preload("res://ui/character_button.tscn"),
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
		}]
	}
}

func register_item(item_name, item_definition):
	item_data[item_name] = item_definition

func register_encounter(encounter_name, encounter_definition, encounter_zones = {}):
	encounter_data[encounter_name] = encounter_definition
	for zone in encounter_zones.keys():
		var schedule = encounter_zones[zone]
		for day in schedule:
			zone_data[zone]["encounters"][day].append(encounter_name)

func _init() -> void:
	#region register items
	register_item("shiv", {
		scene = preload("res://equipment/shiv/shiv.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 10
		},
		active_ability = func(grid, this): ## example active ability
		var enemy = grid.get_enemy()
		var damage = grid.get_item_stat(this, "damage")
		grid.deal_damage(enemy, damage)
	})
	
	register_item("axe", {
		scene = preload("res://equipment/axe/axe.tscn"),
		shape = [
			[true , true ],
			[true , false],
			[true , false]
		],
		connections = [
			{
				active = preload("res://equipment/ui/diamonds_connection_active.tscn"),
				inactive = preload("res://equipment/ui/diamonds_connection_inactive.tscn"),
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
	})
	
	register_item("milk", {
		scene = preload("res://equipment/milk/milk.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			recovery = 10
		},
		active_requirement = func(grid, _this):
		var hp = grid.get_stat("health")["final"]
		var max_hp = grid.get_stat("max_health")["final"]
		return hp <= max_hp * 0.5,
			active_ability = func(grid, this):
		var recovery = grid.get_item_stat(this, "recovery")
		grid.recover_health(recovery)
	})
	
	register_item("roots", {
		scene = preload("res://equipment/roots/roots.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			recovery = 4
		},
		active_ability = func(grid, this):
		var recovery = grid.get_item_stat(this, "recovery")
		grid.add_stat("max_health", recovery["final"])
		grid.recover_health(recovery)
	})
	#endregion
	#region register encounters
	register_encounter("bandit", {
		enemies = [
			{
				character = preload("res://characters/bandit.png"),
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
					}]
			}
		]
	}, {field = [0, 2, 4]})
	
	register_encounter("flower", {
		enemies = [
			{
				character = preload("res://characters/flower.png"),
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
						position = Vector2(3, 4),
						rotation = 0,
					}]
			}
		]
	}, {field = [1, 3]})
	#endregion
