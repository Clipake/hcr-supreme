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
	var num_obstacles = randi_range(1, 3)
	var available = [0, 1, 2]
	for i in range(num_obstacles):
		var obstacle = obstacle_scene.instantiate()
		var location_index = randi_range(0, len(available)-1)
		available.remove_at(location_index)
		obstacle.initialize(locations[location_index].global_position)
		add_child(obstacle)
		
	pass # Replace with function body.
