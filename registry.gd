extends Node

var item_data = {}
var item_tag_lists = {}

var status_data = {}

var encounter_data = {}
var encounter_schedule = {}

var character_data = {}

func register_item(item_name, item_definition):
	item_data[item_name] = item_definition
	if item_definition.has("tags"):
		for tag in item_definition["tags"]:
			if not item_tag_lists.has(tag):
				item_tag_lists[tag] = []
			item_tag_lists[tag].append(item_name)

func register_status(status_name, status_definition):
	status_data[status_name] = status_definition

func register_encounter(encounter_name, encounter_definition, days = []):
	encounter_data[encounter_name] = encounter_definition
	for day in days:
		if not encounter_schedule.has(day):
			encounter_schedule[day] = []
		encounter_schedule[day].append(encounter_name)

func register_character(character_name, character_definition):
	character_data[character_name] = character_definition

func _init() -> void:
	register_status("poison", {
		passive_ability = {
			game_tick = func(tick, grid, this):
				if not this.has("charge"):
					this["charge"] = 0
				this["charge"] += tick
				if this["charge"] >= 2.0:
					this["charge"] -= 2.0
					var damage = {"final" = this["stacks"]}
					grid.deal_damage(grid, damage)}
	})
	
	register_status("burn", {
		passive_ability = {
			game_tick = func(tick, grid, this):
				if not this.has("charge"):
					this["charge"] = 0
				this["charge"] += tick
				if this["charge"] >= 0.5:
					this["charge"] -= 0.5
					var damage = {"final" = this["stacks"]}
					grid.deal_damage(grid, damage)
					grid.add_status("burn", -int(ceil(this["stacks"]*0.1)))}
	})
	
	register_status("dodge", {
		passive_ability = {
			check_evasion = func(attack_landed, grid, _this):
				attack_landed["landed"] = false
				grid.add_status("dodge", -1)}
	})
	
	register_item("magic_pockets_o", {
		scene = preload("res://equipment/magic_pockets/pockets_o.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_i", {
		scene = preload("res://equipment/magic_pockets/pockets_i.tscn"),
		shape = [
			[true , true , true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_t", {
		scene = preload("res://equipment/magic_pockets/pockets_t.tscn"),
		shape = [
			[true , true , true ],
			[false, true , false],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_s", {
		scene = preload("res://equipment/magic_pockets/pockets_s.tscn"),
		shape = [
			[false, true , true ],
			[true , true , false],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_z", {
		scene = preload("res://equipment/magic_pockets/pockets_z.tscn"),
		shape = [
			[true , true , false],
			[false, true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_l", {
		scene = preload("res://equipment/magic_pockets/pockets_l.tscn"),
		shape = [
			[true , false],
			[true , false],
			[true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_j", {
		scene = preload("res://equipment/magic_pockets/pockets_j.tscn"),
		shape = [
			[false, true ],
			[false, true ],
			[true , true ],
		],
		tags = ["pockets"]
	})
	
	#region register items
	register_item("salt", {
		scene = preload("res://equipment/salt/salt.tscn"),
		shape = [
			[true ],
		],
		stats = {
			damage = 8
		},
		active_requirement = func(grid, _this):
			var enemy = grid.get_enemy()
			var hp = enemy.get_stat("health")["final"]
			var max_hp = enemy.get_stat("max_health")["final"]
			return hp <= max_hp * 0.5,
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		tags = ["treasure_loot"]
	})
	
	register_item("spinach", {
		scene = preload("res://equipment/spinach/spinach.tscn"),
		shape = [
			[true ],
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, _grid, _item, _this):
				if stat == "damage":
					modifiers["base"] += 1,
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "health" || stat == "max_health":
					modifiers["base"] += 5},
		tags = ["treasure_loot"]
	})
	
	register_item("cheese", {
		scene = preload("res://equipment/cheese/cheese.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			health_gain = 4
		},
		active_requirement = func(grid, _this):
			return grid.statuses.has("poison"),
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.add_status("poison", -health_gain["final"])
			grid.recover_health(health_gain),
		tags = ["treasure_loot"]
	})
	
	register_item("shiv", {
		scene = preload("res://equipment/shiv/shiv.tscn"),
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
	
	register_item("bandana", {
		scene = preload("res://equipment/bandana/bandana.tscn"),
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
	
	register_item("axe", {
		scene = preload("res://equipment/axe/axe.tscn"),
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
				if stat == "health_gain" and grid.get_connected_items(this, 0).has(item):
					modifiers["base"] += 3},
		tags = ["treasure_loot"]
	})
	
	register_item("roots", {
		scene = preload("res://equipment/roots/roots.tscn"),
		shape = [
			[true , true ],
		],
		stats = {
			health_gain = 2
		},
		passive_ability = {
			game_tick = func(tick, grid, this):
				grid.add_item_stat(this, "charge", tick, "base")
				if grid.get_item_stat(this, "charge")["final"] >= 2.0:
					grid.add_item_stat(this, "charge", -2.0, "base")
					var health_gain = grid.get_item_stat(this, "health_gain")
					grid.add_stat("max_health", health_gain["final"])
					grid.recover_health(health_gain)},
		tags = ["treasure_loot"]
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
			health_gain = 2
		},
		passive_ability = {
			damage_dealt = func(damage, _target, grid, this):
				if damage.has("item_source") and grid.get_connected_items(this, 0).has(damage["item_source"]):
					var health_gain = grid.get_item_stat(this, "health_gain")
					grid.recover_health(health_gain)},
		tags = ["treasure_loot"]
	})
	
	register_item("beef", {
		scene = preload("res://equipment/beef/beef.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "health" || stat == "max_health":
					modifiers["base"] += 25},
		tags = ["treasure_loot"]
	})
	
	register_item("cow_slam", {
		scene = preload("res://equipment/cow_slam/cow_slam.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			damage = 2
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			grid.attack(enemy, damage),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "damage" and item == this:
					var hp = grid.get_stat("health")
					modifiers["base"] += int(hp["final"] / 8)},
		tags = ["treasure_loot"]
	})
	
	register_item("wood", {
		scene = preload("res://equipment/wood/wood.tscn"),
		shape = [
			[true , true , true ],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "shield":
					modifiers["base"] += 25},
		tags = ["treasure_loot"]
	})
	
	register_item("wise_words", {
		scene = preload("res://equipment/wise_words/wise_words.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		active_ability = func(grid, _this):
			var enemy = grid.get_enemy()
			enemy.progress_fatigue(0.75),
		tags = ["treasure_loot"]
	})
	
	register_item("pillow", {
		scene = preload("res://equipment/pillow/pillow.tscn"),
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
				grid.recover_health(health_gain)},
		tags = ["treasure_loot"]
	})
	
	register_item("beehive", {
		scene = preload("res://equipment/beehive/beehive.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			status = 1
		},
		passive_ability = {
			damage_taken = func(damage, grid, this):
				if damage.get("attack"):
					var enemy = grid.get_enemy()
					var status_applied = grid.get_item_stat(this, "status")["final"]
					enemy.add_status("poison", status_applied)},
		tags = ["treasure_loot"],
	})
	
	register_item("stinger", {
		scene = preload("res://equipment/stinger/stinger.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			damage = 4,
			status = 1
		},
		active_ability = func(grid, this):
			var enemy = grid.get_enemy()
			var damage = grid.get_item_stat(this, "damage")
			damage["item_source"] = this
			if grid.attack(enemy, damage):
				var status_applied = grid.get_item_stat(this, "status")["final"]
				enemy.add_status("poison", status_applied),
		tags = ["treasure_loot"],
	})
	
	register_item("honeycomb", {
		scene = preload("res://equipment/honeycomb/honeycomb.tscn"),
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
	
	register_item("hunting_rifle", {
		scene = preload("res://equipment/hunting_rifle/hunting_rifle.tscn"),
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
	
	register_item("berries", {
		scene = preload("res://equipment/berries/berries.tscn"),
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
	
	register_item("fish", {
		scene = preload("res://equipment/fish/fish.tscn"),
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
	
	register_item("mushroom", {
		scene = preload("res://equipment/mushroom/mushroom.tscn"),
		shape = [
			[true ],
			[true ]
		],
		stats = {
			health_gain = 4,
			status = 1
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain)
			var enemy = grid.get_enemy()
			var status_applied = grid.get_item_stat(this, "status")["final"]
			enemy.add_status("poison", status_applied),
		tags = ["treasure_loot"]
	})
	
	register_item("snail_shell", {
		scene = preload("res://equipment/snail_shell/snail_shell.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			health_gained = func(gain, grid, _this):
				var shield_gain = gain.duplicate()
				shield_gain["mult_mult"] *= 0.5
				grid.calculate_modifiers(shield_gain)
				grid.recover_shield(shield_gain)},
		tags = ["treasure_loot"]
	})
	
	register_item("sippy_straw", {
		scene = preload("res://equipment/sippy_straw/sippy_straw.tscn"),
		shape = [
			[true ],
			[true ],
		],
		stats = {
			health_gain = 2
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.add_stat("max_health", health_gain["final"])
			grid.recover_health(health_gain),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "health_gain" and item == this:
					var enemy = grid.get_enemy()
					if enemy and enemy.statuses.has("poison"):
						modifiers["base"] += enemy.statuses["poison"]["stacks"]},
		tags = ["treasure_loot"]
	})
	
	register_item("slime", {
		scene = preload("res://equipment/slime/slime.tscn"),
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
	
	register_item("cauldron", {
		scene = preload("res://equipment/cauldron/cauldron.tscn"),
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
			health_gain = 2,
			status = 1,
		},
		active_ability = func(grid, this):
			var health_gain = grid.get_item_stat(this, "health_gain")
			grid.recover_health(health_gain)
			var enemy = grid.get_enemy()
			var status_applied = grid.get_item_stat(this, "status")["final"]
			enemy.add_status("poison", status_applied),
		passive_ability = {
			item_used = func(item, grid, this):
				if grid.get_connected_items(this, 0).has(item):
					grid.add_item_stat(this, "health_gain", 2)
					grid.add_item_stat(this, "status", 1)
					if not item.get("destroyed"):
						grid.disconnect_item(item)
						item["destroyed"] = true
						item["item_scene"].kill()},
		tags = ["treasure_loot"]
	})
	
	register_item("magic_broom", {
		scene = preload("res://equipment/magic_broom/magic_broom.tscn"),
		shape = [
			[true ],
			[true ],
			[true ],
			[true ],
		],
		stats = {
			status = 2
		},
		passive_ability = {
			battle_start = func(grid, this):
				var status_applied = grid.get_item_stat(this, "status")["final"]
				grid.add_status("dodge", status_applied)},
		tags = ["treasure_loot"]
	})
	
	register_item("cactus", {
		scene = preload("res://equipment/cactus/cactus.tscn"),
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
					grid.deal_damage(enemy, dealt_damage)},
		tags = ["treasure_loot"]
	})
	
	register_item("plasma_core", {
		scene = preload("res://equipment/plasma_core/plasma_core.tscn"),
		shape = [
			[true , true , true ],
			[true , true , true ],
			[true , true , true ],
		],
		passive_ability = {
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "shield":
					modifiers["base"] += 100,
			battle_start = func(grid, _this):
				grid.progress_fatigue(5.0)},
		tags = ["treasure_loot"]
	})
	
	register_item("sunglasses", {
		scene = preload("res://equipment/sunglasses/sunglasses.tscn"),
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
	
	register_item("laser_eyes", {
		scene = preload("res://equipment/laser_eyes/laser_eyes.tscn"),
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
	
	register_item("globe", {
		scene = preload("res://equipment/globe/globe.tscn"),
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
			grid.add_stat("shield", shield_gain["final"])
			grid.progress_fatigue(0.5),
		tags = ["treasure_loot"]
	})
	
	register_item("deal_with_the_devil", {
		scene = preload("res://equipment/deal_with_the_devil/deal_with_the_devil.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, _grid, _item, _this):
				if stat == "damage":
					modifiers["add_mult"] += 0.5,
			stat_modifiers = func(stat, modifiers, _grid, _this):
				if stat == "max_health" or stat == "health":
					modifiers["mult_mult"] *= 0.5},
		tags = ["treasure_loot"]
	})
	#endregion
