extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.scale.y <= 0):
		self.queue_free()
	if(randi_range(0,1) == 1):
		self.scale.y -=0.02
	else:
		self.scale.y += 0.01
