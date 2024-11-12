extends Control

var main = "res://scene/main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	ResourceLoader.load_threaded_request(main)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _start_button_pressed():
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main))


func _quit_button_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play("title")
