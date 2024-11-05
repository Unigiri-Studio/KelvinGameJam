extends CharacterBody3D

@onready var animated_sprite = $playerSprite
# Variables for boat physics
var acceleration = 100.0 # How fast the boat accelerates
var maxSpeed = 400.0 # Maximum speed the boat can reach
var drag = 0.9 # Drag coefficient (should be between 0 and 1, where 1 is no drag)

#player states
enum STATE {IDLE,SAILING,AIMING,CASTING,WAITING,CATCHED}
var state: STATE = STATE.IDLE #base state

#fishing variables
var fishPlane:Plane #used for fishing and for fish logic
@export var camera : Camera3D
#lure location variables
var lureTween: Tween = null
var minScale : Vector3 = Vector3(0.1,0.1,0.1)
var shrinkDuration = 5

func _ready():
	fishPlane = Plane(Vector3.UP, Vector3.ZERO)
	
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
			%lure.global_position = worldPosition
			
			if Input.is_action_just_pressed("castRod"):
				changeState(STATE.CASTING)
		
		STATE.CASTING:
			if !Input.is_action_pressed("castRod"): #while focusing lure location
				if lureTween:
					lureTween.stop()
				#TODO Cast inside raduis circle logic here
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
			%lure.visible = false
			print("Idle")
		STATE.SAILING:
			%lure.visible = false
			print("Sailing")
		STATE.AIMING:
			%lure.scale = Vector3i(1,1,1)
			%lure.visible = true
			print("Aiming")
		STATE.CASTING:
			lureTween = get_tree().create_tween()
			lureTween.tween_property(%lure, "scale", minScale, 1)
			print("Casting")
		STATE.WAITING:
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
	if(vec3 == Vector3(0,0,-1)):
		play_animation("idleN")
	elif(vec3 == Vector3(0,0,1)):
		play_animation("idleS")
	elif(vec3 == Vector3(-1,0,0)):
		play_animation("idleW")
	elif(vec3 == Vector3(1,0,0)):
		play_animation("idleE")
	elif(vec3 == Vector3(1,0,-1)):
		play_animation("idleNE")
	elif(vec3 == Vector3(-1,0,1)):
		play_animation("idleSW")
	elif(vec3 == Vector3(-1,0,-1)):
		play_animation("idleNW")
	elif(vec3 == Vector3(1,0,1)):
		play_animation("idleSE")
