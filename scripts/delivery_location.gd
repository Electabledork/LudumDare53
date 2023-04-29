extends Area3D

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(get_tree().get_nodes_in_group("player").has(body)):
		body.set_delivery(self)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if(get_tree().get_nodes_in_group("player").has(body)):
		body.clear_delivery()
