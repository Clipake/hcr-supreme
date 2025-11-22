@tool
extends ProgressBar

@export var max_health: float = 3000
var _health: float = 3000

@onready var fill_style: StyleBoxFlat = null

@export var health: float:
	set(value):
		_health = clamp(value, 0, max_health)
		self.value = _health
		
		# Only call update after ready
		if fill_style != null:
			_update_color()
	get:
		return _health


func _ready() -> void:
	max_value = max_health
	value = _health

	# Duplicate AFTER ready (avoids editor errors)
	fill_style = get_theme_stylebox("fill").duplicate()
	add_theme_stylebox_override("fill", fill_style)

	_update_color()


func _update_color() -> void:
	if fill_style == null:
		return   # Safety

	var t := _health / max_health
	var red   = lerp(1.0, 0.0, t)
	var green = lerp(0.0, 1.0, t)

	fill_style.bg_color = Color(red, green, 0.0)
