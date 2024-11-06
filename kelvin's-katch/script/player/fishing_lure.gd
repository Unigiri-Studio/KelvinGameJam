extends CharacterBody3D

@onready var fishing_line: MeshInstance3D = $fishingLine
@export var fishingRodTip : Node3D

func _ready():
	pass

func _physics_process(delta):
	if visible:
		DrawLine3d.DrawLine(fishingRodTip.global_position, global_position, Color(255, 255, 255), delta)
