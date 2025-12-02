extends Node3D
var collected = false

@export var interactable_name: String
@export var affected_by_invincibility: bool = true

var heart_sprite: Sprite3D


func init(start_pos: Vector3):
	position = start_pos
	
	# Spawns a visual heart sprite for reel liking
	heart_sprite = Sprite3D.new()
	heart_sprite.position = Vector3(0, 2, 0)
	heart_sprite.scale = Vector3(0.075, 0.075, 0.075)
	heart_sprite.texture = load('res://assets/images/blank_heart.png') # TODO don't hardcode path
	heart_sprite.visible = false
	add_child(heart_sprite)


func _physics_process(_delta: float) -> void:
	global_position += Vector3(0, 0, GameState.run_speed*_delta)
	
	if GameState.like_ready:
		heart_sprite.visible = true
	else:
		heart_sprite.visible = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		if GameState.invincible and affected_by_invincibility:
			return
		collected = true
		$AudioStreamPlayer3D.play()
		visible = false
		set_physics_process(false)
		Events.touched_interactable.emit(interactable_name, self)
		await $AudioStreamPlayer3D.finished
		queue_free()  # Remove coin from scene
