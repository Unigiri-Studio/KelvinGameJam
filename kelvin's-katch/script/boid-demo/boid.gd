extends Node3D

var fish_scene = load("res://scene/fish/fish.tscn")
const FISH_COUNT = 50  # max number of fish
const X_RANGE = Vector2(-150, 150)  # x-axis
const Z_RANGE = Vector2(-150, 150)  # z-axis
const MIN_DISTANCE_BETWEEN_FISH = 20.0  

var fish_species = ['basking_shark', 'cod', 'flounder', 'gar_fish', 'mackerel', 'squid', 'tuna', 'whiting', 'wrasse']
var fish_count = []

func _ready() -> void:
	fish_appearence_frequency()
	for i in range(fish_species.size()):
		var fish_resource_location = "res://asset/resource/fish/" + fish_species[i]+".tres"
		var fish_resource = load(fish_resource_location)
		for j in range(fish_count[i]):
			var fish = fish_scene.instantiate()
			fish.fish_data = fish_resource.duplicate()
			var depth = fish.fish_data.depth
			var position = get_random_position(depth)
			fish.global_position = position
			add_child(fish)

func fish_appearence_frequency() -> void:
	var total_fish = 0
	fish_count.clear()
	
	# Repeat until the total count is within the desired range
	while total_fish < 280 or total_fish > 350:
		fish_count.clear()
		total_fish = 0
		
		for i in range(fish_species.size()):
			var fish_subset = randi_range(1, FISH_COUNT)
			fish_count.append(fish_subset)
			total_fish += fish_subset
	print(total_fish)

# Adjusted to accept depth as a parameter
func get_random_position(depth: float) -> Vector3:
	var position
	var is_position_valid = false
	
	while not is_position_valid:
		# Use depth for the Y position
		position = Vector3(randf_range(X_RANGE.x, X_RANGE.y), depth, randf_range(Z_RANGE.x, Z_RANGE.y))
		is_position_valid = true

		for fish in get_children():
			if fish.global_position.distance_to(position) < MIN_DISTANCE_BETWEEN_FISH:
				is_position_valid = false
				break

	return position
