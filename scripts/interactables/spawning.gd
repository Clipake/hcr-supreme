extends Node3D


@onready var spawn_timer = $SpawnTimer
@export var speed = 8
@export var DISTANCE = 8

var spawn_locations
var interactables = {}

var spawn_amount_chances = {
	1: 50,
	2: 30,
	3: 4,
	0: 1,
}
var amount_fallback = 1

var interactable_spawn_chances = {
	"coin": 40,
	"petr_sticker": 20,
	"scooter": 10,
	"six_seven": 20,
	"tung_tung": 5,
}
var interactable_fallback = "coin"

func get_weighted_chance(chances: Dictionary, fallback):
	var total = 0.0
	for chance in chances.values():
		total += chance
		
	var rng = randf() * total
	
	var cumulative = 0.0
	for value in chances:
		cumulative += chances[value]
		if rng <= cumulative:
			return value
	return fallback
	
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
	var num_obstacles = get_weighted_chance(spawn_amount_chances, amount_fallback)
	
	var sorted_chances = spawn_amount_chances.keys()
	sorted_chances.sort()
	sorted_chances.reverse()
	
	var available = [0, 1, 2]
	
	print(num_obstacles)
	var chosen_interactables = []
	for i in range(num_obstacles):
		var interactable = get_weighted_chance(interactable_spawn_chances, interactable_fallback)
		chosen_interactables.append(interactable + '.tscn')
		
	if 'tung_tung.tscn' in chosen_interactables:
		chosen_interactables = ['tung_tung.tscn']
	
	for chosen_interactable in chosen_interactables:
		var interactable_scene = interactables[chosen_interactable]
		var interactable = interactable_scene.instantiate()
		

		var location_index = randi_range(0, len(available)-1)
		interactable.init(spawn_locations[available[location_index]].global_position, self)
		add_child(interactable)

		available.remove_at(location_index)
		

		
