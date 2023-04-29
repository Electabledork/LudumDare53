extends VehicleBody3D

@export_category("Driving")
@export var horse_power = 200.0
@export var brake_force = 5.0
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

@export_category("Health")
@export var crash_damage_modifier = 6;
@export var max_health = 100
var health = max_health
var can_take_damage = true

var delivery_location = null
var can_deliver = false

func _process(delta):
	if health <= 75:
		$EngineSmoke.emitting = true
		$EngineSmoke.amount = 20
	elif health <= 50:
		$EngineSmoke.amount = 50
	elif health <= 25:
		$EngineSmoke.amount = 100
	elif health <= 0:
		print("Truck Dead")
	else:
		$EngineSmoke.emitting = false
		
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if can_deliver && speed <= 1.0:
			var delivered = game_manager.deliver(delivery_location)
			if delivered:
				clear_delivery()
		
	if event.is_action_pressed("map"):
		pass

func _physics_process(delta):
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
		else:
			reverse = true
			throttle_val =  move_toward(throttle_val, -0.25, delta)
	else:
		brake_val = 0.0
		reverse = false
	
	if Input.is_action_pressed("handbrake"):
		$BackRight.wheel_friction_slip = 0.3
		$BackLeft.wheel_friction_slip = 0.3
		brake_val = 5
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

func _on_body_entered(body):
	if(get_tree().get_nodes_in_group("no_damage").has(body)): return
	health -= linear_velocity.length() * crash_damage_modifier
	can_take_damage = false
	$DamageTimer.start()

func _on_damage_timer_timeout():
	can_take_damage = true
