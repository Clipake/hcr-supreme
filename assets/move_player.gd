extends CharacterBody3D

@export var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello world!")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vectors = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(vectors.x, 0, vectors.y)
	velocity *= speed
	move_and_slide()
	pass
