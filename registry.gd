extends Node

var item_data = {}

var encounter_data = {}

var zone_data = {
	field = {
		encounters = []
		}
}

var character_data = {}

func register_item(item_name, item_definition):
	item_data[item_name] = item_definition

func register_encounter(encounter_name, encounter_definition, encounter_zones = []):
	encounter_data[encounter_name] = encounter_definition
	for zone in encounter_zones:
		zone_data[zone]["encounters"].append(encounter_name)

func register_character(character_name, character_definition):
	character_data[character_name] = character_definition

func _init() -> void:
	#region register items
	register_item("shiv", {
		scene = preload("res://equipment/shiv/shiv.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 8
		},
		active_ability = func(grid, this): ## example active ability
		var enemy = grid.get_enemy()
		var damage = grid.get_item_stat(this, "damage")
		damage["item_source"] = this
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
				active = preload("res://ui/diamonds_connection_active.tscn"),
				inactive = preload("res://ui/diamonds_connection_inactive.tscn"),
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
	
	register_item("flower", {
		scene = preload("res://equipment/flower/flower.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/hearts_connection_active.tscn"),
				inactive = preload("res://ui/hearts_connection_inactive.tscn"),
				shape = [
					[true , true],
				],
				offset = Vector2i(0, 2)
			}
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
		if stat == "recovery" and grid.get_connected_items(this, 0).has(item):
			modifiers["base"] += 2
		}
	})
	
	register_item("roots", {
		scene = preload("res://equipment/roots/roots.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			recovery = 6
		},
		active_ability = func(grid, this):
		var recovery = grid.get_item_stat(this, "recovery")
		grid.add_stat("max_health", recovery["final"])
		grid.recover_health(recovery)
	})
	
	register_item("pitchfork", {
		scene = preload("res://equipment/pitchfork/pitchfork.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ],
		],
		stats = {
			damage = 3
		},
		active_ability = func(grid, this): ## example active ability
		var enemy = grid.get_enemy()
		for i in 3:
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.deal_damage(enemy, damage)
	})
	
	register_item("straw_hat", {
		scene = preload("res://equipment/straw_hat/straw_hat.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/hearts_connection_active.tscn"),
				inactive = preload("res://ui/hearts_connection_inactive.tscn"),
				shape = [
					[true , true],
				],
				offset = Vector2i(0, 2)
			}
		],
		stats = {
			recovery = 1
		},
		passive_ability = {
			damage_dealt = func(damage, _target, grid, this):
		if damage.has("item_source") and grid.get_connected_items(this, 0).has(damage["item_source"]):
			var recovery = grid.get_item_stat(this, "recovery")
			grid.recover_health(recovery)
		}
	})
	#endregion
	#region register encounters
	register_encounter("bandit", {
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
						position = Vector2(2, 2),
						rotation = 0,
					}]
			}
		]
	}, ["field"])
	
	register_encounter("flower", {
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
	
	register_encounter("scarecrow", {
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
	#endregion
