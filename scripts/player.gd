extends CharacterBody3D

signal hit

@export var speed: int = 14
@export var fall_acceleration: int = 75
@export var jump_impulse: int = 20
@export var bounce_impulse: int = 16

var target_velocity: Vector3 = Vector3.ZERO
var direction_input: Vector3 = Vector3.ZERO

func _physics_process(delta):
	Handle_Input()
	Look_At_Direction()
	Jump()
	Bounce()
	Set_Animation()
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

func Jump() -> void:
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse

func Bounce() -> void:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		
		if (collision.get_collider() as Node).is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.Squash()
				target_velocity.y = bounce_impulse

func Set_Animation() -> void:
	if direction_input != Vector3.ZERO:
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func Set_Velocity(delta) -> void:
	target_velocity.x = direction_input.x * speed
	target_velocity.z = direction_input.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()

func Die() -> void:
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	Die()
