extends Control

var fin : bool = false
@export var catalogue : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(modulate.a <= 0):
		queue_free()
	if(fin or catalogue.visible):
		modulate.a -= 0.1


func _on_timer_timeout():
	fin = true
