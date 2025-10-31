extends AnimatableBody3D


@export var WAIT_DISTANCE = 15
var root_node
var start = Vector3.ZERO

func initialize(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	print(position)
	start = start_pos
	root_node = passed_node
	get_node("FlipUpTimer").wait_time = randf_range(WAIT_DISTANCE/(-passed_node.speed)*0.3, WAIT_DISTANCE/(-passed_node.speed)*0.7)
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_flip_up_timer_timeout() -> void:
	get_node("AnimationPlayer").play("obstacle_flip_up")
	pass # Replace with function body.
