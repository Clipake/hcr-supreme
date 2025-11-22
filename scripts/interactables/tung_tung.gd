extends Node3D
signal collected_signal(effect_type: String)
var collected = false
@export var effect_type: String = "tungtung"

var root_node: Node3D
func _ready():
	pass
	
func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node
	
	get_node("AnimationPlayer").play('SideStep')
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
			
func _on_body_entered(body):
	# Check if the player is the one touching
	if body.is_in_group("player") and not collected:
		collected = true
		set_physics_process(false)
		queue_free() 


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		var player = body as CharacterBody3D
		if player.is_invincible:
			return
		collected = true
		collected = true
		set_physics_process(false)
		emit_signal("collected_signal", effect_type)  
		queue_free()  # Remove coin from scene
