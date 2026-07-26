extends Label

var time = 0.0

func _on_game_battle_initiated() -> void:
	#visible = true
	time = 0.0

func _on_game_tick(tick) -> void:
	time += tick
	var miliseconds = int(time*100) % 100
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
