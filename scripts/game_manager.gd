extends Node3D

var delivery_loc_prefab = preload("res://prefabs/delivery_location.tscn")
var car_prefab = preload("res://prefabs/car.tscn")

@export var number_of_deliveries = 10
var delivery_locations = []

@export var max_cars = 100
var spawned_cars = []

func _ready():
	generate_deliveries()
	generate_cars()
	
func _process(delta):
	if delivery_locations.size() <= 0:
		game_over()

func _unhandled_input(event):
	if event.is_action_pressed("map"):
		$MapCam.current = !$MapCam.current

func generate_deliveries():
	var possible_locations = $buildings.get_children()
	for i in number_of_deliveries:
		var inst = delivery_loc_prefab.instantiate()
		var loc = possible_locations.pick_random()
		possible_locations.erase(loc)
		inst.position = loc.get_node("DeliveryLocation").global_position
		delivery_locations.append(inst)
		add_child(inst)

func generate_cars():
	var spawns = []
	for r in $road.get_children():
		if "Road_Straight" in r.name:
			spawns.append(r.get_node("LeftLane"))
			spawns.append(r.get_node("RightLane"))
	
	spawns.shuffle()
	spawns.resize(spawns.size()/2)
			
	for i in max_cars:
		var inst = car_prefab.instantiate()
		var loc = spawns.pick_random()
		spawns.erase(loc)
		inst.position = loc.global_position
		inst.rotation = loc.rotation
		spawned_cars.append(inst)
		add_child(inst)

func deliver(location):
	if delivery_locations.is_empty(): return false
	if !delivery_locations.has(location): return false
	delivery_locations.erase(location)
	location.queue_free()
	return true
	
func game_over():
	print("Congrats")

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(get_tree().get_nodes_in_group("player").has(body)):
		body.health = 0
		body.get_node("SpringArm3D").top_level = true
