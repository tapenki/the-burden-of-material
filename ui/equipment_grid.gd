extends Control

@export var can_edit = true
@export var character_sprite: Node

var character: String

var layout = [
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ],
	[true , true , true , true , true , true , true , true ]
]
var offset_x = 4
var offset_y = 4

var equipment: Array
var statuses: Dictionary

var stats = {
	max_health = 50,
	health = 50,
	cooldown = 1.0,
	loot_quantity = 1
}

var stat_changes: Dictionary

var team: int
var target_team: int
var target_enemy: int

var dragging: Node

signal stat_modifiers(arguments)
signal item_stat_modifiers(arguments)

signal item_used(arguments)
signal can_use_item(arguments)

signal damage_dealt(arguments)
signal damage_taken(arguments)
signal check_evasion(arguments)

signal health_gained(arguments)

signal game_tick(arguments)

signal fatigue_start(arguments)

signal battle_start(arguments)

var signals = [
	stat_modifiers,
	item_stat_modifiers,
	item_used,
	can_use_item,
	damage_dealt,
	damage_taken,
	check_evasion,
	health_gained,
	game_tick,
	fatigue_start,
	battle_start,
]

func calculate_modifiers(modifiers):
	modifiers["final"] = modifiers["base"] * modifiers["add_mult"] * modifiers["mult_mult"]
	if modifiers["base"] is int:
		modifiers["final"] = (int)(modifiers["final"])

func get_stat(stat):
	var modifiers = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	if stat_changes.has(stat):
		modifiers = stat_changes[stat].duplicate()
	modifiers["base"] += stats.get(stat, 0)
	stat_modifiers.emit([stat, modifiers, self])
	calculate_modifiers(modifiers)
	return modifiers

func add_stat(stat, value, operation = "base"):
	if not stat_changes.has(stat):
		stat_changes[stat] = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	stat_changes[stat][operation] += value

func set_stat(stat, value):
	if not stat_changes.has(stat):
		stat_changes[stat] = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	var offset = get_stat(stat)["final"] - value
	stat_changes[stat]["base"] -= offset

func get_item_stat(item, stat):
	var item_data = Registry.item_data[item["type"]]
	var modifiers = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	if item.has("stat_changes") and item["stat_changes"].has(stat):
		modifiers = item["stat_changes"][stat].duplicate()
	if item_data.has("stats"):
		modifiers["base"] += item_data["stats"].get(stat, 0)
	item_stat_modifiers.emit([stat, modifiers, self, item])
	calculate_modifiers(modifiers)
	return modifiers

func add_item_stat(item, stat, value, operation = "base"):
	if not item.has("stat_changes"):
		item["stat_changes"] = {}
	if not item["stat_changes"].has(stat):
		item["stat_changes"][stat] = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	item["stat_changes"][stat][operation] += value

func set_item_stat(item, stat, value):
	if not item.has("stat_changes"):
		item["stat_changes"] = {}
	if not item["stat_changes"].has(stat):
		item["stat_changes"][stat] = {"base" = 0, "add_mult" = 1, "mult_mult" = 1}
	var offset = get_item_stat(item, stat)["final"] - value
	item["stat_changes"][stat]["base"] -= offset

func instantiate_item(item):
	var item_data = Registry.item_data[item["type"]]
	item["item_scene"] = item_data["scene"].instantiate()
	
	item["item_scene"].grid = self
	item["item_scene"].equipment_reference = item
	item["item_scene"].item_data = item_data
	
	item["item_scene"].grid_shape = item_data["shape"]
	item["item_scene"].grid_size = Vector2(item_data["shape"][0].size(), item_data["shape"].size())
	
	item["item_scene"].rotation = item["rotation"] * PI * 0.5
	item["item_scene"].position = Vector2(48 * (item["position"].x - offset_x), 48 * (item["position"].y - offset_y))
	
	if item["rotation"] == 1: ## jank???
		item["item_scene"].position += Vector2(item["item_scene"].grid_size.y * 48, 0)
	if item["rotation"] == 2:
		item["item_scene"].position += Vector2(item["item_scene"].grid_size.x * 48, item["item_scene"].grid_size.y * 48)
	if item["rotation"] == 3:
		item["item_scene"].position += Vector2(0, item["item_scene"].grid_size.x * 48)
	
	if not item.get("equipped", true):
		item["item_scene"].z_index = 3
	
	add_child(item["item_scene"])

