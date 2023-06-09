extends CharacterBody3D

@export var movement_speed: float = 10.0

var is_alive = true
var current_node = null

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	randomize()
	var color = Color.from_string(Globals.colors.pick_random(), Color.WEB_GRAY)
	mat.albedo_color = color
	mat.metallic_specular = 0
	mat.metallic = 0
	$base.set_surface_override_material(1, mat)

func _physics_process(delta):
	if !is_alive: 
		if position.distance_to($"../DeliveryTruck".global_position) > 100:
			$base.set_surface_override_material(1, null)
			queue_free()
		return
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if !collision.get_collider().is_in_group("no_damage"):
			die()
	
	if current_node != null && current_node.next_node != null:
		if $RayCast3D.is_colliding() || $RayCast3D2.is_colliding() || $RayCast3D3.is_colliding(): return
		var next_node = current_node.next_node
		if position.distance_to(next_node.global_position) < 1:
			current_node = next_node
		var new_vel = (next_node.global_position - position).normalized() * movement_speed
		velocity = new_vel
		move_and_slide()
		rotation.y = atan2(velocity.x, velocity.z)

func die():
	is_alive = false
	velocity = Vector3.ZERO
	$EngineSmoke.emitting = true
	$EngineSound.stop()


func _on_tree_exiting():
	$base.set_surface_override_material(1, null)
