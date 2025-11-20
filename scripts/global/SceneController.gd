extends Node

@export var main_scene: PackedScene
@export var start_scene: PackedScene

func _ready() -> void:
	Events.open_home.connect(_on_open_home)
	Events.start_game.connect(_on_start_game)
	
func _on_open_home():
	get_tree().change_scene_to_packed(start_scene)

func _on_start_game():
	get_tree().change_scene_to_packed(main_scene)
