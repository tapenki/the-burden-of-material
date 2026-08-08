extends Node

func register() -> void:
	Registry.register_item("salt", {
		scene = preload("res://equipment/s/salt/salt.tscn"),
		shape = [
			[true ],
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, _grid, _item, _this):
				if stat == "health_gain" or stat == "shield_gain":
					modifiers["base"] += 1},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("milk", {
		scene = preload("res://equipment/m/milk/milk.tscn"),
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
	
	Registry.register_item("spinach", {
		scene = preload("res://equipment/s/spinach/spinach.tscn"),
		shape = [
			[true ],
		],
		stats = {
			health_gain = 5,
			status_applied = 1
		},
		passive_ability = {
			battle_start = func(grid, this):
				var health_gain = grid.get_item_stat(this, "health_gain")
				grid.add_stat("max_health", health_gain["final"])
				grid.recover_health(health_gain)
				var status_applied = grid.get_item_stat(this, "status_applied")["final"]
				grid.add_status("strength", status_applied)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("cheese", {
		scene = preload("res://equipment/c/cheese/cheese.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			status_applied = 1
		},
		active_requirement = func(grid, _this):
			return grid.statuses.has("poison"),
		active_ability = func(grid, this):
			var status_applied = grid.get_item_stat(this, "status_applied")["final"]
			grid.add_status("poison", -3)
			grid.add_status("regeneration", status_applied),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("shiv", {
		scene = preload("res://equipment/s/shiv/shiv.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 8
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("bandana", {
		scene = preload("res://equipment/b/bandana/bandana.tscn"),
		shape = [
			[true , true ],
			[true , false],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "loot_quantity":
					modifiers["base"] += 1},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("axe", {
		scene = preload("res://equipment/a/axe/axe.tscn"),
		shape = [
			[true , true ],
			[true , false],
			[true , false]
		],
		stats = {
			damage = 8
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage
			if enemy.get_stat("shield")["final"] > 0:
				damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				grid.attack(enemy, damage)
			damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("flower", {
		scene = preload("res://equipment/f/flower/flower.tscn"),
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
				if stat == "health_gain" and grid.get_connected_items(this, 0).has(item):
					modifiers["base"] += 3},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("roots", {
		scene = preload("res://equipment/r/roots/roots.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			health_gain = 3
		},
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")
				if grid.get_item_stat(this, "charge")["final"] >= 3.0:
					grid.add_item_stat(this, "charge", -3.0, "base")
					var health_gain = grid.get_item_stat(this, "health_gain")
					grid.add_stat("max_health", health_gain["final"])
					grid.recover_health(health_gain)
					this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	 
	Registry.register_item("pitchfork", {
		scene = preload("res://equipment/p/pitchfork/pitchfork.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ],
		],
		stats = {
			damage = 2
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			for i in 3:
				var damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				grid.attack(enemy, damage),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("straw_hat", {
		scene = preload("res://equipment/s/straw_hat/straw_hat.tscn"),
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
			health_gain = 2
		},
		passive_ability = {
			damage_dealt = func(damage, _target, grid, this):
				if damage.has("item_source") and grid.get_connected_items(this, 0).has(damage["item_source"]):
					var health_gain = grid.get_item_stat(this, "health_gain")
					grid.recover_health(health_gain)
					this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("beef", {
		scene = preload("res://equipment/b/beef/beef.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			health_gain = 25
		},
		passive_ability = {
			battle_start = func(grid, this):
				var health_gain = grid.get_item_stat(this, "health_gain")
				grid.add_stat("max_health", health_gain["final"])
				grid.recover_health(health_gain)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("cow_slam", {
		scene = preload("res://equipment/c/cow_slam/cow_slam.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			damage = 4
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, _item, _this):
				if stat == "damage":
					var hp = grid.get_stat("health")
					modifiers["base"] += int(hp["final"] / 15)},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("wood", {
		scene = preload("res://equipment/w/wood/wood.tscn"),
		shape = [
			[true , true , true ],
		],
		connections = [
			{
				active = preload("res://ui/hearts_connection_active.tscn"),
				inactive = preload("res://ui/hearts_connection_inactive.tscn"),
				shape = [
					[true , true, true],
					[true , true, true],
				],
				offset = Vector2i(0, -2)
			}
		],
		stats = {
			shield_gain = 3
		},
		passive_ability = {
			item_used = func(item, grid, this):
				if grid.get_connected_items(this, 0).has(item):
					var shield_gain = grid.get_item_stat(this, "shield_gain")
					grid.recover_shield(shield_gain)
					this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("wise_words", {
		scene = preload("res://equipment/w/wise_words/wise_words.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		active_ability = func(grid, _this):
			var enemy = grid.get_enemy()
			enemy.progress_fatigue(0.75),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("pillow", {
		scene = preload("res://equipment/p/pillow/pillow.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			health_gain = 50
		},
		passive_ability = {
			fatigue_start = func(grid, this):
				var health_gain = grid.get_item_stat(this, "health_gain")
				grid.recover_health(health_gain)
				for item in grid.equipment:
					grid.add_item_stat(item, "uses", 1, "base")
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("beehive", {
		scene = preload("res://equipment/b/beehive/beehive.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			status_applied = 1
		},
		passive_ability = {
			damage_taken = func(damage, grid, this):
				if damage.get("attack"):
					var enemy = grid.get_enemy()
					var status_applied = grid.get_item_stat(this, "status_applied")["final"]
					enemy.add_status("poison", status_applied)
					this["item_scene"].pop()},
		tags = ["treasure_loot"],
	}) 
	
	Registry.register_item("stinger", {
		scene = preload("res://equipment/s/stinger/stinger.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 4,
			status_applied = 1
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				var status_applied = grid.get_item_stat(this, "status_applied")["final"]
				enemy.add_status("poison", status_applied),
		tags = ["treasure_loot"],
	}) 
	
	Registry.register_item("honeycomb", {
		scene = preload("res://equipment/h/honeycomb/honeycomb.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			health_gain = 8
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.add_stat("max_health", health_gain["final"])
			grid.recover_health(health_gain),
		tags = ["treasure_loot"]
	}) 
	
	
	Registry.register_item("hunting_rifle", {
		scene = preload("res://equipment/h/hunting_rifle/hunting_rifle.tscn"),
		shape = [
			[true , true , true , true ],
		],
		stats = {
			damage = 15
		},
		active_requirement = func(grid, this):
			return grid.get_item_stat(this, "charge")["final"] >= 8.0,
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("berries", {
		scene = preload("res://equipment/b/berries/berries.tscn"),
		shape = [
			[true ],
		],
		stats = {
			health_gain = 16,
			uses = 1
		},
		active_requirement = func(grid, this):
			var hp = grid.get_stat("health")["final"]
			var max_hp = grid.get_stat("max_health")["final"]
			return hp <= max_hp * 0.5 and grid.get_item_stat(this, "uses")["final"] >= 1,
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain)
			grid.add_item_stat(this, "uses", -1, "base"),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("fish", {
		scene = preload("res://equipment/f/fish/fish.tscn"),
		shape = [
			[true , true , true ],
		],
		stats = {
			uses = 3
		},
		active_requirement = func(grid, this):
			return grid.get_item_stat(this, "uses")["final"] >= 1,
		active_ability = func(grid, this):
			grid.add_status("dodge", 1)
			grid.add_item_stat(this, "uses", -1, "base"),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("mushroom", {
		scene = preload("res://equipment/m/mushroom/mushroom.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			health_gain = 4,
			status_applied = 1
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain)
			var enemy = grid.get_enemy()
			var status_applied = grid.get_item_stat(this, "status_applied")["final"]
			enemy.add_status("poison", status_applied),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("snail_shell", {
		scene = preload("res://equipment/s/snail_shell/snail_shell.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			health_gained = func(gain, grid, this):
				var shield_gain = gain.duplicate()
				shield_gain["mult_mult"] *= 0.5
				grid.calculate_modifiers(shield_gain)
				grid.recover_shield(shield_gain)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("sippy_straw", {
		scene = preload("res://equipment/s/sippy_straw/sippy_straw.tscn"),
		shape = [
			[true ],
			[true ],
		],
		stats = {
			health_gain = 4
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, _item, _this):
				if stat == "health_gain":
					var enemy = grid.get_enemy()
					if enemy and enemy.statuses.has("poison"):
						modifiers["base"] += int(enemy.statuses["poison"]["stacks"] / 2)},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("slime", {
		scene = preload("res://equipment/s/slime/slime.tscn"),
		shape = [
			[true ],
		],
		connections = [
			{
				active = preload("res://ui/spades_connection_active.tscn"),
				inactive = preload("res://ui/spades_connection_inactive.tscn"),
				shape = [
					[true ],
				],
				offset = Vector2i(0, 1)
			}
		],
		passive_ability = {
			can_use_item = func(modifiers, item, grid, this): ## example ability boosting the damage of all connected items
				if grid.get_connected_items(this, 0).has(item) and grid.get_item_stat(this, "charge")["final"] < 8.0:
					modifiers["usable"] = false,
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("cauldron", {
		scene = preload("res://equipment/c/cauldron/cauldron.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/spades_connection_active.tscn"),
				inactive = preload("res://ui/spades_connection_inactive.tscn"),
				shape = [
					[true , true ],
					[true , true ],
				],
				offset = Vector2i(0, -2)
			}
		],
		stats = {
			health_gain = 1,
			status_applied = 1,
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain)
			var enemy = grid.get_enemy()
			var status_applied = grid.get_item_stat(this, "status_applied")["final"]
			enemy.add_status("poison", status_applied),
		passive_ability = {
			item_used = func(item, grid, this):
				if grid.get_connected_items(this, 0).has(item):
					grid.add_item_stat(this, "health_gain", 1)
					grid.add_item_stat(this, "status", 1)
					this["item_scene"].pop()
					if not item.get("destroyed"):
						grid.destroy_item(item)},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("magic_broom", {
		scene = preload("res://equipment/m/magic_broom/magic_broom.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ],
		],
		stats = {
			status_applied = 2
		},
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")
				if grid.get_item_stat(this, "charge")["final"] >= 2.0:
					grid.add_item_stat(this, "charge", -2.0, "base")
					var statuses = grid.get_statuses_of_tag("debuff")
					if statuses.size() > 0:
						var status = statuses.pick_random()
						grid.add_status(status, -1)
					this["item_scene"].pop(),
			battle_start = func(grid, this):
				var status_applied = grid.get_item_stat(this, "status_applied")["final"]
				grid.add_status("dodge", status_applied)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("cactus", {
		scene = preload("res://equipment/c/cactus/cactus.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			damage = 3
		},
		passive_ability = {
			damage_taken = func(damage, grid, this):
				if damage.get("attack"):
					var enemy = grid.get_enemy()
					var dealt_damage = grid.get_item_stat(this, "damage")
					dealt_damage["item_source"] = this
					grid.deal_damage(enemy, dealt_damage)
					this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("plasma_core", {
		scene = preload("res://equipment/p/plasma_core/plasma_core.tscn"),
		shape = [
			[true , true , true ],
			[true , true , true ],
			[true , true , true ],
		],
		stats = {
			shield_gain = 75
		},
		passive_ability = {
			battle_start = func(grid, this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
				grid.progress_fatigue(5.0)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("sunglasses", {
		scene = preload("res://equipment/s/sunglasses/sunglasses.tscn"),
		shape = [
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/diamonds_connection_active.tscn"),
				inactive = preload("res://ui/diamonds_connection_inactive.tscn"),
				shape = [
					[true , true],
					[true , true],
				],
				offset = Vector2i(0, 1)
			}
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				var threshold = grid.get_stat("fatigue_threshold")["final"]
				if threshold > 0 and stat == "damage" and grid.get_connected_items(this, 0).has(item):
					modifiers["add_mult"] += 1.0},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("laser_eyes", {
		scene = preload("res://equipment/l/laser_eyes/laser_eyes.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			damage = 4
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				enemy.add_stat("health", -damage["final"])
				enemy.add_stat("max_health", -damage["final"]),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("globe", {
		scene = preload("res://equipment/g/globe/globe.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			shield_gain = 5
		},
		active_ability = func(grid, this):
			grid.add_status("dodge", 1)
			var shield_gain = grid.get_item_stat(this, "shield_gain")
			grid.recover_shield(shield_gain)
			grid.progress_fatigue(0.5),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("deal_with_the_devil", {
		scene = preload("res://equipment/d/deal_with_the_devil/deal_with_the_devil.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			battle_start = func(grid, this):
				grid.add_stat("max_health", -25)
				grid.add_stat("health", -25)
				this["item_scene"].pop(),
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "multitasking":
					modifiers["base"] += 1},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("badge", {
		scene = preload("res://equipment/b/badge/badge.tscn"),
		shape = [
			[true ],
		],
		stats = {
			shield_gain = 5
		},
		passive_ability = {
			battle_start = func(grid, this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
				var enemy = grid.get_enemy()
				enemy.add_stat("charge", -0.4)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	})
	
	Registry.register_item("sulphur", {
		scene = preload("res://equipment/s/sulphur/sulphur.tscn"),
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
				],
				offset = Vector2i(0, -3)
			}
		],
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick),
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "damage" and grid.get_connected_items(this, 0).has(item) and grid.get_item_stat(this, "charge")["final"] >= 8:
					modifiers["base"] += 3},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("riot_shield", {
		scene = preload("res://equipment/r/riot_shield/riot_shield.tscn"),
		shape = [
			[true , true ],
			[true , true ],
			[true , true ],
		],
		stats = {
			shield_gain = 10
		},
		active_ability = func(grid, this):
			var shield_gain = grid.get_item_stat(this, "shield_gain")
			grid.recover_shield(shield_gain)
			var enemy = grid.get_enemy()
			enemy.add_stat("charge", -0.2),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("bulletproof_vest", {
		scene = preload("res://equipment/b/bulletproof_vest/bulletproof_vest.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			shield_gain = 25,
		},
		passive_ability = {
			damage_taken = func(damage, grid, this):
				if damage.get("attack") and damage["final"] >= 10:
					var enemy = grid.get_enemy()
					enemy.add_stat("charge", -0.2)
					this["item_scene"].pop(),
			battle_start = func(grid, this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("baton", {
		scene = preload("res://equipment/b/baton/baton.tscn"),
		shape = [
			[true ],
			[true ],
			[true ]
		],
		stats = {
			damage = 8,
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				enemy.add_stat("charge", -0.2),
		tags = ["treasure_loot"],
	}) 
	
	Registry.register_item("attack_drone", {
		scene = preload("res://equipment/a/attack_drone/attack_drone.tscn"),
		shape = [
			[true , true , true ],
			[true , true , true ],
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
			rested = func(grid, this):
				var enemy = grid.get_enemy()
				var damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				grid.attack(enemy, damage)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("defense_drone", {
		scene = preload("res://equipment/d/defense_drone/defense_drone.tscn"),
		shape = [
			[true , true , true ],
			[true , true , true ],
		],
		stats = {
			shield_gain = 8
		},
		active_ability = func(grid, this):
			var shield_gain = grid.get_item_stat(this, "shield_gain")
			grid.recover_shield(shield_gain),
		passive_ability = {
			rested = func(grid, this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("nuclear_launch_codes", {
		scene = preload("res://equipment/n/nuclear_launch_codes/nuclear_launch_codes.tscn"),
		shape = [
			[true , true , true ],
		],
		stats = {
			damage = 25,
			status_applied = 10
		},
		passive_ability = {
			fatigue_start = func(grid, this):
				var enemy = grid.get_enemy()
				var damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				if grid.attack(enemy, damage):
					var status_applied = grid.get_item_stat(this, "status_applied")["final"]
					enemy.add_status("poison", status_applied)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("skull", {
		scene = preload("res://equipment/s/skull/skull.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, grid, _this):
				if stat == "multitasking":
					var hp = grid.get_stat("health")["final"]
					var max_hp = grid.get_stat("max_health")["final"]
					if hp <= max_hp * 0.5:
						modifiers["base"] += 1},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("bones", {
		scene = preload("res://equipment/b/bones/bones.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "max_health":
					modifiers["base"] += 50},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("trumpet", {
		scene = preload("res://equipment/t/trumpet/trumpet.tscn"),
		shape = [
			[true , true , true ],
		],
		stats = {
			uses = 7,
			status_applied = 1
		},
		active_requirement = func(grid, this):
			return grid.get_item_stat(this, "uses")["final"] >= 1,
		active_ability = func(grid, this):
			var status_applied = grid.get_item_stat(this, "status_applied")["final"]
			grid.add_status("strength", status_applied)
			grid.add_item_stat(this, "uses", -1, "base"),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, _item, this):
				if stat == "damage" and grid.get_item_stat(this, "uses")["final"] == 0:
					modifiers["add_mult"] += 0.77},
		tags = ["treasure_loot"]
	})
	
	Registry.register_item("regenerative_tissue", {
		scene = preload("res://equipment/r/regenerative_tissue/regenerative_tissue.tscn"),
		shape = [
			[true , false, false],
			[true , true , true ],
			[false, false, true ],
		],
		stats = {
			status_applied = 1
		},
		passive_ability = {
			damage_taken = func(damage, grid, this):
				if damage.get("attack"):
					var status_applied = grid.get_item_stat(this, "status_applied")["final"]
					grid.add_status("regeneration", status_applied)
					this["item_scene"].pop()},
		tags = ["treasure_loot"],
	})
	
	Registry.register_item("shovel", {
		scene = preload("res://equipment/s/shovel/shovel.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ],
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
			generate_loot = func(loot, grid, _this):
				grid.get_node("/root/Game").items_from_pool(loot, "treasure_loot", 1)},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("slots", {
		scene = preload("res://equipment/s/slots/slots.tscn"),
		shape = [
			[true , true , true ],
		],
		stats = {
			odds_0 = 40,
			damage = 8,
			shield_gain = 8,
			status_applied = 1,
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			if grid.roll_item_chance("odds_0", this):
				var damage = grid.get_item_stat(this, "damage")
				damage["item_source"] = this
				grid.attack(enemy, damage)
			if grid.roll_item_chance("odds_0", this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
			if grid.roll_item_chance("odds_0", this):
				if Registry.status_tag_lists.has("debuff"):
					var status = Registry.status_tag_lists["debuff"].pick_random()
					var status_applied = grid.get_item_stat(this, "status_applied")["final"]
					enemy.add_status(status, status_applied)
			if grid.roll_item_chance("odds_0", this):
				if Registry.status_tag_lists.has("buff"):
					var status = Registry.status_tag_lists["buff"].pick_random()
					var status_applied = grid.get_item_stat(this, "status_applied")["final"]
					grid.add_status(status, status_applied),
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("sheet_metal", {
		scene = preload("res://equipment/s/sheet_metal/sheet_metal.tscn"),
		shape = [
			[false, true , true ],
			[true , true , false],
		],
		stats = {
			odds_0 = 40,
			shield_gain = 20,
		},
		passive_ability = {
			battle_start = func(grid, this):
				var shield_gain = grid.get_item_stat(this, "shield_gain")
				grid.recover_shield(shield_gain)
				if grid.roll_item_chance("odds_0", this):
					grid.recover_shield(shield_gain)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	})
	
	Registry.register_item("poker_chip", {
		scene = preload("res://equipment/p/poker_chip/poker_chip.tscn"),
		shape = [
			[true ],
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, _grid, _item, _this):
				if stat.substr(0, 5) == "odds_":
					modifiers["add_mult"] += 0.25},
		tags = ["treasure_loot"]
	}) 
	
	Registry.register_item("alien_beacon", {
		scene = preload("res://equipment/a/alien_beacon/alien_beacon.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		connections = [
			{
				active = preload("res://ui/diamonds_connection_active.tscn"),
				inactive = preload("res://ui/diamonds_connection_inactive.tscn"),
				shape = [
					[false , true, true, false],
					[true , true, true, true],
				],
				offset = Vector2i(-1, 2)
			}
		],
		stats = {
			status_applied = 1,
		},
		passive_ability = {
			battle_start = func(grid, this):
				for i in grid.get_connected_items(this, 0):
					if Registry.status_tag_lists.has("buff"):
						var status = Registry.status_tag_lists["buff"].pick_random()
						var status_applied = grid.get_item_stat(this, "status_applied")["final"]
						grid.add_status(status, status_applied)
				this["item_scene"].pop()},
		tags = ["treasure_loot"]
	})
	
	Registry.register_item("ray_gun", {
		scene = preload("res://equipment/r/ray_gun/ray_gun.tscn"),
		shape = [
			[true , true ],
			[true , false],
		],
		stats = {
			damage = 15
		},
		active_requirement = func(grid, this):
			return grid.get_item_stat(this, "charge")["final"] >= 16.0,
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				enemy.add_stat("health", -damage["final"])
				enemy.add_stat("max_health", -damage["final"]),
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")},
		tags = ["treasure_loot"]
	}) 
