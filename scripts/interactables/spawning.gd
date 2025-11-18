extends Node3D


@onready var spawn_timer = $SpawnTimer
@export var speed = 10
@export var DISTANCE = 10

var spawn_locations
var interactables = {}

var spawn_amount_chances = {
	1: 1/3.0,
	2: 1/4.0,
	3: 1/20.0,
	0: 1/25.0
}

var interactable_spawn_chances = {
	"coin": 1/3.0,
	"petr_sticker": 1/5.0,
	"scooter": 1/7.0,
	"six_seven": 1/7.0,
	"tung_tung": 1/10.0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at("res://scenes/interactables"):
		if (file.get_extension() == 'import'):
			file = file.replace('.import', '')
		interactables[file] = load('res://scenes/interactables/'+file)
		
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
	print(num_obstacles)
	var chosen_interactables = []
	for i in range(num_obstacles):
		var keys = interactables.keys()
		var interactable_index = randi_range(0, len(keys)-1)
		chosen_interactables.append(keys[interactable_index])
		
	if 'tung_tung.tscn' in chosen_interactables:
		chosen_interactables = ['tung_tung.tscn']
	
	for chosen_interactable in chosen_interactables:
		var interactable_scene = interactables[chosen_interactable]
		var interactable = interactable_scene.instantiate()
		

		var location_index = randi_range(0, len(available)-1)
		interactable.init(spawn_locations[available[location_index]].global_position, self)
		add_child(interactable)

		available.remove_at(location_index)
		

		
