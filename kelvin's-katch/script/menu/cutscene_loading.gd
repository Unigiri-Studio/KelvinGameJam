extends Control

var cutscene_finished = false
var play = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(modulate.a <= 0):
		queue_free()
	
	if (play):
		$AnimatedSprite2D.play("gif", 0.5)
	if(cutscene_finished):
		modulate.a -= 0.1
	


func _on_cutscene_finished():
	print("fin")
	cutscene_finished = true
