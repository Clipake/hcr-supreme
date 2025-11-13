extends Control

@export var max_move_y: int = 5 ## Maximum amount a heart can move upwards in pixels every 0.01s
@export var max_move_x: int = 5 ## Maximum amount a heart can move sideways in pixels every 0.01s

# Does heart animation on instantiation
func _ready() -> void:	
	var go_right: bool = randf() > 0.5
	var move_x: float = randf_range(0, max_move_x) if go_right else randf_range(0, -max_move_x)
	
	while modulate.a >= 0:
		position.y -= max_move_y
		position.x += move_x
		scale = calc_scale(modulate.a)
		modulate = Color(modulate.r, modulate.g, modulate.b, modulate.a-0.01) # -1% opacity
		$"DisappearTimer".start()
		await $"DisappearTimer".timeout


# Calculates the scale based on current alpha
func calc_scale(alpha: float):
	if alpha >= 0.85:
		return scale+Vector2(0.05, 0.05)
	else:
		return scale-Vector2(0.015, 0.015)
		
