extends Node3D

func init(start_pos: Vector3, color: Color) -> void:
	global_position = start_pos
	
	# set reel tile color
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = color
	$Cube_055.set_surface_override_material(0, mat)

func _physics_process(delta: float) -> void:
	global_position += Vector3(0, 0, GameState.run_speed * delta)

	if global_position.z > 10:
		queue_free() # out of camera view

func _on_collision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Events.reel_tile_collided.emit()
