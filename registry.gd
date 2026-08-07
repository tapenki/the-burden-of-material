extends Node

var item_data = {}
var item_tag_lists = {}

var status_data = {}
var status_tag_lists = {}

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
	if status_definition.has("tags"):
		for tag in status_definition["tags"]:
			if not status_tag_lists.has(tag):
				status_tag_lists[tag] = []
			status_tag_lists[tag].append(status_name)

func register_encounter(encounter_name, encounter_definition, days = []):
	encounter_data[encounter_name] = encounter_definition
	for day in days:
		if not encounter_schedule.has(day):
			encounter_schedule[day] = []
		encounter_schedule[day].append(encounter_name)

func register_character(character_name, character_definition):
	character_data[character_name] = character_definition

func _ready() -> void:
	## statuses
	register_status("poison", {
		counteracts = "regeneration",
		passive_ability = {
			game_tick = func(tick, grid, this):
				if not this.has("charge"):
					this["charge"] = 0
				this["charge"] += tick
				if this["charge"] >= 2.0:
					this["charge"] -= 2.0
					var damage = {"final" = this["stacks"]}
					grid.deal_damage(grid, damage)},
		tags = ["debuff"]
	})
	
	register_status("regeneration", {
		counteracts = "poison",
		passive_ability = {
			game_tick = func(tick, grid, this):
				if not this.has("charge"):
					this["charge"] = 0
				this["charge"] += tick
				if this["charge"] >= 2.0:
					this["charge"] -= 2.0
					var health_gain = {"final" = this["stacks"]}
					grid.recover_health(health_gain)},
		tags = ["buff"]
	})
	
	register_status("dodge", {
		passive_ability = {
			check_evasion = func(attack_landed, grid, _this):
				attack_landed["landed"] = false
				grid.add_status("dodge", -1)},
		tags = ["buff"]
	})
	
	register_status("strength", {
		passive_ability = {
			item_stat_modifiers = func(stat, modifiers, _grid, _item, this):
				if stat == "damage":
					modifiers["base"] += this["stacks"]},
		tags = ["buff"]
	})
	## pockets
	register_item("magic_pockets_o", {
		scene = preload("res://equipment/m/magic_pockets/pockets_o.tscn"),
		shape = [
			[true , true ],
			[true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_i", {
		scene = preload("res://equipment/m/magic_pockets/pockets_i.tscn"),
		shape = [
			[true , true , true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_t", {
		scene = preload("res://equipment/m/magic_pockets/pockets_t.tscn"),
		shape = [
			[true , true , true ],
			[false, true , false],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_s", {
		scene = preload("res://equipment/m/magic_pockets/pockets_s.tscn"),
		shape = [
			[false, true , true ],
			[true , true , false],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_z", {
		scene = preload("res://equipment/m/magic_pockets/pockets_z.tscn"),
		shape = [
			[true , true , false],
			[false, true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_l", {
		scene = preload("res://equipment/m/magic_pockets/pockets_l.tscn"),
		shape = [
			[true , false],
			[true , false],
			[true , true ],
		],
		tags = ["pockets"]
	})
	
	register_item("magic_pockets_j", {
		scene = preload("res://equipment/m/magic_pockets/pockets_j.tscn"),
		shape = [
			[false, true ],
			[false, true ],
			[true , true ],
		],
		tags = ["pockets"]
	})
