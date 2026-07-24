extends Control

@onready var player_equipment = get_node("PlayerEquipment")
@onready var enemy_equipment = get_node("EnemyEquipment")

var zone = "field"
var day = 0

var battle: Dictionary

func init_battle(encounter):
	var encounter_data = Registry.encounter_data[encounter]
	battle = {teams = [[player_equipment], [enemy_equipment]], active = true}
	
	#player_equipment.stat_changes.clear()
	player_equipment.character.get_node("LifeBar").visible = true
	player_equipment.character.get_node("ChargeBar").visible = true
	player_equipment.can_edit = false
	player_equipment.team = 0
	player_equipment.target_team = 1
	player_equipment.target_enemy = 0
	
	enemy_equipment.visible = true
	enemy_equipment.character.visible = true
	enemy_equipment.character.texture = encounter_data["enemies"][0]["character"]
	enemy_equipment.layout = encounter_data["enemies"][0]["layout"].duplicate()
	enemy_equipment.equipment = encounter_data["enemies"][0]["equipment"].duplicate()
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

func end_battle():
	for team in battle["teams"]:
		for battler in team:
			battler.stat_changes.clear()
			battler.load_grid()
			if team.has(player_equipment):
				battler.character.get_node("LifeBar").visible = false
				battler.character.get_node("ChargeBar").visible = false
			else:
				battler.visible = false
				battler.character.visible = false
	battle = {}
	player_equipment.can_edit = true

func win_battle():
	print("you win")
	end_battle()

func lose_battle():
	print("you lose")
	end_battle()

func proceed():
	var encounter
	if day % 5 == 0:
		encounter = Registry.zone_data[zone]["bosses"].pick_random()
	else:
		encounter = Registry.zone_data[zone]["encounters"][day % 4].pick_random()
	init_battle(encounter)
	day += 1

func _ready() -> void:
	proceed()

func _physics_process(_delta: float) -> void:
	if not battle.get("active"):
		return
	for team in battle["teams"]:
		for battler in team:
			var cooldown = battler.get_stat("cooldown")["final"]
			if battler.get_stat("charge")["final"] >= cooldown:
				battler.use_item()
				battler.add_stat("charge", -cooldown)
			battler.add_stat("charge", 0.05)
	for team in battle["teams"]:
		var team_dead = true
		for battler in team:
			if battler.get_stat("health")["final"] > 0:
				team_dead = false
		if team_dead:
			if team.has(player_equipment):
				lose_battle()
			else:
				win_battle()