func connect_item(item):
	if not item.get("connected_callables"):
		var item_data = Registry.item_data[item["type"]]
		if item_data.has("passive_ability"):
			item["passive_ability"] = item_data["passive_ability"].duplicate()
			for key in item["passive_ability"].keys():
				var ability = item["passive_ability"][key]
				var wrapper = func(arguments): ## workaround to allow duplicate connections
					ability.bind(item).callv(arguments)
				self[key].connect(wrapper)
				if not item.get("connected_callables"):
					item["connected_callables"] = {}
					item["connected_callables"][key] = wrapper

func disconnect_item(item):
	if item.get("connected_callables"):
		for key in item["connected_callables"].keys():
			var callable = item["connected_callables"][key]
			if self[key].is_connected(callable):
				self[key].disconnect(callable)
	item.erase("connected_callables")

func load_item(item):
	if item.get("equipped", true):
		connect_item(item)
	instantiate_item(item)

func remove_status(status):
	if statuses[status].get("connected_callables"):
		for key in statuses[status]["connected_callables"].keys():
			var callable = statuses[status]["connected_callables"][key]
			if self[key].is_connected(callable):
				self[key].disconnect(callable)
	statuses[status]["status_scene"].queue_free()
	statuses.erase(status)

func add_status(status, stacks):
	if statuses.has(status):
		statuses[status]["stacks"] += stacks
		if statuses[status]["stacks"] <= 0:
			remove_status(status)
			return
	else:
		var status_instance = preload("res://ui/status_label.tscn").instantiate()
		if character_sprite.flip_h:
			status_instance.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
		character_sprite.get_node("Statuses").add_child(status_instance)
		statuses[status] = {"stacks" = stacks, "status_scene" = status_instance}
		if not statuses[status].get("connected_callables"):
			var status_data = Registry.status_data[status]
			if status_data.has("passive_ability"):
				statuses[status]["passive_ability"] = status_data["passive_ability"].duplicate()
				for key in statuses[status]["passive_ability"].keys():
					var ability = statuses[status]["passive_ability"][key]
					var wrapper = func(arguments): ## workaround to allow duplicate connections
						ability.bind(statuses[status]).callv(arguments)
					self[key].connect(wrapper)
					if not statuses[status].get("connected_callables"):
						statuses[status]["connected_callables"] = {}
						statuses[status]["connected_callables"][key] = wrapper
	statuses[status]["status_scene"].text = tr("status_"+status+"_title") + " ({stacks})".format({stacks = statuses[status]["stacks"]})
	if stacks >= 0:
		text_effect("+" + str(stacks), Color.WHITE)
	else:
		text_effect(str(stacks), Color.WHITE)

func unload_grid():
	for check_signal in signals:
		for connection in check_signal.get_connections():
			check_signal.disconnect(connection["callable"])
	for child in get_children():
		child.queue_free()
	for item in equipment:
		disconnect_item(item)

func load_grid():
	unload_grid()
	for y in layout.size():
		var row = layout[y]
		for x in row.size():
			var value = row[x]
			if value:
				var grid_slot = preload("res://ui/grid_slot.tscn").instantiate()
				grid_slot.position = Vector2(48 * (x - offset_x), 48 * (y - offset_y))
				add_child(grid_slot)
	for item in equipment:
		load_item(item)

func unlock_slot(x, y):
	if not layout[y][x]:
		layout[y][x] = true
		var grid_slot = preload("res://ui/grid_slot.tscn").instantiate()
		grid_slot.position = Vector2(48 * (x - offset_x), 48 * (y - offset_y))
		add_child(grid_slot)

func _ready() -> void:
	get_node("/root/Game").tick.connect(_on_game_tick)
	get_node("/root/Game").battle_initiated.connect(_on_battle_initiated)

