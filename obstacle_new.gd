extends AnimatableBody3D


@export var speed = -10
var start = Vector3.ZERO
func initialize(start_pos: Vector3):
	global_position = start_pos
	start = start_pos
	print('start obstacle', start_pos)
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, speed*_delta)
	


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
