extends Node

var basic_layout = [
	[false, false, false, false, false, false, false, false],
	[false, false, false, false, false, false, false, false],
	[false, false, true , true , true , true , false, false],
	[false, false, true , true , true , true , false, false],
	[false, false, true , true , true , true , false, false],
	[false, false, true , true , true , true , false, false],
	[false, false, false, false, false, false, false, false],
	[false, false, false, false, false, false, false, false]
]

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
			damage = 10
		},
		active_ability = func(grid, this): ## example active ability
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				var hp = enemy.get_stat("health")["final"]
				var max_hp = enemy.get_stat("max_health")["final"]
				if hp > 0 and hp < max_hp * 0.2:
					enemy.set_stat("health", 0)
					enemy.text_effect("message_execution", Color.RED),
		tags = ["heirloom"]
	})
	
	Registry.register_item("whetstone", {
		scene = preload("res://characters/knight/whetstone/whetstone.tscn"),
		shape = [
			[true ],
		],
		connections = [
			{
				active = preload("res://ui/diamonds_connection_active.tscn"),
				inactive = preload("res://ui/diamonds_connection_inactive.tscn"),
				shape = [
					[true , true , true ],
				],
				offset = Vector2i(-1, -1)
			}
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "damage" and grid.get_connected_items(this, 0).has(item):
					modifiers["add_mult"] += 0.15},
		tags = ["treasure_loot"]
	})
	
	Registry.register_character("knight", {
		character = preload("res://characters/knight/knight.png"),
		button_scene = preload("res://characters/knight/knight_button.tscn"),
		layout = basic_layout,
		equipment = [{
			type = "zweihander",
			position = Vector2(3, 2),
			rotation = 0,
		},{
			type = "whetstone",
			position = Vector2(4, 4),
			rotation = 3,
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
			health_gain = 8
		},
		active_requirement = func(grid, _this):
			var hp = grid.get_stat("health")["final"]
			var max_hp = grid.get_stat("max_health")["final"]
			return hp <= max_hp * 0.5,
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain),
		tags = ["treasure_loot"]
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
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "health_gain" and grid.get_connected_items(this, 0).has(item):
					modifiers["add_mult"] += 1},
		tags = ["heirloom"]
	})
	
	Registry.register_character("chef", {
		character = preload("res://characters/chef/chef.png"),
		button_scene = preload("res://characters/chef/chef_button.tscn"),
		layout = basic_layout,
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
	
	## bomber
	
	Registry.register_item("matches", {
		scene = preload("res://characters/bomber/matches/matches.tscn"),
		shape = [
			[true ],
		],
		connections = [
			{
				active = preload("res://ui/diamonds_connection_active.tscn"),
				inactive = preload("res://ui/diamonds_connection_inactive.tscn"),
				shape = [
					[true ],
					[true ],
					[true ],
				],
				offset = Vector2i(0, -3)
			}
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "damage" and grid.get_connected_items(this, 0).has(item):
					modifiers["add_mult"] += 0.25},
		stats = {
			damage = 6
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
	})
	
	Registry.register_item("bomb", {
		scene = preload("res://characters/bomber/bomb/bomb.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			damage = 20
		},
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")
				if grid.get_item_stat(this, "charge")["final"] >= 5:
					var enemy = grid.get_enemy()
					var damage = grid.get_item_stat(this, "damage")
					damage["item_source"] = this
					if grid.attack(enemy, damage):
						#var destroy_valid_items = []
						#for item in enemy.equipment:
							#if not item.get("destroyed"):
								#destroy_valid_items.append(item)
						#if destroy_valid_items.size() > 0:
							#var item_to_destroy = destroy_valid_items.pick_random()
							#enemy.disconnect_item(item_to_destroy)
							#item_to_destroy["destroyed"] = true
							#item_to_destroy["item_scene"].kill()
						enemy.add_stat("charge", -2)
					grid.disconnect_item(this)
					this["destroyed"] = true
					this["item_scene"].kill()},
		tags = ["heirloom"]
	})
	
	Registry.register_character("bomber", {
		character = preload("res://characters/bomber/bomber.png"),
		button_scene = preload("res://characters/bomber/bomber_button.tscn"),
		layout = basic_layout,
		equipment = [{
			type = "bomb",
			position = Vector2(3, 3),
			rotation = 0,
		}, {
			type = "matches",
			position = Vector2(3, 5),
			rotation = 0,
		}]
	})
	
	## bum
	
	Registry.register_item("fisticuffs", {
		scene = preload("res://characters/brawler/fisticuffs/fisticuffs.tscn"),
		shape = [
			[true ,true ],
		],
		stats = {
			damage = 6
		},
		active_ability = func(grid, this):
			var hp = grid.get_stat("health")["final"]
			var max_hp = grid.get_stat("max_health")["final"]
			var enemy = grid.get_enemy()
			var damage
			if hp <= max_hp * 0.5:
				damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				grid.attack(enemy, damage)
			damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		tags = ["treasure_loot"]
	})
	
	Registry.register_item("beer", {
		scene = preload("res://characters/brawler/beer/beer.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			status = 3,
			uses = 1
		},
		active_requirement = func(grid, this):
			return grid.get_item_stat(this, "uses")["final"] >= 1,
		active_ability = func(grid, this):
			var status_applied = grid.get_item_stat(this, "status")["final"]
			grid.add_status("poison", status_applied)
			for item in grid.equipment:
				grid.add_item_stat(item, "damage", 4)
			grid.add_item_stat(this, "uses", -1, "base"),
		tags = ["heirloom"]
	})
	
	Registry.register_character("brawler", {
		character = preload("res://characters/brawler/brawler.png"),
		button_scene = preload("res://characters/brawler/brawler_button.tscn"),
		layout = basic_layout,
		equipment = [{
			type = "beer",
			position = Vector2(2, 3),
			rotation = 0,
		}, {
			type = "fisticuffs",
			position = Vector2(3, 4),
			rotation = 0,
		}, {
			type = "defense_drone",
			position = Vector2(3, 5),
			rotation = 0,
		}]
	})
