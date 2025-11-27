extends Control

@export var stunned: Color = Color(0.7, 0.2, 0.2)
@export var invincible: Color = Color(0.0, 0.7, 0.0)
@export var both: Color = Color(0.5, 0.5, 0.5)

@onready var stylebox: StyleBoxFlat = $Outline.get_theme_stylebox('panel')


func _ready() -> void:
	$Outline.add_theme_stylebox_override('panel', stylebox)
	

func _process(delta: float) -> void:
	if GameState.stunned and GameState.invincible:
		stylebox.border_color = both
		stylebox.bg_color = both # Godot blends colors, so bg/border must be equal
	elif GameState.stunned:
		stylebox.border_color = stunned
		stylebox.bg_color = stunned
	elif GameState.invincible:
		stylebox.border_color = invincible
		stylebox.bg_color = invincible
	else:
		stylebox.border_color.a -= 1*delta
	
	stylebox.border_color.a = clamp(stylebox.border_color.a, 0, 255)
