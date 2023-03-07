extends Node

@export var mob_scene: PackedScene

func _ready():
	randomize()
	$UserInterface/Retry.hide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate() as Mob
	var mob_spawn_location = $SpawnPath/SpawnLocation as PathFollow3D
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_Squashed.bind())
	mob.Initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)

func _on_player_hit():
	$Timers/MobTimer.stop()
	$UserInterface/Retry.show()
