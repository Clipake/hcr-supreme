extends Node3D

@onready var spawn_locations: Array = $SpawnLocations.get_children()

@export var ramp_up_speed: float = 0.001 ## The speed at which the game accelerates
@export var distance: float = 20.0 ## Distance between reel tiles

@export var interactables: Dictionary[PackedScene, int]
@export var reel_tile: PackedScene
@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

var speed: float = 1 ## Measured as a multiplier from 1x being starting speed
var time_elapsed: float = 0 ## Used as a timer for spawning

var score := 0
var coins := 0

@export var interactable_spawn_chances := {
	"coin": 40,
	"petr_sticker": 20,
	"scooter": 10,
	"six_seven": 10,
	"please_shower": 5,
	"tung_tung": 5,
	"jobapplication": 10
}
@export var spawn_amount_chances := {
	1: 40, 2: 30, 3: 10, 0: 20,
}

func _ready() -> void:
	_spawn_initial_tiles()
	_start_run_music()

func _physics_process(delta: float) -> void:
	speed += delta * ramp_up_speed
	time_elapsed += speed * delta
	
	if time_elapsed > 1:
		_on_timer_timeout()
		time_elapsed = 0

func _on_timer_timeout() -> void:
	var num_obstacles = 3 #_get_weighted(spawn_amount_chances)
	var chosen = []
	
	for i in num_obstacles:
		chosen.append(_get_weighted(interactables))
	_spawn_reel_row(chosen)

func _spawn_initial_tiles():
	for row in 10:
		for lane in 3:
			_spawn_reel_tile(lane)

func _start_run_music():
	run_music_node.play()
	menu_music_node.play()
	menu_music_node.stream_paused = true

func _get_weighted(items: Dictionary) -> Variant:
	var total_weight := 0
	for weight in items.values():
		total_weight += weight

	var roll := randi() % total_weight
	var sum := 0

	for value in items.keys():
		sum += items[value]
		if roll < sum:
			return value

	return null  # unreachable unless items is empty

func _spawn_reel_row(items: Array):
	# TODO add tung tung running side to side
	for i in range(3):
		_spawn_reel_tile(i, items[i])

func _spawn_reel_tile(column: int, above: PackedScene = null):
	var base_position = spawn_locations[column].global_position
	var pos = base_position * Vector3(1.1, 1, 1)
	
	var tile = reel_tile.instantiate()

	# simple color logic
	var tile_color = Color(1, 1, 1)
	if above:
		if above.resource_name in ["jobapplication.tscn", "six_seven.tscn", "tung_tung.tscn"]:
			tile_color = Color(1.0, 0.5, 0.5) # red-ish
		elif above.resource_name in ["petr_sticker.tscn", "scooter.tscn"]:
			tile_color = Color(0.5, 1.0, 0.5) # green-ish
		else:
			tile_color = Color(0.5, 0.5, 0.5) # neutral
	
	tile.init(pos + Vector3(0, -0.75, 0), tile_color)
	add_child(tile)


func _spawn_interactables(list: Array):
	var available := [0, 1, 2]

	for filename in list:
		var scene: PackedScene = interactables.get(filename)
		if not scene:
			continue

		# choose lane
		var lane_idx = randi_range(0, available.size() - 1)
		var lane = available[lane_idx]
		available.remove_at(lane_idx)

		# spawn interactable
		var inst = scene.instantiate()
		var pos = spawn_locations[lane].global_position
		inst.init(pos)
		add_child(inst)

		# spawn a reel under it (color-aware)
		_spawn_reel_tile(lane, filename)
