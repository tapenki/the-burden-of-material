extends EquipmentItem

func highlight_slot(x, y):
	var highlight_instance = preload("res://ui/grid_slot.tscn").instantiate()
	highlight_instance.position = Vector2(48 * (x - grid.offset_x), 48 * (y - grid.offset_y))
	highlight_instance.z_index += 1
	highlights.append(highlight_instance)
	grid.add_child(highlight_instance)
	
	if y < 0 or y >= grid.layout.size():
		highlight_instance.modulate = Color.RED
		return false
	if x < 0 or x >= grid.layout[y].size():
		highlight_instance.modulate = Color.RED
		return false
	
	if not grid.layout[y].get(x):
		highlight_instance.modulate = Color.CYAN
		return true
	
	if grid.get_item_at_position(x, y):
		highlight_instance.modulate = Color.YELLOW
	else:
		highlight_instance.modulate = Color.GREEN
	return true

func equip(from_position):
	var pos_and_shape = get_grid_pos_and_shape(from_position)
	from_position = pos_and_shape.position
	var rotated_grid_shape = pos_and_shape.shape
	
	var unequipped = false
	var applied = false
	for y in rotated_grid_shape.size():
		var row = rotated_grid_shape[y]
		for x in row.size():
			if row[x]:
				if from_position.x + x < 0 or from_position.y + y < 0:
					unequipped = true
					continue
				if from_position.x + x >= grid.layout[0].size() or from_position.y + y >= grid.layout.size():
					unequipped = true
					continue
				if not grid.layout[from_position.y + y][from_position.x + x]:
					grid.unlock_slot(from_position.x + x, from_position.y + y)
					applied = true
	if applied:
		grid.equipment.erase(equipment_reference)
		kill()
		return false
	elif unequipped:
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
	grid.connect_item(equipment_reference)
	z_index = 0
	grid.move_child(self, 0)
	return true
