extends Control

var scripts_to_load = [
	"res://equipment/register_equipment_base.gd",
	"res://characters/register_characters_base.gd",
	"res://encounters/register_encounters_base.gd",
]

func _ready() -> void:
	load_scripts()

func load_scripts():
	for script_path in scripts_to_load:
		var script = load(script_path)
		var node = Node.new()
		node.set_script(script)
		node.register()
		await get_tree().process_frame
	get_tree().change_scene_to_file("res://game.tscn")
