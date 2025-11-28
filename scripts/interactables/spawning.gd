extends Node3D

@onready var spawn_locations: Array = $SpawnLocations.get_children()

@export var ramp_up_speed: float = 0.1 ## The speed at which the game accelerates
@export var distance: float = 20.0 ## Distance between reel tiles

@export var bad_color: Color = Color(1.0, 0.5, 0.5)
@export var good_color: Color = Color(0.5, 1.0, 0.5)
@export var neutral_color: Color = Color(0.5, 0.5, 0.5)

@export var interactables: Dictionary[PackedScene, int]
@export var spawn_amount_chances: Dictionary[int, int] = {
	0: 20, 1: 40, 2: 30, 3: 10
}
@export var reel_tile: PackedScene
@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

var time_elapsed: float = 0 ## Used as a timer for spawning


func _physics_process(delta: float) -> void:
	GameState.run_speed += delta * ramp_up_speed
	time_elapsed += GameState.run_speed * delta
	
	# ngl, 3 just happens to make the reels spaced apart well, idk its significance
	if time_elapsed > 3:
		_on_timer_timeout()
		time_elapsed = 0

func _on_timer_timeout() -> void:
	var num_obstacles = _get_weighted(spawn_amount_chances)
	var chosen = []
	
	for i in num_obstacles:
		chosen.append(_get_weighted(interactables))
	_spawn_reel_row(chosen)


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
	# randomly pick which lanes get items
	var lanes := [0, 1, 2]
	lanes.shuffle()

	var lane_to_item := [null, null, null]

	# assign each item to a random lane
	for i in range(items.size()):
		lane_to_item[lanes[i]] = items[i]

	# now spawn row using the mapped assignments
	for lane in 3:
		_spawn_reel_tile(lane, lane_to_item[lane])

func _spawn_reel_tile(column: int, above: PackedScene = null):
	# Finding init spawn position for this reel tile
	var base_position = spawn_locations[column].global_position
	var pos = base_position * Vector3(1.1, 1, 1)
	
	var tile_color = Color(1, 1, 1)
	if above:
		# spawn above interactable
		var interactable = above.instantiate()
		interactable.init(pos)
		add_child(interactable)
		
		# change reel tile color
		var filename = above.resource_path.substr(above.resource_path.rfind('/')+1)
		if filename in ["jobapplication.tscn", "six_seven.tscn", "tung_tung.tscn"]:
			tile_color = bad_color
		elif filename in ["petr_sticker.tscn", "scooter.tscn"]:
			tile_color = good_color
		else:
			tile_color = neutral_color
	
	# spawn reel tile
	var tile = reel_tile.instantiate()
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