func rotate_shape(grid_shape, grid_rotation):
	var rotated_grid_shape = []
	if grid_rotation == 0:
		rotated_grid_shape = grid_shape.duplicate(true)
	if grid_rotation == 1: ## jank???
		for x in grid_shape[0].size():
			if not rotated_grid_shape.has(x):
				rotated_grid_shape.append([])
		for y in range(grid_shape.size() - 1, - 1, - 1):
			var row = grid_shape[y]
			for x in row.size():
				var value = row[x]
				rotated_grid_shape[x].append(value)
	if grid_rotation == 2:
		for y in grid_shape.size():
			if not rotated_grid_shape.has(y):
				rotated_grid_shape.append([])
		for y in grid_shape.size():
			var row = grid_shape[y]
			for x in range(row.size() - 1, - 1, - 1):
				var value = row[x]
				rotated_grid_shape[grid_shape.size() - 1 - y].append(value)
	if grid_rotation == 3:
		for x in grid_shape[0].size():
			if not rotated_grid_shape.has(x):
				rotated_grid_shape.append([])
		for y in grid_shape.size():
			var row = grid_shape[y]
			for x in row.size():
				var value = row[x]
				rotated_grid_shape[row.size() - 1 - x].append(value)
	return rotated_grid_shape

func get_item_at_position(at_x, at_y):
	for item in equipment:
		if not item.get("equipped", true):
			continue
		var item_data = Registry.item_data[item["type"]]
		var shape = rotate_shape(item_data["shape"], item["rotation"])
		for y in shape.size():
			var row = shape[y]
			for x in row.size():
				if row[x] and at_x == item["position"].x + x and at_y == item["position"].y + y:
					return item

func get_connected_items(item, connections_index):
	var connected = []
	var item_data = Registry.item_data[item["type"]]
	if not item_data.has("connections") or not item.get("equipped", true):
		return connected
	var rotated_grid_shape = rotate_shape(item_data["shape"], item["rotation"])
	#for connections in item_data["connections"]:
	var connections = item_data["connections"][connections_index]
	var rotated_connections = rotate_shape(connections["shape"], item["rotation"])
	var rotated_offset = Vector2i(connections["offset"].x, connections["offset"].y)
	if item["rotation"] == 1: ##JANK
		rotated_offset = Vector2i(-rotated_offset.y, rotated_offset.x)
		rotated_offset += Vector2i(rotated_grid_shape[0].size(), 0)
		rotated_offset -= Vector2i(rotated_connections[0].size(), 0)
	elif item["rotation"] == 2:
		rotated_offset = Vector2i(-rotated_offset.x, -rotated_offset.y)
		rotated_offset += Vector2i(rotated_grid_shape[0].size(), rotated_grid_shape.size())
		rotated_offset -= Vector2i(rotated_connections[0].size(), rotated_connections.size())
	elif item["rotation"] == 3:
		rotated_offset = Vector2i(rotated_offset.y, -rotated_offset.x)
		rotated_offset += Vector2i(0, rotated_grid_shape.size())
		rotated_offset -= Vector2i(0, rotated_connections.size())
	for y in rotated_connections.size():
		var row = rotated_connections[y]
		for x in row.size():
			if row[x]:
				var connected_item = get_item_at_position(item["position"].x + rotated_offset.x + x, item["position"].y + rotated_offset.y + y)
				if connected_item and not connected.has(connected_item):
					connected.append(connected_item)
	return connected

func get_enemy():
	var battle = get_node("/root/Game").battle
	if not battle.get("active"):
		return null
	return battle["teams"][target_team][target_enemy]

func take_damage(damage):
	var shield = get_stat("shield")
	if shield["final"] >= damage["final"]:
		add_stat("shield", -damage["final"])
	else:
		var health_damage = damage["final"] - shield["final"]
		add_stat("shield", -shield["final"])
		add_stat("health", -health_damage)
	
	text_effect("-" + str(damage["final"]), Color.RED)
	damage_taken.emit([damage, self])

func deal_damage(target, damage):
	target.take_damage(damage)
	damage_dealt.emit([damage, target, self])

func attack(target, damage):
	var attack_landed = {landed = true}
	target.check_evasion.emit([attack_landed, target])
	if not attack_landed["landed"]:
		target.text_effect("message_miss", Color.RED)
		return false
	damage["attack"] = true
	deal_damage(target, damage)
	return true

