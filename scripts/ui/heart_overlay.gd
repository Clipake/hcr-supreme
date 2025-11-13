extends Control

@export var max_move_y: float = 5 ## Maximum upwards heart movement (unknown units)
@export var max_move_x: float = 5 ## Maximum sideways heart movement (unknown units)

var go_right: bool = randf() > 0.5 # Some hearts go left, others right
var move_x: float = randf_range(0, max_move_x) if go_right else randf_range(0, -max_move_x)

# Does heart animation on instantiation
func _process(delta: float) -> void:
	var time_factor: float = delta*100 # adjust for framerate
	if modulate.a <= 0:
		queue_free()
	position.y -= max_move_y*time_factor
	position.x += move_x*time_factor
	scale = calc_scale(modulate.a*time_factor)
	modulate = Color(modulate.r, modulate.g, modulate.b, modulate.a-(0.01*time_factor)) # -1% opacity


# Calculates the scale based on current alpha
func calc_scale(alpha: float):
	if alpha >= 0.85:
		return scale+Vector2(0.05, 0.05)
	else:
		return scale-Vector2(0.015, 0.015)
		
