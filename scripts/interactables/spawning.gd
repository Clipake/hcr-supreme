extends Node3D


@onready var spawn_timer = $SpawnTimer
@export var speed: float = 2
@export var DISTANCE: float = 4

@export var reel_tile: PackedScene

@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

var spawn_locations
var interactables = []

# This determines the chances of 0-3 obstacles spawning in a row
var spawn_amount_chances = {
	1: 1/3.0,
	2: 1/4.0,
	3: 1/10.0,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at("res://scenes/interactables"):
		if (file.get_extension() == 'import'):
			file = file.replace('.import', '')
		interactables.append(load('res://scenes/interactables/'+file))
	
	spawn_locations = get_node("SpawnLocations").get_children()
	
	# Spawns 10 rows of initial tiles so that level is not empty on start
	for row in range(1, 11):
		for index in range(3): # Spawn 3 in a row
			var tile = reel_tile.instantiate()
			var side_scale_offset = Vector3(1.1, 1, 1)
			var offset = Vector3(0, 0, -2+(speed/spawn_timer.wait_time)*row*1.3)
			var spawn_position = spawn_locations[index].global_position*side_scale_offset+offset
			tile.init(spawn_position+Vector3(0, -0.75, 0), self)
			add_child(tile)
	
	run_music_node.play() # Play run music, pause menu music & restart progress
	menu_music_node.play()
	menu_music_node.stream_paused = true
	spawn_timer.start()
	
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
	
	# Creates a reel tile at each spawn location, every time an obstacle spawns (every row)
	for index in available:
		var side_scale_offset = Vector3(1.1, 1, 1)
		var spawn_position = spawn_locations[index].global_position*side_scale_offset
		var tile = reel_tile.instantiate()
		tile.init(spawn_position+Vector3(0, -0.75, 0), self)
		add_child(tile)
	
	for i in range(num_obstacles):
		var interactable_index = randi_range(0, len(interactables)-1)
		var interactable_scene = interactables[interactable_index]
		var interactable = interactable_scene.instantiate()
		
		var location_index = randi_range(0, len(available)-1)
		## The global position of the relevant spawn location object
		var spawn_position = spawn_locations[available[location_index]].global_position
		interactable.init(spawn_position, self)

		available.remove_at(location_index)
		add_child(interactable)
		
	pass # Replace with function body.

		
