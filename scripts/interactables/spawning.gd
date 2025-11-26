extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@export var speed: float = 2.0
@export var distance: float = 3.0

@export var reel_tile: PackedScene
@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

var spawn_locations: Array
var interactables: Dictionary = {}
var score := 0
var coins := 0

@export var spawn_amount_chances := {
	1: 40, 2: 30, 3: 10, 0: 20,
}
@export var interactable_spawn_chances := {
	"coin": 40,
	"petr_sticker": 20,
	"scooter": 10,
	"six_seven": 10,
	"please_shower": 5,
	"tung_tung": 5,
	"jobapplication": 10
}

var amount_fallback := 1
var interactable_fallback := "coin"

func _ready() -> void:
	_load_interactables()
	_cache_spawn_locations()
	_spawn_initial_tiles()
	_start_run_music()
	spawn_timer.start()

func _physics_process(delta: float) -> void:
	speed += delta * 0.02
	spawn_timer.wait_time = distance / speed

func _on_timer_timeout() -> void:
	_spawn_reel_row()

	var num_obstacles = _get_weighted(spawn_amount_chances, amount_fallback)
	var chosen = []

	for i in num_obstacles:
		chosen.append(_get_weighted(interactable_spawn_chances, interactable_fallback) + ".tscn")

	if "tung_tung.tscn" in chosen:
		chosen = ["tung_tung.tscn"]

	_spawn_interactables(chosen)

func _load_interactables():
	for file in DirAccess.get_files_at("res://scenes/interactables"):
		if file.get_extension().to_lower() == "tscn":
			var scene := load("res://scenes/interactables/" + file)
			if scene is PackedScene:
				interactables[file] = scene

func _cache_spawn_locations():
	spawn_locations = get_node("SpawnLocations").get_children()

func _spawn_initial_tiles():
	for row in 10:
		for lane in 3:
			_spawn_reel_tile(lane, row*2+2, "")

func _start_run_music():
	run_music_node.play()
	menu_music_node.play()
	menu_music_node.stream_paused = true

func _get_weighted(chances: Dictionary, fallback):
	var total := 0
	for v in chances.values():
		total += v
	var pick := randf() * total
	var cumulative := 0.0

	for value in chances:
		cumulative += chances[value]
		if pick <= cumulative:
			return value
	return fallback

func _spawn_reel_row():
	for i in 3:
		_spawn_reel_tile(i, 0, "")

func _spawn_reel_tile(index: int, depth_row := 0, above := ""):
	var base_position = spawn_locations[index].global_position
	var pos = base_position * Vector3(1.1, 1, 1)

	# offset for initial rows
	if depth_row > 0:
		pos.z += -2 + (speed / spawn_timer.wait_time) * depth_row * 1.3

	var tile = reel_tile.instantiate()

	# simple color logic
	var tile_color = Color(1, 1, 1)
	if above != "":
		if above in ["jobapplication.tscn", "six_seven.tscn", "tung_tung.tscn"]:
			tile_color = Color(1.0, 0.5, 0.5) # red-ish
		elif above in ["petr_sticker.tscn", "scooter.tscn"]:
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
		_spawn_reel_tile(lane, 0, filename)
