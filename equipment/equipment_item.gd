extends Control 

@export var drag_offset: Vector2

var grid: Node

var grid_size = Vector2(0, 0)
var grid_shape: Array
var equipment_reference: Dictionary
var item_data: Dictionary

var mouse_inside = false

var highlights = []
var descriptions = []

func get_center():
	return position - (grid_size * 24).rotated(rotation)

func get_grid_pos_and_shape(from_position):
	if equipment_reference["rotation"] == 1: ## jank???
		from_position -= Vector2(grid_size.y * 48, 0)
	if equipment_reference["rotation"] == 2:
		from_position -= Vector2(grid_size.x * 48, grid_size.y * 48)
	if equipment_reference["rotation"] == 3:
		from_position -= Vector2(0, grid_size.x * 48)
	
	from_position += Vector2(grid.offset_x, grid.offset_y) * 48
	
	if from_position.x < 0: ## fix for negative coordinates being wacky
		from_position.x -= 48
	if from_position.y < 0:
		from_position.y -= 48
		
	from_position.x = int((from_position.x + 24) / 48)
	from_position.y = int((from_position.y + 24) / 48)
	
	var rotated_grid_shape = grid.rotate_shape(grid_shape, equipment_reference["rotation"])
	
	return {position = from_position, shape = rotated_grid_shape}

func highlight_slot(x, y):
	var highlight_instance = load("res://equipment/grid_slot.tscn").instantiate()
	highlight_instance.position = Vector2(48 * (x - grid.offset_x), 48 * (y - grid.offset_y))
	highlight_instance.z_index += 1
	highlights.append(highlight_instance)
	grid.add_child(highlight_instance)
	if y < 0 or y >= grid.layout.size() or not grid.layout.get(y):
		highlight_instance.modulate = Color.RED
		return false
	if x < 0 or x >= grid.layout[y].size() or not grid.layout[y].get(x):
		highlight_instance.modulate = Color.RED
		return false
	if grid.get_item_at_position(x, y):
		highlight_instance.modulate = Color.YELLOW
	else:
		highlight_instance.modulate = Color.GREEN
	return true

func highlight_connection(x, y, active, inactive):
	var highlight_instance
	if grid.get_item_at_position(x, y):
		highlight_instance = active.instantiate()
	else:
		highlight_instance = inactive.instantiate()
	highlight_instance.position = Vector2(48 * (x - grid.offset_x), 48 * (y - grid.offset_y))
	highlights.append(highlight_instance)
	grid.add_child(highlight_instance)
	return true

func highlight(from_position):
	unhighlight()
	
	var pos_and_shape = get_grid_pos_and_shape(from_position)
	from_position = pos_and_shape.position
	var rotated_grid_shape = pos_and_shape.shape
	
	if item_data.has("connections"):
		for connections in item_data["connections"]:
			var rotated_connections = grid.rotate_shape(connections["shape"], equipment_reference["rotation"])
			var rotated_offset = Vector2i(connections["offset"].x, connections["offset"].y)
			if equipment_reference["rotation"] == 1: ##JANK
				rotated_offset = Vector2i(-rotated_offset.y, rotated_offset.x)
				rotated_offset += Vector2i(rotated_grid_shape[0].size(), 0)
				rotated_offset -= Vector2i(rotated_connections[0].size(), 0)
			elif equipment_reference["rotation"] == 2:
				rotated_offset = Vector2i(-rotated_offset.x, -rotated_offset.y)
				rotated_offset += Vector2i(rotated_grid_shape[0].size(), rotated_grid_shape.size())
				rotated_offset -= Vector2i(rotated_connections[0].size(), rotated_connections.size())
			elif equipment_reference["rotation"] == 3:
				rotated_offset = Vector2i(rotated_offset.y, -rotated_offset.x)
				rotated_offset += Vector2i(0, rotated_grid_shape.size())
				rotated_offset -= Vector2i(0, rotated_connections.size())
			for y in rotated_connections.size():
				var row = rotated_connections[y]
				for x in row.size():
					if row[x]:
						highlight_connection(from_position.x + rotated_offset.x + x, from_position.y + rotated_offset.y + y, connections["active"], connections["inactive"])
	
	for y in rotated_grid_shape.size():
		var row = rotated_grid_shape[y]
		for x in row.size():
			if row[x]:
				highlight_slot(from_position.x + x, from_position.y + y)

func unhighlight():
	for highlight_instance in highlights:
		highlight_instance.queue_free()
	highlights.clear()

