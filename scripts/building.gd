extends StaticBody3D

func _ready():
	var mat = StandardMaterial3D.new()
	randomize()
	var color = Color.from_string(Globals.colors.pick_random(), Color.WEB_GRAY)
	mat.albedo_color = color
	mat.metallic_specular = 0
	mat.metallic = 0
	$Cube.set_surface_override_material(1, mat)


func _on_tree_exiting():
	$Cube.set_surface_override_material(1, null)
