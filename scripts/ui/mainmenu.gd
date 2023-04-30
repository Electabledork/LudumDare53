extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_playbutton_pressed():
	pass

func _on_exitbutton_pressed():
	get_tree().quit()


func _on_volume_value_changed(value):
	Globals.volume = value
