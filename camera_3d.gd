extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_node("../"))

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_node("../coin").position + Vector3(0, 0, -5)
	pass
