extends Node3D


var root_node: Node3D
func _ready():
	pass
	
func initialize(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	print(position)
	root_node = passed_node
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
			
func _on_body_entered(body):
	# Check if the player is the one touching
	print("hi")
	if body.is_in_group("player"):
		print("Coin collected!")
		queue_free()  # Remove coin from scene
