extends VehicleBody3D

@export_category("Driving")
@export var horse_power = 200.0
@export var brake_force = 5.0
@export var handbrake_multiplier = 6.0
@export var steer_speed = 5.0
@export var decel_rate = 0.5

var steer_target = 0.0
var steer_angle = 0.0
var steer_val = 0
var throttle_val = 0
var brake_val = 0
var reverse = false

var speed = 0

@onready var game_manager = $".."
@onready var engine_sound = $EngineSound

@export_category("Health")
@export var crash_damage_modifier = 6;
@export var max_health = 100
var health = max_health
var can_take_damage = true
var is_alive = true

var delivery_location = null
var can_deliver = false

var engine_pitch = 0.3

func _ready():
	$EngineSound.volume_db = Globals.volume

func _process(delta):
	if !is_alive: return

	if health <= 75 && health > 50:
		$EngineSmoke.emitting = true
		$EngineSmoke.amount = 20
	elif health <= 50 && health > 25:
		$EngineSmoke.amount = 50
	elif health <= 25 && health > 0:
		$EngineSmoke.amount = 100
	elif health <= 0:
		die()

func _unhandled_input(event):
	if !is_alive: return
	
	if event.is_action_pressed("interact"):
		if can_deliver && speed <= 1.0:
			var delivered = game_manager.deliver(delivery_location)
			if delivered:
				clear_delivery()
		
	if event.is_action_pressed("map"):
		pass

func _physics_process(delta):
	if !is_alive: return
	$CSGMesh3D.global_position = Vector3(global_position.x, 900, global_position.z)
	update_sound(delta)
	speed = linear_velocity.length()
	
	if Input.is_action_pressed("accelerator"):
		throttle_val = 1
		reverse = false
		if speed <= 1 && throttle_val >= 0.9:
			show_smoke()
	else:
		if(!reverse):
			throttle_val = move_toward(throttle_val, 0, decel_rate * delta)
		if $TireSmokeLeft.emitting || $TireSmokeRight.emitting:
			stop_smoke()
		
	if Input.is_action_pressed("brake"):
		if engine_force > 0:
			brake_val = 1
			throttle_val = move_toward(throttle_val, 0, delta * 3)
		else:
			reverse = true
			throttle_val = -0.5
	else:
		brake_val = 0.0
		reverse = false
	
	if Input.is_action_pressed("handbrake"):
		$BackRight.wheel_friction_slip = 0.6
		$BackLeft.wheel_friction_slip = 0.6
		brake_val = brake_force * handbrake_multiplier   
		throttle_val = 0
	else:
		$BackRight.wheel_friction_slip = 2
		$BackLeft.wheel_friction_slip = 2
	
	if Input.is_action_pressed("turn_left"):
		steer_val = 1.0
	elif Input.is_action_pressed("turn_right"):
		steer_val = -1.0
	else:
		steer_val = 0
	
	engine_force = throttle_val * horse_power
	brake = brake_val * brake_force
	steer_target = steer_val * 0.3
	steering = move_toward(steering, steer_target, steer_speed * delta)

func update_sound(delta):
	engine_pitch = speed / 20 * 0.5 + 0.4
	engine_pitch = clampf(engine_pitch, 0.4, 1)
	engine_sound.pitch_scale = engine_pitch

func show_smoke():
	$TireSmokeLeft.emitting = true
	$TireSmokeRight.emitting = true

func stop_smoke():
	$TireSmokeLeft.emitting = false
	$TireSmokeRight.emitting = false
	
func set_delivery(location):
	delivery_location = location
	can_deliver = true

func clear_delivery():
	delivery_location = null
	can_deliver = false
	
func die():
	is_alive = false
	throttle_val = 0
	brake_val = 1
	steer_target = 0
	engine_force = 0
	speed = 0
	clear_delivery()
	stop_smoke() 
	$EngineSmoke.emitting = false

func _on_body_entered(body):
	if get_tree().get_nodes_in_group("no_damage").has(body): return
	if linear_velocity.length() < 2: return
	if !can_take_damage: return
	health -= linear_velocity.length() * crash_damage_modifier
	can_take_damage = false
	$DamageTimer.start()

func _on_damage_timer_timeout():
	can_take_damage = true
