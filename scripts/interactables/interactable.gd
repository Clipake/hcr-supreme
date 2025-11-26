extends Node3D
var root_node: Node3D
var collected = false

@export var interactable_name: String	


func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node


func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		if GameState.invincible:
			return
		collected = true
		$AudioStreamPlayer3D.play()
		visible = false
		GameState.stunned = true
		set_physics_process(false)
		Events.touched_interactable.emit(interactable_name)
		print('Emitted: touched_interactable(' + interactable_name + ')')
		await $AudioStreamPlayer3D.finished
		queue_free()  # Remove coin from scene
