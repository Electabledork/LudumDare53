extends CharacterBody3D

@export var movement_speed: float = 5.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

var is_alive = true

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	randomize()
	var color = Color.from_string(Globals.colors.pick_random(), Color.WEB_GRAY)
	mat.albedo_color = color
	mat.metallic_specular = 0
	mat.metallic = 0
	$base.set_surface_override_material(1, mat)
	
	$EngineSound.volume_db = Globals.volume
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	navigation_agent.target_position = $"../DeliveryTruck".position

func _physics_process(delta):
	var dist_to_player = position.distance_to($"../DeliveryTruck".position)
	#print(dist_to_player)
	#if dist_to_player > 100:
		#queue_free()
	
	if !is_alive: return
	if navigation_agent.is_navigation_finished():return
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if !collision.get_collider().is_in_group("no_damage"):
			die()

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	rotation.y = move_toward(rotation.y, atan2(velocity.x,velocity.z), delta * 1)

func _on_velocity_computed(safe_velocity: Vector3):
	if !is_alive: return
	velocity = safe_velocity
	move_and_slide()
	
func die():
	is_alive = false
	velocity = Vector3.ZERO
	navigation_agent.set_velocity(velocity)
	navigation_agent.target_position = position
	$EngineSmoke.emitting = true
