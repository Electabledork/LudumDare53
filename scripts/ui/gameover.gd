extends Control


func _ready():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$MarginContainer/VBoxContainer/ScoreLabel.text = Globals.format_time(Globals.last_score)
	if Globals.last_score > Globals.high_score:
		$MarginContainer/VBoxContainer/HighscoreLabel.show()
	Globals.save_game()

func _on_exitbutton_pressed():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")


func _on_resumebutton_pressed():
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")
