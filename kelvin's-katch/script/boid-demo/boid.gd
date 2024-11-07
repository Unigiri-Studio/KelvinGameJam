extends Node3D

var fish_scene = load("res://scene/boid-demo/fish.tscn")
var cod_resource = load("res://asset/resource/fish/cod.tres")
var tuna_resource = load("res://asset/resource/fish/tuna.tres")
var squid_resource = load("res://asset/resource/fish/squid.tres")
var basking_shark_resource = load("res://asset/resource/fish/basking_shark.tres")
var flounder_resource = load("res://asset/resource/fish/flounder.tres")
var gar_fish_resource = load("res://asset/resource/fish/gar_fish.tres")
var mackerel_resource = load("res://asset/resource/fish/mackerel.tres")
const FISH_COUNT = 16  # number of fish
const X_RANGE = Vector2(-150, 150)  # x-axis
const Z_RANGE = Vector2(-150, 150)  # z-axis
const Y_POSITION = 2  # y-axis height
const MIN_DISTANCE_BETWEEN_FISH = 20.0  

var fish_species = ['basking_shark', 'cod', 'flounder', 'gar_fish', 'mackerel', 'squid', 'whiting', 'wrasse']

func _ready() -> void:
	for i in range(fish_species.size()):
		var fish_resource_location = "res://asset/resource/fish/" + fish_species[i]+".tres"
		var fish_resource = load(fish_resource_location)
		for j in range(FISH_COUNT):
			var fish = fish_scene.instantiate()
			fish.fish_data = fish_resource.duplicate()
			fish.global_position = get_random_position()
			add_child(fish)

func get_random_position() -> Vector3:
	var position
	var is_position_valid = false
	
	while not is_position_valid:
		position = Vector3(randf_range(X_RANGE.x, X_RANGE.y), Y_POSITION, randf_range(Z_RANGE.x, Z_RANGE.y))
		is_position_valid = true

		for fish in get_children():
			if fish.global_position.distance_to(position) < MIN_DISTANCE_BETWEEN_FISH:
				is_position_valid = false
				break

	return position
