@tool
extends ProgressBar

@onready var progress_stylebox: StyleBoxFlat = self.get_theme_stylebox('fill')

func _ready() -> void:
	# Connecting to signal bus
	if Engine.is_editor_hint(): return
	Events.set_player_health.connect(set_health)


func set_health(value: float) -> void:
	"""
	Calculates health bar color from current value
	:param value: The new health value
	"""
	self.value = value
	var green = min(255, (255/50)*(value)) # i used desmos to find the right line
	var red = min(255, (-255/50)*(value)+510) # same here
	
	progress_stylebox.bg_color = Color.from_rgba8(red,green,0,255)
