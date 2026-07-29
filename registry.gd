extends Node

var item_data = {}
var item_tag_lists = {}

var zone_data = {}
var zone_tiers = {}

var encounter_data = {}

var character_data = {}

func register_zone(zone_name, zone_tier):
	zone_data[zone_name] = {encounters = []}
	if not zone_tiers.has(zone_tier):
		zone_tiers[zone_tier] = []
	zone_tiers[zone_tier].append(zone_name)

func register_item(item_name, item_definition):
	item_data[item_name] = item_definition
	if item_definition.has("tags"):
		for tag in item_definition["tags"]:
			if not item_tag_lists.has(tag):
				item_tag_lists[tag] = []
			item_tag_lists[tag].append(item_name)

func register_encounter(encounter_name, encounter_definition, encounter_zones = []):
	encounter_data[encounter_name] = encounter_definition
	for zone in encounter_zones:
		zone_data[zone]["encounters"].append(encounter_name)

func register_character(character_name, character_definition):
	character_data[character_name] = character_definition

func _init() -> void:
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
			grid.deal_damage(enemy, damage),
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
			grid.deal_damage(enemy, damage),
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
					modifiers["base"] += 1}
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
					modifiers["base"] += 2}
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
					modifiers["base"] += 2}
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
					grid.recover_health(recovery)}
	})
	
	register_item("beef", {
		scene = preload("res://equipment/beef/beef.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		stats = {
			recovery = 30
		},
		passive_ability = {
			battle_start = func(grid, this):
				var recovery = grid.get_item_stat(this, "recovery")
				grid.add_stat("max_health", recovery["final"])
				grid.recover_health(recovery)}
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
			grid.deal_damage(enemy, damage),
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, grid, item, this):
				if stat == "damage" and item == this:
					var hp = grid.get_stat("health")
					modifiers["base"] += int(hp["final"] / 8)}
	})
	
	register_item("wood", {
		scene = preload("res://equipment/wood/wood.tscn"),
		shape = [
			[true , true , true ],
		],
		stats = {
			shield = 30
		},
		passive_ability = {
			battle_start = func(grid, this):
				var shield = grid.get_item_stat(this, "shield")
				grid.recover_shield(shield)}
	})
	
	register_item("wise_words", {
		scene = preload("res://equipment/wise_words/wise_words.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		active_ability = func(grid, _this):
			var enemy = grid.get_enemy()
			enemy.progress_fatigue(0.5)
	})
	#endregion
