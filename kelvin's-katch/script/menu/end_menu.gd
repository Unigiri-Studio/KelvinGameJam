extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a += 0.05


func _on_timer_timeout():
	get_tree().quit()
