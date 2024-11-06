extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _start_button_pressed():
	get_tree().change_scene_to_file("res://scene/main.tscn")
	#get_tree().paused = false


func _quit_button_pressed():
	get_tree().quit()
