extends Camera3D

var smooth_at_diff = .5
var rotation_speed = 25
@onready var car = $"../.."
@onready var arm = $".."

func _physics_process(delta):
	if car.is_alive:
		look_at_from_position(global_position, arm.global_position, Vector3.UP)
