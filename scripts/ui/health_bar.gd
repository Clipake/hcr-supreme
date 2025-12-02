@tool
extends ProgressBar

@onready var fill_style: StyleBoxFlat = get_theme_stylebox("fill").duplicate()

func _ready() -> void:
	Events.game_over.connect(func():
		queue_free() # Remove UI on game over
	)
	Events.set_player_health.connect(set_player_health)
	add_theme_stylebox_override("fill", fill_style)

func set_player_health(health: int):
	value = health
	_update_color()

func _update_color() -> void:
	"""
	Calculates health bar color from current value
	"""
	var percent_value = (value/max_value)*100
	var green = min(255, (255/50)*(percent_value)) # i used desmos to find the right line
	var red = min(255, (-255/50)*(percent_value)+510) # same here
	
	fill_style.bg_color = Color.from_rgba8(red,green,0,255)
