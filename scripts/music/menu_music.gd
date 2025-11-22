extends AudioStreamPlayer

func _ready() -> void:
	Events.game_over.connect(func():
		play()
	)