func equip(from_position):
	var pos_and_shape = get_grid_pos_and_shape(from_position)
	from_position = pos_and_shape.position
	var rotated_grid_shape = pos_and_shape.shape
	
	if from_position.x < 0 or from_position.y < 0 or from_position.x + rotated_grid_shape[0].size() > grid.layout[0].size() or from_position.y + rotated_grid_shape.size() > grid.layout.size():
		unequip()
		return false
	
	for y in rotated_grid_shape.size():
		var row = rotated_grid_shape[y]
		for x in row.size():
			if row[x] and not grid.layout[from_position.y + y][from_position.x + x]:
				unequip()
				return false
	
	for y in rotated_grid_shape.size():
		var row = rotated_grid_shape[y]
		for x in row.size():
			if row[x]:
				var item = grid.get_item_at_position(from_position.x + x, from_position.y + y)
				if item:
					#var to_item_scene = (get_center()).direction_to(item["item_scene"].get_center())
					#item["item_scene"].position += to_item_scene * 48
					item["item_scene"].unequip()
					
	
	equipment_reference["position"] = from_position
	
	position = (equipment_reference["position"] - Vector2(grid.offset_x, grid.offset_y)) * 48
	
	if equipment_reference["rotation"] == 1: ## jank???
		position += Vector2(grid_size.y * 48, 0)
	if equipment_reference["rotation"] == 2:
		position += Vector2(grid_size.x * 48, grid_size.y * 48)
	if equipment_reference["rotation"] == 3:
		position += Vector2(0, grid_size.x * 48)
	
	equipment_reference["equipped"] = true
	grid.move_child(self, 0)
	return true

func unequip():
	equipment_reference["equipped"] = false
	move_to_front()

func _on_gui_input(event: InputEvent) -> void:
	if not grid.can_edit:
		return
	if event is InputEventMouseMotion:
		if grid.dragging == self:
			position = grid.get_local_mouse_position() - (grid_size * 24 + drag_offset).rotated(rotation)
			highlight(position)
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				modulate = Color.WHITE
				grid.dragging = self
				unequip()
				position = grid.get_local_mouse_position() - (grid_size * 24 + drag_offset).rotated(rotation) 
				highlight(position)
				undescribe()
			else:
				grid.dragging = null
				equip(grid.get_local_mouse_position() - (grid_size * 24 + drag_offset).rotated(rotation))
				if mouse_inside:
					if equipment_reference["equipped"]:
						highlight(position)
					else:
						unhighlight()
					describe()
				else:
					unhighlight()
					undescribe()
		elif grid.dragging == self and event.button_index == 2 and event.pressed:
			equipment_reference["rotation"] = (equipment_reference["rotation"] + 1) % 4
			rotation = equipment_reference["rotation"] * PI * 0.5
			position = grid.get_local_mouse_position() - (grid_size * 24 + drag_offset).rotated(rotation)
			highlight(position)

var flash_progress = 0.0
var flash_direction = 1
func _process(delta: float) -> void:
	if not equipment_reference["equipped"] and grid.dragging != self:
		flash_progress = clampf(flash_progress + delta * flash_direction * 2.5, 0.0, 1.0)
		if flash_progress == 1.0:
			flash_direction = -1
		elif flash_progress == 0.0:
			flash_direction = 1
		modulate = lerp(Color.WHITE, Color.DIM_GRAY, flash_progress)

func describe():
	var description_instance = preload("res://description.tscn").instantiate()
	if global_position.x + grid_size.x * 24 > 450:
		description_instance.position = Vector2(48, 12)
	else:
		description_instance.position = Vector2(602, 12)
	var format = {}
	if item_data.has("stats"):
		for key in item_data["stats"].keys():
			format[key] = grid.get_item_stat(equipment_reference, key)["final"]
	description_instance.text = tr(equipment_reference["type"] + "_title")
	description_instance.get_node("Body").text = tr(equipment_reference["type"] + "_description").format(format)
	#String
	grid.add_sibling(description_instance)
	descriptions.append(description_instance)

func undescribe():
	for description_instance in descriptions:
		description_instance.queue_free()
	descriptions.clear()

func _notification(what: int) -> void: ##TODO: may cause flickering with certain item shapes
	if what == NOTIFICATION_MOUSE_ENTER:
		mouse_inside = true
		if not grid.dragging:
			if equipment_reference["equipped"]:
				highlight(position)
			describe()
	elif what == NOTIFICATION_MOUSE_EXIT:
		mouse_inside = false
		unhighlight()
		undescribe()
