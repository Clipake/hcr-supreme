extends CharacterBody3D


@export var speed = 10

func initialize(start_pos: Vector3):
	position = start_pos
	velocity = Vector3(0, 0, speed)
func _physics_process(_delta: float) -> void:
	velocity = Vector3(0, 0, speed)
	move_and_slide()
	
	


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
