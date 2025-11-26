extends Node3D
var collected = false

@export var interactable_name: String	


func init(start_pos: Vector3):
	position = start_pos


func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, GameState.run_speed*_delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		if GameState.invincible:
			return
		collected = true
		$AudioStreamPlayer3D.play()
		visible = false
		set_physics_process(false)
		Events.touched_interactable.emit(interactable_name)
		await $AudioStreamPlayer3D.finished
		queue_free()  # Remove coin from scene
