extends StaticBody3D

var next_node = null

func _process(delta):
	if next_node != null: return
	if !$RayCast3D.is_colliding(): return
	
	next_node = $RayCast3D.get_collider()
