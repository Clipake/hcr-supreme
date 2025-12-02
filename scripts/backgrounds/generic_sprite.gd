extends Sprite3D

@export var min_speed: float = 0.5
@export var max_speed: float = 1.5

@export var min_volatility: float = 0.5
@export var max_volatility: float = 1.5

var speed: float
var volatility: float
var base_pos: Vector3
var base_rot: Vector3
# var base_scale: Vector3   # scaling disabled for now

var t := 0.0   # internal time accumulator


func _ready() -> void:
	# Cache original values
	base_pos = global_position
	base_rot = global_rotation
	# base_scale = scale

	# Randomize behavior for each instance
	speed = randf_range(min_speed, max_speed)
	volatility = randf_range(min_volatility, max_volatility)


func _physics_process(delta: float) -> void:
	t += delta

	# --- Smooth up/down bobbing on Y using sine ---
	var y_offset = sin(t * speed) * volatility
	global_position.y = base_pos.y + y_offset

	# --- Smooth rotation on Z-axis ---
	var rot_offset = sin(t * speed) * (volatility * 0.15)  # scaled multiplier feels better
	global_rotation.z = base_rot.z + rot_offset

	# --- Scaling (disabled for now) ---
	# var scale_offset = sin(t * speed) * (volatility * 0.1)
	# scale = base_scale + Vector3.ONE * scale_offset
