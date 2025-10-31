extends Node3D

@export var obstacle_scene: PackedScene
@export var speed = 10
@onready var timer = $Timer
@export var DISTANCE = 10

var locations
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	locations = get_node("SpawnLocations").get_children()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var tick_counter = 0
func _physics_process(delta: float) -> void:
	tick_counter += delta
	speed += tick_counter/1000*0.1
	timer.wait_time = float(DISTANCE)/(-speed)
	
var chances = {
	1: 1/3.0,
	2: 1/4.0,
	3: 1/7.0,
	0: 1/10.0
}


func _on_timer_timeout() -> void:	
	
	var rng = randf()
	var num_obstacles = 0
	for val in chances:
		if rng >= chances[val]:
			num_obstacles = val
			break
	var available = [0, 1, 2]
	
	for i in range(num_obstacles):
		var obstacle = obstacle_scene.instantiate()
		var location_index = randi_range(0, len(available)-1)
		obstacle.initialize(locations[available[location_index]].global_position, self)
		available.remove_at(location_index)
		add_child(obstacle)
		
	pass # Replace with function body.
