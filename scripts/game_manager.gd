extends Node3D

var player_prefab = preload("res://prefabs/delivery_truck.tscn")
var delivery_loc_prefab = preload("res://prefabs/delivery_location.tscn")
var car_prefab = preload("res://prefabs/car.tscn")

var player

@export var number_of_deliveries = 10
var delivery_locations = []

@export var max_cars = 100
var spawned_cars = []

var game_time = 0

func _ready():
	print(Globals.volume)
	spawn_player()
	generate_deliveries()
	generate_cars()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta):
	if delivery_locations.size() > 0:
		game_time += delta
	else:
		game_over()

func _unhandled_input(event):
	if event.is_action_pressed("map"):
		$MapCam.current = !$MapCam.current
		
	if event.is_action_pressed("reset"):
		if !player.is_alive:
			spawn_player()
		
func spawn_player():
	if player != null: player.queue_free()
	var inst = player_prefab.instantiate()
	inst.position = $Spawn.global_position
	add_child(inst)
	player = inst

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
		inst.position.y = 0
		inst.rotation = loc.rotation + loc.get_parent().rotation
		inst.current_node = loc
		spawned_cars.append(inst)
		add_child(inst)

func deliver(location):
	if delivery_locations.is_empty(): return false
	if !delivery_locations.has(location): return false
	delivery_locations.erase(location)
	location.queue_free()
	return true
	
func game_over():
	Globals.set_score(game_time)
	Globals.save_game()
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(get_tree().get_nodes_in_group("player").has(body)):
		body.health = 0
		body.get_node("SpringArm3D").top_level = true
