@tool
extends ProgressBar

@export var max_health: float = 3000
@export var health: float = 3000:
	set(value):
		health = clamp(value, 0, max_health)
		self.value = health
		_update_color()
	get:
		return health

@onready var fill_style: StyleBoxFlat = get_theme_stylebox("fill").duplicate()


func _ready() -> void:
	Events.game_over.connect(func():
		queue_free() # Remove UI on game over
	)
	
	max_value = max_health
	value = health
	add_theme_stylebox_override("fill", fill_style)
	_update_color()


func _update_color() -> void:
	var t := health / max_health  # 1.0 = green, 0.0 = red

	var red   = lerp(1.0, 0.0, t)
	var green = lerp(0.0, 1.0, t)

	fill_style.bg_color = Color(red, green, 0.0)
