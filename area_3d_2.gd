extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the player is the one touching
	print("hi")
	if body.name == CharacterBody3D:
		print("Coin collected!")
		queue_free()  # Remove coin from scene
