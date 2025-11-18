extends Control

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game() -> void:
	Events.start_game.emit()
func _on_open_shop() -> void:
	Events.open_shop.emit()
