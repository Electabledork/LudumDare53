extends Control

func _ready():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for i in Globals.resolutions:
		$MarginContainer/VBoxContainer/Resolution.add_item(i)
	$MarginContainer/VBoxContainer/Resolution.selected = 8
	$MarginContainer/VBoxContainer/Volume.value = Globals.volume
	$MarginContainer/VBoxContainer/FullScreen.button_pressed = Globals.fullscreen
	$MarginContainer/VBoxContainer/Borderless.button_pressed = Globals.borderless

func _on_playbutton_pressed():
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")
	Globals.save_game()

func _on_exitbutton_pressed():
	get_tree().quit()

func _on_volume_value_changed(value):
	Globals.set_volume(value)
	Globals.save_game()

func _on_resolution_item_selected(index):
	Globals.set_resolution(Globals.resolutions[index])
	Globals.save_game()

func _on_borderless_toggled(button_pressed):
	Globals.set_borderless(button_pressed)
	Globals.save_game()

func _on_full_screen_toggled(button_pressed):
	Globals.set_fullscreen(button_pressed)
	Globals.save_game()
	if button_pressed:
		$MarginContainer/VBoxContainer/Borderless.show()
		#$MarginContainer/VBoxContainer/Resolution.show()
	else:
		$MarginContainer/VBoxContainer/Borderless.hide()
		#$MarginContainer/VBoxContainer/Resolution.hide()
