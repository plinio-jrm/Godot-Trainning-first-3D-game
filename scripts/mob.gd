extends CharacterBody3D

@export var min_speed: int = 10
@export var max_speed: int = 18

func _physics_process(delta):
	move_and_slide()

func Initialize(start_position, player_position) -> void:
	Set_Rotation(start_position, player_position)
	Set_Movement()

func Set_Rotation(start_position, player_position) -> void:
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))

func Set_Movement() -> void:
	var random_speed: int = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
