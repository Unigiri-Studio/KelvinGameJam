extends Node3D

var fish_scene = load("res://scene/fish.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fish1 = fish_scene.instantiate()
	fish1.global_position = Vector3(5,1,0)
	add_child(fish1)
	var fish2 = fish_scene.instantiate()
	fish2.global_position = Vector3(10,1,0)
	add_child(fish2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
