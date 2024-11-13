extends MarginContainer

var description : String = ""
var speciesSize : int
var catalogued : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%description.text = description.replace('_',' ')
	if(catalogued == false):
		%sizeCorrect.text = str(speciesSize) + "cm"
		return
	%sizeEdit.visible = false
	%sizeCorrect.visible = true
