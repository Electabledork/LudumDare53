extends VehicleBody3D

@export var horse_power = 200.0
@export var brake_force = 5.0
@export var steer_speed = 5.0
@export var decel_rate = 0.25

var steer_target = 0.0
var steer_angle = 0.0
var steer_val = 0
var throttle_val = 0
var brake_val = 0
var reverse = false

var speed = 0

var health = 100

func _physics_process(delta):
	speed = linear_velocity.length()
	
	if Input.is_action_pressed("accelerator"):
		throttle_val = 1
		reverse = false
		if speed <= 1 && throttle_val >= 0.9:
			show_smoke()
	else:
		if(!reverse):
			throttle_val = move_toward(throttle_val, 0, delta * decel_rate)
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

	print(brake_val)

func show_smoke():
	$TireSmokeLeft.emitting = true
	$TireSmokeRight.emitting = true

func stop_smoke():
	$TireSmokeLeft.emitting = false
	$TireSmokeRight.emitting = false


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("COLLISION: " + str(linear_velocity.length()))


func _on_body_entered(body):
	print("COLLISION: " + str(linear_velocity.length()))
