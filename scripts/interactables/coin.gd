extends Node3D
var root_node: Node3D
var collected = false

signal collected_signal(effect_type: String)

@export var effect_type: String = "coin"

func _ready():
	pass
	
func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node
	
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
			
func _on_body_entered(body):
	# Check if the player is the one touching
	print('touched')
	if body.is_in_group("player") and not collected:
		collected = true
		$AudioStreamPlayer3D.play()
		$Coin.visible = false
		set_physics_process(false)
		emit_signal("collected_signal", effect_type)
		Events.touched_interactable.emit('coin')  # Signals to everyone that a coin has been collected 
		await $AudioStreamPlayer3D.finished # Wait for sound to finish before destroying object
		queue_free()  # Remove coin from scene
