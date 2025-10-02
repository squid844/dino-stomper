extends Node3D

@onready var dino = $Dino;

func _on_game_island_clicked() -> void:
	dino.jump()
