extends Node3D

var catalogue_scene = load("res://scene/Catalogue.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(catalogue_scene)
	catalogue_scene.hide()
	process_mode = Node.PROCESS_MODE_PAUSABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().paused = true
	catalogue_scene.show()
