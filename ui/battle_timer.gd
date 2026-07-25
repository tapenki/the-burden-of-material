extends Label

var running = false

var time = 0.0
func _process(delta: float) -> void:
	if not running:
		return
	time += delta
	var miliseconds = int(time*60) % 60
	var miliseconds_string = str(miliseconds)
	if miliseconds < 10:
		miliseconds_string = "0" + miliseconds_string
	var seconds = int(time) % 60
	var seconds_string = str(seconds)
	if seconds < 10:
		seconds_string = "0" + seconds_string
	var minutes = int(time/60)
	var minutes_string = str(minutes)
	if minutes < 10:
		minutes_string = "0" + minutes_string
	text = minutes_string + ":" + seconds_string + ":" + miliseconds_string

func _on_game_battle_initiated() -> void:
	visible = true
	running = true

func _on_game_battle_ended() -> void:
	visible = false
	time = 0.0
	running = false
