extends CharacterBody3D

@onready var animated_sprite = $playerSprite
# Variables for boat physics
var acceleration = 100.0 # How fast the boat accelerates
var maxSpeed = 400.0 # Maximum speed the boat can reach
var drag = 0.9 # Drag coefficient (should be between 0 and 1, where 1 is no drag)

#player states
enum STATE {IDLE,SAILING,AIMING,CASTING,WAITING,CATCHED}
const STATELOOKUP = ["idle","sailing","aiming","casting","waiting","catched"]
var state: STATE = STATE.IDLE #base state
#direction
enum DIRSTATE {N,NE,E,SE,S,SW,W,NW}
const DIRLOOKUP = ["N","NE","E","SE","S","SW","W","NW"]
var dirState : DIRSTATE

#fishing variables
var fishPlane:Plane #used for fishing and for fish logic
@export var camera : Camera3D

#lure accuracy variables
var ringTween: Tween = null
var targetTween : Tween = null
var minScale : Vector3 = Vector3(0.1,0.1,0.1)
var shrinkDuration = 5
@onready var lure = %fishingLure

func _ready():
	fishPlane = Plane(Vector3.UP, Vector3.ZERO)
	%playerSprite.animation = 'idleS'
	dirState = DIRSTATE.S
	
func _physics_process(delta):
	match state:
		STATE.IDLE:
			if Input:#if input is recived
				if Input.is_action_pressed("sailLeft") or Input.is_action_pressed("sailRight") or Input.is_action_pressed("sailForward") or Input.is_action_pressed("sailBackwards"): #movement
					changeState(STATE.SAILING)
				elif Input.is_action_just_pressed("modeChange"):#fishing mode change
					changeState(STATE.AIMING)

		STATE.SAILING:
			var direction = Vector3.ZERO
		
			#get sailing Direction
			direction = Input.get_vector("sailLeft", "sailRight", "sailForward", "sailBackwards").normalized()
			direction = Vector3(direction.x,0,direction.y) #convert vector2 into vector3
			state = STATE.SAILING
		
			if(velocity.length() <= 0.1): #player stopped
				changeState(STATE.IDLE)

			#apply acceleration
			var accel = direction * acceleration * delta
			velocity += accel
	
			#apply drag
			velocity *= drag
	
			faceDir(accel) #boat facing direction
	
			#clamp to max speed
			if velocity.length() > maxSpeed:
				velocity = velocity.normalized() * maxSpeed
			
			# Moving the Character
			move_and_slide()

		STATE.AIMING:
			if Input.is_action_just_pressed("modeChange"):#change mode
				changeState(STATE.IDLE)
			
			# get mouse position on water
			var worldPosition = fishPlane.intersects_ray(
				camera.project_ray_origin(get_viewport().get_mouse_position()),
				camera.project_ray_normal(get_viewport().get_mouse_position()))
			
			#update lure location
			%fishingRing.global_position = worldPosition
			
			if Input.is_action_just_pressed("castRod"):
				changeState(STATE.CASTING)
		
		STATE.CASTING:
			if !Input.is_action_pressed("castRod"): #while focusing lure location
				if ringTween:
					ringTween.stop()
				if targetTween:
					targetTween.stop()
				changeState(STATE.WAITING)
			
		STATE.WAITING:
			if Input.is_action_just_pressed("castRod"):
				changeState(STATE.AIMING)
			#TODO Fish collision logic here
			
#helper functions
func changeState(newState: STATE) -> void:
	state = newState
	match state:
		STATE.IDLE:
			play_animation(STATELOOKUP[state] + DIRLOOKUP[dirState])
			%fishingRing.visible = false
			print("Idle")
		STATE.SAILING:
			%fishingRing.visible = false
			print("Sailing")
		STATE.AIMING:
			play_animation(STATELOOKUP[state] + DIRLOOKUP[dirState])
			%accuracyRing.scale = Vector3i(1,1,1)
			%target.scale = Vector3(1,1,1)
			%fishingRing.visible = true
			lure.visible = false
			print("Aiming")
		STATE.CASTING:
			play_animation(STATELOOKUP[state] + DIRLOOKUP[dirState])
			ringTween = get_tree().create_tween()
			targetTween = get_tree().create_tween()
			ringTween.tween_property(%accuracyRing, "scale", minScale, shrinkDuration)
			targetTween.tween_property(%target,"scale",minScale,shrinkDuration)
			print("Casting")
		STATE.WAITING:
			play_animation(STATELOOKUP[state] + DIRLOOKUP[dirState])
			var randomLurePos : Vector3 = getRandomPosInsideMesh(%accuracyRing)
			#lure.global_position = lure.fishingRodTip.global_position #starting pos of lure
			lure.global_position = randomLurePos
			lure.fishingRodTip = get_node("fishingRodTipMarker/tip" + DIRLOOKUP[dirState]) #start fishing line from marker in same facing direction
			lure.visible = true
			%fishingRing.visible = false
			print("Waiting")

func clampVector3(vec3: Vector3) -> Vector3:
	return Vector3(
		1 if vec3.x > 0 else -1 if vec3.x < 0 else 0,
		1 if vec3.y > 0 else -1 if vec3.y < 0 else 0,
		1 if vec3.z > 0 else -1 if vec3.z < 0 else 0
		)

func play_animation(animation_name: String) -> void:
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func faceDir(vec3 : Vector3) -> void:
	vec3 = clampVector3(vec3)
	var pre : String = STATELOOKUP[state] #state as string
	var curDir : DIRSTATE
	match vec3:
		Vector3(0,0,0): #base when no movement
			curDir = dirState
		Vector3(0,0,-1):
			curDir = DIRSTATE.N
		Vector3(0,0,1):
			curDir = DIRSTATE.S
		Vector3(-1,0,0):
			curDir = DIRSTATE.W
		Vector3(1,0,0):
			curDir = DIRSTATE.E
		Vector3(1,0,-1):
			curDir = DIRSTATE.NE
		Vector3(-1,0,1):
			curDir = DIRSTATE.SW
		Vector3(-1,0,-1):
			curDir = DIRSTATE.NW
		Vector3(1,0,1):
			curDir = DIRSTATE.SE
	dirState = curDir
	play_animation(pre + DIRLOOKUP[dirState])

func getRandomPosInsideMesh(mesh : MeshInstance3D) -> Vector3:
	#using cartisean coodinates will get random point inside cylindarMesh
	var aabb = mesh.get_aabb() # get bounding box of mesh
	
	var curScale = mesh.scale.x #the scale can vary, but uniform so 1point is only needed
	var radius = aabb.size.x / 2 * curScale
	#var height = aabb.size.y * curScale
	
	#polar to cartisan coordinates convertion
	var angle = randf() * PI * 2 #random angle 0-2PI
	var distance = sqrt(randf()) * radius #random distance within radius
	
	var cartX = cos(angle) * distance
	var cartY = 0#randf_range(0,height)
	var cartZ = sin(angle) * distance
	
	return mesh.global_position + Vector3(cartX,cartY,cartZ)
