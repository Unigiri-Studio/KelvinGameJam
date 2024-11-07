extends Node3D

var fish_scene = load("res://scene/boid-demo/fish.tscn")
var fish1_scene = load("res://scene/boid-demo/fish1.tscn")
const FISH_COUNT = 100  # number of fish
const X_RANGE = Vector2(-90, 90)  # x-axis
const Z_RANGE = Vector2(-90, 90)  # z-axis
const Y_POSITION = 2  # y-axis height

func _ready() -> void:
	if fish_scene:
		for i in range(FISH_COUNT):
			var fish = fish_scene.instantiate()
			var fish1 = fish1_scene.instantiate()
			# randamly positioning the fish
			fish.global_position = Vector3(randf_range(X_RANGE.x, X_RANGE.y), Y_POSITION, randf_range(Z_RANGE.x, Z_RANGE.y))
			fish1.global_position = Vector3(randf_range(X_RANGE.x, X_RANGE.y), Y_POSITION, randf_range(Z_RANGE.x, Z_RANGE.y))
			add_child(fish)
			add_child(fish1)
	else:
		print("Failed to load fish scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
