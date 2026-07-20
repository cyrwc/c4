extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var joystickSensitivity = 0.05

@export var Head : Camera3D
var Sensitivity: float = 0.02

@onready var camera_3d: Camera3D = $Camera3D
# move camera with joystick on controller

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
# Handle mouse look and quit input
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Sensitivity)
		camera_3d.rotate_x(-event.relative.y * Sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	# Quit game when Esc is pressed
	if Input.is_action_just_pressed("ui_en"):
		get_tree().quit()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
			rotate_y(-event.relative.x * Sensitivity)
			Head.rotate_x(-event.relative.y * Sensitivity)
		
			Head.rotation.x = clamp(Head.rotation.x, deg_to_rad(90), deg_to_rad(-90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
# Handle jump
	if Input.is_action_just_pressed("ui_accep") and is_on_floor():
		print ("jump was just pressed")
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

#controller look around
	$Camera3D.rotate_x(Input.get_action_strength("look_up") * joystickSensitivity)
	$Camera3D.rotate_x(Input.get_action_strength("look_down") * joystickSensitivity * -1)
	if($Camera3D.rotation_degrees.x < -70):
		$Camera3D.rotation_degrees.x = -70
	elif($Camera3D.rotation_degrees.x > 70):
		$Camera3D.rotation_degrees.x = 70
	rotate_y(Input.get_action_strength("look_left") * joystickSensitivity)
	rotate_y(Input.get_action_strength("look_right") * joystickSensitivity * -1)

	move_and_slide()
