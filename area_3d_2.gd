extends Node3D

func _ready():
	pass
func _on_body_entered(body):
	# Check if the player is the one touching
	print("hi")
	if body.is_in_group("player"):
		print("Coin collected!")
		queue_free()  # Remove coin from scene
