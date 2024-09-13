extends CharacterBody3D

#defines player states a.k.a "what is the player doing right now?
#This will be used throughout the code to help define what the player is doing.
var isCrouching: bool = false
var isProne: bool = false
var isDodge: bool = false

#defines player speed a.k.a "how fast is the player moving right now?
#This will be used throughout the code to help define what the player is doing.
var playerSpeed

#constants used for maximum base player stats
const BASE_HEALTH  = 5
const BASE_STAMINA = 20
const DASH_SPEED = 10

#Variables for player stats
var playerHealth = BASE_HEALTH
var playerStamina = BASE_STAMINA

var healthRegen: bool = false
var staminaRegen: bool = false

@onready var dash = $DashTimer

#check for specific input events/key presses
func _input(event):
	if (event.is_action_pressed("userInput_playerActionCrouch")):
		toggleCrouch()
	elif (event.is_action_pressed("userInput_playerActionProne")):
		toggleProne()
	elif(event.is_action_pressed("userInput_utilityMenuPause")):
		get_tree().quit()
		
	#END INPUT CHECK

#handles player movement and collision with ground
func _physics_process(delta: float) -> void:
			
	#set values
	var input_dir := Input.get_vector("userInput_playerMoveLeft", "userInput_playerMoveRight", 
									  "userInput_playerMoveUp", "userInput_playerMoveDown")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Adds gravity to character..
	if not is_on_floor():
		velocity += get_gravity() * delta
		#END GRAVITY-CHECK
	
	#determine player speed based on current stance
	setPlayerSpeed()
	
	#brute force dash check: overrides current stance
	if(Input.is_action_just_pressed("userInput_playerActionDodge") and direction):
		isDodge = true
		dash.start_dash()
		print("You are DASHING")
		isCrouching = false
		isProne = false

	#enact dash movement, normal movement or no movement
	if(dash.is_dashing() and direction):
		velocity.x = direction.x * DASH_SPEED
		velocity.z = direction.z * DASH_SPEED
	elif(direction):
		velocity.x = direction.x * playerSpeed
		velocity.z = direction.z * playerSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, playerSpeed)
		velocity.z = move_toward(velocity.z, 0, playerSpeed)
	
	#These methods move the body along a given vector and detect collisions.
	move_and_slide()
	#END _PHYSICS_PROCESS FUNCTION

#handles player movement based on stance (CROUCH)
func toggleCrouch()->void:
	
	#if standing, set to crouch. if crouched, set to standing
	isCrouching = ! isCrouching
	isProne = ! isProne
	
	if(isProne and isCrouching):
		isProne = false
		print("You are PRONE to CROUCH")
	elif(isCrouching):
		print("You are CROUCHED")
	else:
		print("You are STANDING UP")
	
	#END TOGGLE_CROUCH FUNCTION

#handles player movement based on stance (PRONE)
func toggleProne()->void:
	
	#if prone, set to standing. if standing, set to prone.
	isProne = ! isProne
	
	if(isCrouching and isProne):
		isCrouching = false
		print("You are CROUCH to PRONE")
	elif(isProne):
		print("You are PRONE")
	else:
		print("You are STANDING UP")
	
	#END TOGGLE_PRONE FUNCTION

#handles player speed based on booleans active
func setPlayerSpeed()->void:
	#if(isDodge):
	#	playerSpeed = 10.5
	if(isCrouching):
		playerSpeed = 2.5
	elif(isProne):
		playerSpeed = 1.5
	else:
		playerSpeed = 3.5
	
	#END SET_SPEED FUNCTION

#END OF LINE
