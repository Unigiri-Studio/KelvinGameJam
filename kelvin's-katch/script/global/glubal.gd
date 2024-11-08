extends Node
var species_size_toerance : int = 5

func cast(starting_pos : Vector3,ending_pos : Vector3, t : float, curve : Curve):
	#starting_pos = addHeight(starting_pos, 1,curve)
	#ending_pos = addHeight(ending_pos, 1,curve)
	return starting_pos.lerp(ending_pos,t)

func addHeight(vec : Vector3, t : float, curve : Curve):
	var x = vec.x + curve.sample(t)
	var y = vec.y + curve.sample(t) * curve.sample(t)
	var z = vec.z + curve.sample(t)
	return Vector3(x,y,z)
