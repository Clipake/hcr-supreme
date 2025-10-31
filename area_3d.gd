extends Area3D  # if attached to the Area3D node

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Entered:", body.name)
	if body.is_in_group("player"):
		print(5)
	else:
		body.queue_free()
		print("Coin collected")
