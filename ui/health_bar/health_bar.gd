extends ProgressBar

var progress_stylebox: StyleBoxFlat = StyleBoxFlat.new()

func _ready() -> void:
	progress_stylebox.set_corner_radius_all(6)
	add_theme_stylebox_override("fill", progress_stylebox)
	set_health(value) # Updates initial colors

func set_health(health: int) -> void:
	self.value = health
	var green = min(255, (255/50)*(health)) # i used desmos to find the right line
	var red = min(255, (-255/50)*(health)+510) # same here
	
	progress_stylebox.bg_color = Color.from_rgba8(red,green,0,255)
