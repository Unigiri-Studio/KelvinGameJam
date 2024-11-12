extends Control
var sprite : Texture2D
var species : String
var fishSize : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		%fishSprite.texture = sprite
		%fishSpecies.text = species
		%fishSize.text = str(fishSize) + "cm"
