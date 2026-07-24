extends Control

@export var can_edit = true

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

var equipment = [{
		type = "shiv",
		position = Vector2(2, 1),
		rotation = 0,
		equipped = true
	},
	{
		type = "axe",
		position = Vector2(4, 1),
		rotation = 0,
		equipped = true
	}]

var dragging: Node

signal item_stat_modifiers(stat, modifiers, grid, item)
func get_item_stat(item, stat):
	var item_data = Registry.item_data[item["type"]]
	var modifiers = {"base" = 0, "multiplier" = 1}
	if item_data.has("stats"):
		modifiers["base"] += item_data["stats"].get(stat, 0)
	item_stat_modifiers.emit(stat, modifiers, self, item)
	modifiers["final"] = modifiers["base"] * modifiers["multiplier"]
	return modifiers

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
		item["item_scene"].position += Vector2(item["item_scene"].size.y, 0)
	if item["rotation"] == 2:
		item["item_scene"].position += Vector2(item["item_scene"].size.x, item["item_scene"].size.y)
	if item["rotation"] == 3:
		item["item_scene"].position += Vector2(0, item["item_scene"].size.x)
	
	add_child(item["item_scene"])

func load_item(item):
	var item_data = Registry.item_data[item["type"]]
	if item_data.has("passive_ability"):
		for key in item_data["passive_ability"].keys():
			var ability = item_data["passive_ability"][key]
			self[key].connect(ability.bind(item))
	instantiate_item(item)

func load_grid():
	for child in get_children():
		child.queue_free()
	for y in layout.size():
		var row = layout[y]
		for x in row.size():
			var value = row[x]
			if value:
				var grid = load("res://equipment/grid_slot.tscn").instantiate()
				grid.position = Vector2(48 * (x - offset_x), 48 * (y - offset_y))
				add_child(grid)
	for item in equipment:
		load_item(item)

func _ready() -> void:
	load_grid()

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
		if not item["equipped"]:
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
	if not item_data.has("connections") or not item["equipped"]:
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
