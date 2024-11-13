extends Control

@export var fish_data: fish_class

@onready var plaque = %plaque
@onready var correct_guess_popup = %Popup  # Reference to your popup
@onready var popup_label = %Label  # Reference to the label inside the popup

func _ready():
	pass

func _process(delta):
	plaque.description = fish_data.species
	plaque.speciesSize = fish_data.avg_size
	%fishTexture.texture = fish_data.fish_sprite

func _on_size_edit_text_submitted(new_text):
	if plaque.speciesSize == int(new_text):
		Glubal.Catalogued += 1
		%fishTexture.material = null
		plaque.catalogued = true
		popup_label.text=fish_data.fun_fact
		correct_guess_popup.popup()  # Show the popup
