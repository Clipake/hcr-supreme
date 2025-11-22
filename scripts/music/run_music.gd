extends AudioStreamPlayer

func _ready() -> void:
	Events.game_over.connect(func():
		queue_free() # Stop all run music on game over
	)
