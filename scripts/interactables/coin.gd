extends Node3D
var root_node: Node3D
var collected = false

func _ready():
	pass
	
func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node
	
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
			
func _on_body_entered(body):
	# Check if the player is the one touching
	if body.is_in_group("player") and not collected:
		collected = true
		$AudioStreamPlayer3D.play()
		$Coin.visible = false
		set_physics_process(false)
		await $AudioStreamPlayer3D.finished
		queue_free()  # Remove coin from scene
    Events.coin_collected.emit()  # Signals to everyone that a coin has been collected
