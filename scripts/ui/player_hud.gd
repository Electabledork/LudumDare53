extends Control

@onready var hpbar = $HPBKG/HPFILL
@onready var player = $"../../.."
@onready var game_manager = $"../../../.."

var speed_max_rot = 253

func _ready():
	$delivery_hint.hide()

func _process(delta):
	var hp_perc = player.health / player.max_health
	hpbar.size.x = 415 * hp_perc
	var num_del = game_manager.delivery_locations.size() if !game_manager.delivery_locations.is_empty() else 0
	$Label.text = "Deliveries: " + str(num_del)
	
	if(player.can_deliver):
		$delivery_hint.show()
	else:
		$delivery_hint.hide()
		
	$speedometer/needle.rotation_degrees = player.speed / 40 * speed_max_rot
