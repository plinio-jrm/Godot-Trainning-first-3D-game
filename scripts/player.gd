extends CharacterBody3D

@export var speed: int = 14
@export var fall_acceleration: int = 75

var target_velocity: Vector3 = Vector3.ZERO
var direction_input: Vector3 = Vector3.ZERO

func _physics_process(delta):
	Handle_Input()
	Look_At_Direction()
	Set_Velocity(delta)

func Handle_Input() -> void:
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_back"):
		direction.z = 1
	if Input.is_action_pressed("move_forward"):
		direction.z = -1
	
	direction_input = direction.normalized()

func Look_At_Direction() -> void:
	if direction_input != Vector3.ZERO:
		$Pivot.look_at(position + direction_input, Vector3.UP)

func Set_Velocity(delta) -> void:
	target_velocity.x = direction_input.x * speed
	target_velocity.z = direction_input.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()
