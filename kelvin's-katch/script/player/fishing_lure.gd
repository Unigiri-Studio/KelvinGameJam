extends CharacterBody3D

@onready var fishing_line: MeshInstance3D = $fishingLine
@export var fishingRodTip : Node3D

func _ready():
	pass

func _physics_process(delta):
	var lineMesh = drawFishingLine(fishingRodTip.global_position,global_position, 2)
	fishing_line.mesh = lineMesh

func drawFishingLine(startPos : Vector3, endPos : Vector3, sag : int, segments : int = 10) -> ImmediateMesh:
	# Create an ImmediateMesh to draw the fishing line
	var mesh = ImmediateMesh.new()
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	var distance = startPos - endPos
	var step = distance / segments

	# Generate the points using cubic interpolation
	for i in range(segments + 1):
		var t = i / float(segments)  # Progress along the curve from 0 to 1
		var currentPoint = startPos + step * i
		
		# Apply a Y-offset for sagging effect
		var distanceAlongLine = t - 0.5  # Center the curve at the midpoint
		#var y_offset = sag * pow(distanceAlongLine, 2)  # Parabolic curve for sagging
		#currentPoint.y += y_offset
		
		currentPoint.x -=startPos.x
		currentPoint.y -= startPos.y
		# Add the point to the line mesh
		mesh.surface_add_vertex(currentPoint)

	# Finish and set the mesh
	mesh.surface_end()
	return mesh
	
#func drawFishingLine(startPos : Vector3, endPos : Vector3, sag : int, segments : int = 10) -> ImmediateMesh:
	## Create an ImmediateMesh to draw the fishing line
	#var mesh = ImmediateMesh.new()
	#mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	#
	#var distance = startPos - endPos
	#var step = distance / segments
#
	## Generate the points using cubic interpolation
	#for i in range(segments + 1):
		#var t = i / float(segments)  # Progress along the curve from 0 to 1
		#var currentPoint = startPos + step * i
		#
		## Apply a Y-offset for sagging effect
		#var distanceAlongLine = t - 0.5  # Center the curve at the midpoint
		##var y_offset = sag * pow(distanceAlongLine, 2)  # Parabolic curve for sagging
		##currentPoint.y += y_offset
		#
		## Add the point to the line mesh
		#mesh.surface_add_vertex(currentPoint)
#
	## Finish and set the mesh
	#mesh.surface_end()
	#return mesh
