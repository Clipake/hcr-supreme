extends Node3D
var root_node: Node3D
var collected = false

signal collected_signal(effect_type: String)

@export var effect_type: String = "scooter"

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
		set_physics_process(false)
		queue_free()  # Remove coin from scene


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		var player = body as CharacterBody3D
		player.start_invincibility(5)
		collected = true
		set_physics_process(false)
		emit_signal("collected_signal", effect_type) 
		queue_free()  # Remove coin from scene
