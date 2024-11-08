extends CharacterBody3D

@onready var fishing_line: MeshInstance3D = $fishingLine
@export var fishingRodTip : Node3D
@export var throwCurve : Curve

func _ready():
	pass

func _physics_process(delta):
	if visible:
		DrawLine3d.DrawLine(fishingRodTip.global_position, global_position, Color(255, 255, 255), delta)

func cast(starting_pos : Vector3,ending_pos : Vector3, t : float):
	starting_pos = addHeight(starting_pos, 1)
	ending_pos = addHeight(ending_pos, 1)
	return starting_pos.lerp(ending_pos,t)

func addHeight(vec : Vector3, t : float):
	var x = vec.x + throwCurve.sample(t)
	var y = vec.y + throwCurve.sample(t) * throwCurve.sample(t)
	var z = vec.z + throwCurve.sample(t)
	return Vector3(x,y,z)
