extends Control

@onready var hpbar = $HPBKG/HPFILL
@onready var player = $"../../.."
@onready var game_manager = $"../../../.."

var speed_max_rot = 253

var game_min = 0
var game_sec = 0

func _ready():
	$delivery_hint.hide()
	$PauseMenu.hide()
	$PauseMenu/MarginContainer/VBoxContainer/Volume.value = Globals.volume
	$PauseMenu/MarginContainer/VBoxContainer/FullScreen.button_pressed = Globals.fullscreen
	$PauseMenu/MarginContainer/VBoxContainer/Borderless.button_pressed = Globals.borderless

func _process(delta):
	if get_tree().paused: return
	$game_time.text = Globals.format_time(game_manager.game_time)
	
	var hp_perc = player.health / player.max_health
	hpbar.size.x = 248 * hp_perc
	var num_del = game_manager.delivery_locations.size() if !game_manager.delivery_locations.is_empty() else 0
	$Deliveries/DeliveriesLabel.text = str(num_del)
	
	if player.can_deliver:
		$delivery_hint.show()
	else:
		$delivery_hint.hide()
		
	if !player.is_alive:
		$respawn_hint.show()
	else:
		$respawn_hint.hide()
		
	$speedometer/needle.rotation_degrees = player.speed / 40 * speed_max_rot
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		pause()
	
func pause():
	get_tree().paused = !get_tree().paused
	$PauseMenu.visible = get_tree().paused
	
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resumebutton_pressed():
	pause()

func _on_exitbutton_pressed():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
	
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



