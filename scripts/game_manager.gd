extends Node3D

var delivery_loc_prefab = preload("res://prefabs/delivery_location.tscn")

@export var number_of_deliveries = 20
var delivery_locations = []

func _ready():
	generate_deliveries()
	
func _unhandled_input(event):
	if event.is_action_pressed("map"):
		$MapCam.current = !$MapCam.current

func generate_deliveries():
	var possible_locations = $buildings.get_children()
	#number_of_deliveries = possible_locations.size()
	for i in number_of_deliveries:
		var inst = delivery_loc_prefab.instantiate()
		var loc = possible_locations.pick_random()
		possible_locations.erase(loc)
		inst.position = loc.get_node("DeliveryLocation").global_position
		delivery_locations.append(inst)
		add_child(inst)

func deliver(location):
	if delivery_locations.is_empty(): return false
	if !delivery_locations.has(location): return false
	delivery_locations.erase(location)
	location.queue_free()
	return true

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(get_tree().get_nodes_in_group("player").has(body)):
		body.health = 0
		body.get_node("SpringArm3D").top_level = true
