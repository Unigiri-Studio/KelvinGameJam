extends Control

var showcase = preload("res://scene/object/showcase.tscn")

@onready var showcaseContainer = %showcaseContainer

var calalogueNumber : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_fish_showcase("res://asset/resource/fish/") #init fishies


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# helper function

func populate_fish_showcase(SpeciesDir : String):
	var dir = DirAccess.open(SpeciesDir)
	if dir:
		dir.list_dir_begin()
		var ind = 0 #init dictionary indexing
		var speciesName = dir.get_next()
		while speciesName != "":
			var sc = showcase.instantiate()
			sc.fish_data = load(SpeciesDir + speciesName).duplicate()
			%showcaseContainer.add_child(sc)
			var mc : MarginContainer = MarginContainer.new()
			mc.custom_minimum_size.x = 20
			mc.mouse_filter = Control.MOUSE_FILTER_PASS
			%showcaseContainer.add_child(mc)
			ind += 1
			speciesName = dir.get_next()
	else:
		print("error: cannot get Species Directory")