func recover_health(gain):
	var hp = get_stat("health")["final"]
	var max_hp = get_stat("max_health")["final"]
	if hp + gain["final"] >= max_hp:
		add_stat("health", max_hp - hp)
	else:
		add_stat("health", gain["final"])
	text_effect("+" + str(gain["final"]), Color.GREEN)
	health_gained.emit([gain, self])

func recover_shield(gain):
	add_stat("shield", gain["final"])
	text_effect("+" + str(gain["final"]), Color.ORANGE)

func use_item():
	var useable_items = []
	for item in equipment:
		var item_data = Registry.item_data[item["type"]]
		if item_data.has("active_requirement") and not item_data["active_requirement"].call(self, item):
			continue
		var item_usability_modifiers = {usable = true}
		can_use_item.emit([item_usability_modifiers, item, self])
		if not item_usability_modifiers["usable"]:
			continue
		if item_data.has("active_ability") and not item.get("used") and not item.get("destroyed") and item.get("equipped", true):
			useable_items.append(item)
	if useable_items.size() > 0:
		var item = useable_items.pick_random()
		var item_data = Registry.item_data[item["type"]]
		item["used"] = true
		item["item_scene"].pop()
		item_data["active_ability"].call(self, item)
		item_used.emit([item, self])
	else:
		for item in equipment:
			var item_data = Registry.item_data[item["type"]]
			if item_data.has("active_ability") and item.get("used"):
				item["used"] = false

func text_effect(text, color = Color.BLACK):
	var label_instance = preload("res://ui/floating_text.tscn").instantiate()
	label_instance.text = text
	label_instance.modulate = color
	character_sprite.add_child(label_instance)
	label_instance.position = Vector2(randf_range(0, character_sprite.size.x * 0.5) + character_sprite.size.x * 0.25, randf_range(0, character_sprite.size.y * 0.5)) - label_instance.size * 0.5
	var tween = create_tween()
	tween.tween_property(label_instance, "position:y", -20, 0.2).as_relative()
	await get_tree().create_timer(0.5).timeout
	label_instance.queue_free()

func _process(_delta: float) -> void:
	#var battle = get_node("/root/Game").battle
	#if not battle.get("active"):
	#	return
	var chargebar_max_value_tween = create_tween()
	chargebar_max_value_tween.tween_property(character_sprite.get_node("ChargeBar"), "max_value", get_stat("cooldown")["final"], 0.05)
	var chargebar_value_tween = create_tween()
	chargebar_value_tween.tween_property(character_sprite.get_node("ChargeBar"), "value", get_stat("charge")["final"], 0.05)
	
	var hp = get_stat("health")["final"]
	var max_hp = get_stat("max_health")["final"]
	var lifebar_max_value_tween = create_tween()
	lifebar_max_value_tween.tween_property(character_sprite.get_node("LifeBar"), "max_value", max_hp, 0.05)
	var lifebar_value_tween = create_tween()
	lifebar_value_tween.tween_property(character_sprite.get_node("LifeBar"), "value", hp, 0.05)
	character_sprite.get_node("LifeBar/Label").text = str(hp) + "/" + str(max_hp)
	var shield = get_stat("shield")["final"]
	if shield > 0:
		character_sprite.get_node("LifeBar/Label").text += "+" + str(shield)

func progress_fatigue(time):
	add_stat("fatigue", time)
	var fatigue = get_stat("fatigue")["final"]
	var threshold = get_stat("fatigue_threshold")["final"]
	if fatigue < 20 + threshold:
		return
	if threshold == 0:
		fatigue_start.emit([self])
		text_effect("message_fatigue", Color.PURPLE)
	var fatigue_damage = 1 + int(floor(threshold))
	add_stat("fatigue_threshold", 0.5)
	take_damage({"base" = fatigue_damage, "add_mult" = 1, "mult_mult" = 1, "final" = fatigue_damage, "fatigue" = true})

func _on_game_tick(tick) -> void:
	var cooldown = get_stat("cooldown")["final"]
	if get_stat("charge")["final"] >= cooldown:
		use_item()
		add_stat("charge", -cooldown)
	add_stat("charge", tick)
	
	progress_fatigue(tick)
	
	game_tick.emit([tick, self])
	

func _on_battle_initiated():
	battle_start.emit([self])
