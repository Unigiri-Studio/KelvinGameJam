extends CharacterBody3D

@onready var animated_sprite = $playerSprite
# Variables for boat physics
var acceleration = 100.0 # How fast the boat accelerates
var maxSpeed = 400.0 # Maximum speed the boat can reach
var drag = 0.95 # Drag coefficient (should be between 0 and 1, where 1 is no drag)

#player states
enum SAILSTATE {IDLE, SAILING,FISHING}
enum FISHSTATE {AIMING,CASTED,WAITING,CATCHED}
var state = SAILSTATE.IDLE #base state

func _physics_process(delta):
	var direction = Vector3.ZERO
	if(state == SAILSTATE.SAILING or state == SAILSTATE.IDLE): # player sailing
		#get sailing Direction
		direction = Input.get_vector("sailLeft", "sailRight", "sailForward", "sailBackwards").normalized()
		direction = Vector3(direction.x,0,direction.y) #convert vector2 into vector3
		state = SAILSTATE.SAILING
	elif(velocity == Vector3.ZERO): #player stopped
		state = SAILSTATE.IDLE
	
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

#helper functions
func clampVector3(vec3: Vector3) -> Vector3:
	return Vector3(
		1 if vec3.x > 0 else -1 if vec3.x < 0 else 0,
		1 if vec3.y > 0 else -1 if vec3.y < 0 else 0,
		1 if vec3.z > 0 else -1 if vec3.z < 0 else 0
		)
func play_animation(animation_name: String):
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
