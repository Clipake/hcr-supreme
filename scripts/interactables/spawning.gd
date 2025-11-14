extends Node3D


@onready var spawn_timer = $SpawnTimer
@export var speed = 10
@export var DISTANCE = 10

var spawn_locations
var interactables = []

var spawn_amount_chances = {
	1: 1/3.0,
	2: 1/4.0,
	3: 1/10.0,
	0: 1/20.0
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at("res://scenes/interactables"):
		if (file.get_extension() == 'import'):
			file = file.replace('.import', '')
		interactables.append(load('res://scenes/interactables/'+file))
	print(interactables)
	print('run')
	
	spawn_locations = get_node("SpawnLocations").get_children()
	
	Events.start_game.connect(func():
		spawn_timer.start())
		
	Events.start_game.emit()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var tick_counter = 0
func _physics_process(delta: float) -> void:
	tick_counter += delta
	speed += tick_counter/1000*0.1
	spawn_timer.wait_time = float(DISTANCE)/(speed)
	
func _on_timer_timeout() -> void:	
	
	var rng = randf()
	var num_obstacles = 0
	for val in spawn_amount_chances:
		if rng >= spawn_amount_chances[val]:
			num_obstacles = val
			break
	var available = [0, 1, 2]
	
	for i in range(num_obstacles):
		var interactable_index = randi_range(0, len(interactables)-1)
		var interactable_scene = interactables[interactable_index]
		var interactable = interactable_scene.instantiate()

		var location_index = randi_range(0, len(available)-1)
		interactable.init(spawn_locations[available[location_index]].global_position, self)

		available.remove_at(location_index)
		add_child(interactable)
		
	pass # Replace with function body.

		
