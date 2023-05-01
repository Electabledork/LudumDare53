extends Control

@onready var hpbar = $HPBKG/HPFILL
@onready var player = $"../../.."
@onready var game_manager = $"../../../.."

var speed_max_rot = 253

var game_min = 0
var game_sec = 0

func _ready():
	$delivery_hint.hide()

func _process(delta):
	$game_time.text = format_time()
	
	var hp_perc = player.health / player.max_health
	hpbar.size.x = $HPBKG.size.x * hp_perc
	var num_del = game_manager.delivery_locations.size() if !game_manager.delivery_locations.is_empty() else 0
	$Label.text = "Deliveries: " + str(num_del)
	
	if(player.can_deliver):
		$delivery_hint.show()
	else:
		$delivery_hint.hide()
		
	$speedometer/needle.rotation_degrees = player.speed / 40 * speed_max_rot

func format_time():
	var min = (int)(game_manager.game_time)/60
	var sec = floor(game_manager.game_time) - (min * 60)
	
	var strmin = "0" + str(min) if min < 10 else str(min)
	var strsec = "0" + str(sec) if sec < 10 else str(sec)

	return str(strmin) + ":" + str(strsec)
