extends Node

@export var mob_scene: PackedScene

func _ready():
	randomize()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation as PathFollow3D
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.Initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
