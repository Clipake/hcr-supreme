extends Node3D

@export var obstacle_scene: PackedScene

var locations
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	locations = get_node("SpawnLocations").get_children()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timer_timeout() -> void:	
	var num_obstacles = randi_range(0, 3)
	for i in range(num_obstacles):
		var obstacle = obstacle_scene.instantiate()
		var location_index = randi_range(0, 2)
		
		obstacle.initialize(locations[location_index].position)
		
		add_child(obstacle)
		
	pass # Replace with function body.
