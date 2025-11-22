extends Node3D
var collected = false
signal collected_signal(effect_type: String)
@export var effect_type: String = "67"


var root_node: Node3D
func _ready():
	pass
	
func init(start_pos: Vector3, passed_node: Node3D):
	position = start_pos
	root_node = passed_node
func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, root_node.speed*_delta)
			

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		var player = body as CharacterBody3D
		if player.is_invincible:
			return
		collected = true
		$AudioStreamPlayer3D.play()
		visible = false
		set_physics_process(false)
		emit_signal("collected_signal", effect_type)  
		await $AudioStreamPlayer3D.finished
		queue_free() 
		
