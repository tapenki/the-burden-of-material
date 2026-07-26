extends Node

func _init() -> void:
	## knight
	Registry.register_item("zweihander", {
		scene = preload("res://characters/knight/zweihander/zweihander.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ]
		],
		stats = {
			damage = 12
		},
		active_ability = func(grid, this): ## example active ability
		var enemy = grid.get_enemy()
		var damage = grid.get_item_stat(this, "damage")
		grid.deal_damage(enemy, damage)
	})
	
	Registry.register_character("knight", {
		character = preload("res://characters/knight/knight.png"),
		button_scene = preload("res://characters/knight/knight_button.tscn"),
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
			type = "zweihander",
			position = Vector2(3, 2),
			rotation = 0,
		}]
	})
	
	## chef
	Registry.register_item("milk", {
		scene = preload("res://characters/chef/milk/milk.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			recovery = 8
		},
		active_requirement = func(grid, _this):
		var hp = grid.get_stat("health")["final"]
		var max_hp = grid.get_stat("max_health")["final"]
		return hp <= max_hp * 0.5,
			active_ability = func(grid, this):
		var recovery = grid.get_item_stat(this, "recovery")
		grid.recover_health(recovery)
	})
	
	Registry.register_item("frying_pan", {
		scene = preload("res://characters/chef/frying_pan/frying_pan.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/hearts_connection_active.tscn"),
				inactive = preload("res://ui/hearts_connection_inactive.tscn"),
				shape = [
					[false, true , true , false],
					[true , false, false, true ],
					[true , false, false, true ],
					[false, true , true , false],
				],
				offset = Vector2i(-1, -1)
			}
		],
		stats = {
			damage = 8
		},
		active_ability = func(grid, this): ## example active ability
		var enemy = grid.get_enemy()
		var damage = grid.get_item_stat(this, "damage")
		grid.deal_damage(enemy, damage),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
		if stat == "recovery" and grid.get_connected_items(this, 0).has(item):
			modifiers["mult_mult"] *= 2
		}
	})
	
	Registry.register_character("chef", {
		character = preload("res://characters/chef/chef.png"),
		button_scene = preload("res://characters/chef/chef_button.tscn"),
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
			type = "frying_pan",
			position = Vector2(3, 3),
			rotation = 0,
		},{
			type = "milk",
			position = Vector2(3, 2),
			rotation = 3,
		}]
	})
