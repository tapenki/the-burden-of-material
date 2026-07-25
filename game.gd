extends Control

@onready var player_equipment = get_node("PlayerEquipment")
@onready var enemy_equipment = get_node("EnemyEquipment")

var zone = "field"
var day = 0

var battle: Dictionary

signal battle_initiated()
signal battle_ended()

func init_battle(encounter):
	var encounter_data = Registry.encounter_data[encounter]
	battle = {teams = [[player_equipment], [enemy_equipment]], active = true}
	
	player_equipment.character.get_node("DeathOverlay").visible = false
	#player_equipment.stat_changes.clear()
	player_equipment.character.get_node("LifeBar").visible = true
	player_equipment.character.get_node("ChargeBar").visible = true
	player_equipment.can_edit = false
	player_equipment.team = 0
	player_equipment.target_team = 1
	player_equipment.target_enemy = 0
	
	var cooldown = player_equipment.get_stat("cooldown")["final"]
	player_equipment.add_stat("charge", cooldown*0.5)
	
	enemy_equipment.character.get_node("DeathOverlay").visible = false
	enemy_equipment.visible = true
	enemy_equipment.character.visible = true
	enemy_equipment.character.texture = encounter_data["enemies"][0]["character"]
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
				#battler.character.get_node("LifeBar").visible = false
				#battler.character.get_node("ChargeBar").visible = false
			#else:
				#battler.visible = false
				#battler.character.visible = false
	battle_ended.emit()

func win_battle():
	enemy_equipment.character.get_node("DeathOverlay").visible = true
	get_node("BattleEndLabel").visible = true
	get_node("BattleEndLabel").text = "you_win"
	battle["won"] = true
	battle["active"] = false
	battle_ended.emit()

func lose_battle():
	player_equipment.character.get_node("DeathOverlay").visible = true
	get_node("BattleEndLabel").visible = true
	get_node("BattleEndLabel").text = "you_lose"
	battle["won"] = false
	battle["active"] = false
	battle_ended.emit()

func proceed_to_battle():
	var encounter = Registry.zone_data[zone]["encounters"][day % 5].pick_random()
	get_node("CharacterPicker").visible = false
	get_node("ProceedToBattle").visible = false
	day += 1
	get_node("DayCounter").text = tr("day_counter").format({day = day})
	init_battle(encounter)

func proceed_to_rewards():
	if not battle.has("won"):
		return
	if battle["won"]:
		var prize_item = enemy_equipment.equipment.pick_random().duplicate()
		if prize_item.has("stat_changes"):
			prize_item["stat_changes"] = {}
		prize_item["used"] = false
		prize_item["equipped"] = false
		prize_item["position"].x += 10
		player_equipment.equipment.append(prize_item)
	for team in battle["teams"]:
		for battler in team:
			battler.stat_changes.clear()
			for item in battler.equipment:
				if item.has("stat_changes"):
					item["stat_changes"] = {}
				item["used"] = false
			battler.load_grid()
			#if team.has(player_equipment):
			#	battler.character.get_node("LifeBar").visible = false
			#	battler.character.get_node("ChargeBar").visible = false
			if not team.has(player_equipment):
				battler.visible = false
				battler.character.visible = false
	get_node("BattleEndLabel").visible = false
	get_node("ProceedToBattle").visible = true
	battle = {}
	fatigue_start_timer = 0.0
	player_equipment.can_edit = true
	

func _ready() -> void:
	#proceed_to_battle()
	pass

var fatigue_start_timer = 0.0
func _physics_process(_delta: float) -> void:
	if not battle.get("active"):
		return
	fatigue_start_timer += 0.05
	for team in battle["teams"]:
		for battler in team:
			if fatigue_start_timer >= 20:
				var fatigue_damage = int(pow(2, floor(fatigue_start_timer - 20)))
				battler.take_damage({"base" = fatigue_damage, "add_mult" = 1, "mult_mult" = 1, "final" = fatigue_damage, "fatigue" = true})
			var cooldown = battler.get_stat("cooldown")["final"]
			if battler.get_stat("charge")["final"] >= cooldown:
				battler.use_item()
				battler.add_stat("charge", -cooldown)
			battler.add_stat("charge", 0.05)
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
			
