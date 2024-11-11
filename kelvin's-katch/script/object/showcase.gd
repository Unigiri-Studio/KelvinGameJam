extends Control

var fish_data: fish_class

@onready var plaque = %plaque

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	plaque.description = fish_data.species
	plaque.speciesSize = fish_data.avg_size
	%fishTexture.texture = fish_data.fish_sprite


func _on_size_edit_text_submitted(new_text):
	if plaque.speciesSize == int(new_text):
		print("correct guess")
		%fishTexture.material = null
		plaque.catalogued = true
		
		
