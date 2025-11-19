extends Node3D


@export var WAIT_DISTANCE = 15
var root_node


func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node


func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
	if global_position.z > 10:
		queue_free() # Remove from scene after passing camera


func _on_collision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		Events.reel_tile_collided.emit()
