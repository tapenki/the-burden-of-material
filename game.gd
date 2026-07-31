extends Control

@onready var player_equipment = get_node("PlayerEquipment")
@onready var enemy_equipment = get_node("EnemyEquipment")

var day = 0

var lives = 3

var battle: Dictionary

signal battle_initiated()
signal battle_ended()

signal tick(time)

func init_battle(encounter):
	var encounter_data = Registry.encounter_data[encounter]
	battle = {teams = [[player_equipment], [enemy_equipment]], active = true}
	
	#player_equipment.stat_changes.clear()
	player_equipment.team = 0
	player_equipment.target_team = 1
	player_equipment.target_enemy = 0
	
	var cooldown = player_equipment.get_stat("cooldown")["final"]
	player_equipment.add_stat("charge", cooldown*0.5)
	
	enemy_equipment.character_sprite.texture = encounter_data["enemies"][0]["character"]
	enemy_equipment.layout = encounter_data["enemies"][0]["layout"].duplicate(true)
	enemy_equipment.equipment = encounter_data["enemies"][0]["equipment"].duplicate(true)
	enemy_equipment.team = 1
	enemy_equipment.target_team = 0
	enemy_equipment.target_enemy = 0
	
	for team in battle["teams"]:
		for battler in team:
			var cleared_items = []
			for item in battler.equipment:
				if not item.get("equipped", true):
					item["item_scene"].kill()
					cleared_items.append(item)
			for item in cleared_items:
				battler.equipment.erase(item)
			battler.load_grid()
	
	battle_initiated.emit()

func end_battle():
	for team in battle["teams"]:
		for battler in team:
			battler.stat_changes.clear()
			for item in battler.equipment:
				if item.has("stat_changes"):
					item["stat_changes"] = {}
				item["used"] = false
			battler.load_grid()
			#if team.has(player_equipment):
				#pass
				#battler.character_sprite.get_node("LifeBar").visible = false
				#battler.character_sprite.get_node("ChargeBar").visible = false
			#else:
				#battler.visible = false
				#battler.character_sprite.visible = false
	battle_ended.emit()

func win_battle():
	enemy_equipment.character_sprite.get_node("DeathOverlay").visible = true
	get_node("BattleEndLabel").visible = true
	get_node("BattleEndLabel").text = "ui_you_win"
	battle["won"] = true
	battle["active"] = false
	battle_ended.emit()

func update_lives():
	var i = 0
	for life_texture in player_equipment.character_sprite.get_node("Lives").get_children():
		if i < lives:
			life_texture.visible = true
		else:
			life_texture.visible = false
		i += 1

func lose_battle():
	player_equipment.character_sprite.get_node("DeathOverlay").visible = true
	get_node("BattleEndLabel").visible = true
	get_node("BattleEndLabel").text = "ui_you_lose"
	battle["won"] = false
	battle["active"] = false
	lives -= 1
	update_lives()
	battle_ended.emit()

func proceed_to_battle():
	if Registry.encounter_schedule.has(day + 1):
		day += 1
	
	var encounter = Registry.encounter_schedule[day].pick_random()
	
	player_equipment.character_sprite.get_node("LifeBar").visible = true
	player_equipment.character_sprite.get_node("ChargeBar").visible = true
	player_equipment.can_edit = false
	enemy_equipment.visible = true
	enemy_equipment.character_sprite.visible = true
	get_node("DayCounter").visible = true
	#get_node("BattleTimer").visible = true
	get_node("SpeedButton").visible = true
	get_node("RewardBackground").visible = false
	get_node("CharacterPicker").visible = false
	get_node("ProceedToBattle").visible = false
	
	get_node("DayCounter").text = tr("ui_day_counter").format({day = day})
	init_battle(encounter)

func items_from_pool(list, pool, quantity):
	if not Registry.item_tag_lists.has(pool):
		return
	var valid_items = Registry.item_tag_lists[pool].duplicate()
	for i in quantity:
		if valid_items.size() == 0:
			return
		var chosen_item = valid_items.pick_random()
		list.append(chosen_item)
		valid_items.erase(chosen_item)

func generate_reward(items):
	for i in items.size():
		var item = items[i]
		var prize_item = {}
		prize_item["type"] = item
		prize_item["rotation"] = 0
		var item_data = Registry.item_data[item]
		var offset = Vector2(item_data["shape"][0].size(), item_data["shape"].size()) * 0.5
		if items.size()== 1:
			prize_item["position"] = Vector2(14, 4) - offset
		else:
			prize_item["position"] = Vector2(0, 2).rotated(TAU/items.size()*i) - offset + Vector2(14, 4)
		prize_item["equipped"] = false
		player_equipment.equipment.append(prize_item)

func proceed_to_rewards():
	if not battle.has("won"):
		return
	var rewards = []
	if battle["won"]:
		var valid_loot = []
		
		for item in enemy_equipment.equipment:
			valid_loot.append(item)
		
		for i in player_equipment.get_stat("loot_quantity")["final"]:
			if valid_loot.size() <= 0:
				break
			var chosen_item = valid_loot.pick_random()
			rewards.append(chosen_item["type"])
			valid_loot.erase(chosen_item)
		
			get_node("RewardBackground/Title").text = "ui_stolen_goods"
	else:
		if lives <= 0:
			get_tree().reload_current_scene()
			return
		else:
			items_from_pool(rewards, "treasure_loot", 1)
			get_node("RewardBackground/Title").text = "ui_gift_from_grandma"
	
	items_from_pool(rewards, "treasure_loot", 2)
	generate_reward(rewards)
	
	for team in battle["teams"]:
		for battler in team:
			battler.character_sprite.get_node("DeathOverlay").visible = false
			battler.stat_changes.clear()
			for item in battler.equipment:
				if item.has("stat_changes"):
					item["stat_changes"] = {}
				item["used"] = false
				item["destroyed"] = false
			for status in battler.statuses.keys():
				battler.remove_status(status)
			battler.load_grid()
			#if team.has(player_equipment):
			#	battler.character_sprite.get_node("LifeBar").visible = false
			#	battler.character_sprite.get_node("ChargeBar").visible = false
			if not team.has(player_equipment):
				battler.visible = false
				battler.character_sprite.visible = false
	get_node("RewardBackground").visible = true
	get_node("ProceedToBattle").visible = true
	#get_node("BattleTimer").visible = false
	get_node("SpeedButton").visible = false
	get_node("BattleEndLabel").visible = false
	battle = {}
	player_equipment.can_edit = true
	

#func _ready() -> void:
	#proceed_to_battle()

func _physics_process(_delta: float) -> void:
	if not battle.get("active"):
		return
	tick.emit(0.05)
	
	var enemy_dead = true
	var player_dead = true
	for team in battle["teams"]:
		for battler in team:
			if battler.get_stat("health")["final"] > 0:
				if team.has(player_equipment):
					player_dead = false
				else:
					enemy_dead = false
	if enemy_dead:
		win_battle()
	elif player_dead:
		lose_battle()
