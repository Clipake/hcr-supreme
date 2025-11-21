extends Node3D


@onready var spawn_timer = $SpawnTimer
@export var speed: float = 2
@export var DISTANCE: float = 4

@export var reel_tile: PackedScene

@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

var spawn_locations
var interactables = {}

var score: int = 0

var coins: int = 0

@onready var health_bar = $CanvasLayer/HealthBar

# This determines the chances of 0-3 obstacles spawning in a row
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
	"six_seven": 10,
	"please_shower": 5,
	"tung_tung": 5,
	"jobapplication": 10
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
		var ext = file.get_extension().to_lower()
		if ext == "tscn":                     # ONLY load scenes
			var scene = load("res://scenes/interactables/" + file)
			if scene is PackedScene:          # DOUBLE CHECK
				interactables[file] = scene
			else:
				push_warning("Skipped non-PackedScene: " + file)
		else:
			print("Ignored:", file)
	
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
	speed += tick_counter/1000*0.02
	spawn_timer.wait_time = float(DISTANCE)/(speed)
	
func _on_timer_timeout() -> void:	
	
	var num_obstacles = get_weighted_chance(spawn_amount_chances, amount_fallback)
	var available = [0, 1, 2]
	var chosen_interactables = []
	
	# Creates a reel tile at each spawn location, every time an obstacle spawns (every row)
	for index in available:
		var side_scale_offset = Vector3(1.1, 1, 1)
		var spawn_position = spawn_locations[index].global_position*side_scale_offset
		var tile = reel_tile.instantiate()
		tile.init(spawn_position+Vector3(0, -0.75, 0), self)
		add_child(tile)
	
	for i in range(num_obstacles):
		var interactable = get_weighted_chance(interactable_spawn_chances, interactable_fallback)
		chosen_interactables.append(interactable + '.tscn')
		
	if 'tung_tung.tscn' in chosen_interactables:
		chosen_interactables = ['tung_tung.tscn']
	
	for chosen_interactable in chosen_interactables:
		var interactable_scene = interactables[chosen_interactable]
		var interactable = interactable_scene.instantiate()

		var location_index = randi_range(0, len(available)-1)
		## The global position of the relevant spawn location object
		var spawn_position = spawn_locations[available[location_index]].global_position
		interactable.init(spawn_position, self)
		interactable.connect("collected_signal", Callable(self, "_on_interactable_collected"))
		available.remove_at(location_index)
		
		add_child(interactable)

		

func _on_interactable_collected(effect_type: String):
	print('signal fired: ', effect_type)
	Events.touched_interactable.emit(effect_type)
	match effect_type:
		"67":
			score -= 676  # Increase speed
		"jobapp":
			print(5)
		"peter":
			score += 500
		"plsshower":
			print("Unknown effect: ", effect_type)
		"scooter":
			print(6)
		"coin":
			coins += 1
		"tungtung":
			print(8)

	Events.set_total.emit(score)
	Events.set_coins_collected.emit(coins)
