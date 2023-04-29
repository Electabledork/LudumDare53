extends Node3D

var delivery_loc_prefab = preload("res://prefabs/delivery_location.tscn")

@export var number_of_deliveries = 1
var delivery_locations = []

func _ready():
	generate_deliveries()

func generate_deliveries():
	var possible_locations = $buildings.get_children()
	for i in number_of_deliveries:
		var inst = delivery_loc_prefab.instantiate()
		inst.position = Vector3(randf_range(-100, 100), 0, randf_range(-100, 100))
		delivery_locations.append(inst)
		add_child(inst)

func deliver(location):
	if delivery_locations.is_empty(): return false
	if !delivery_locations.has(location): return false
	delivery_locations.erase(location)
	location.queue_free()
	return true
