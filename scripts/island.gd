extends Node3D

@export  var dino_scene : PackedScene;
@onready var dino_group: Node3D = $DinoGroup

func _on_texture_button_button_down() -> void:
	var  dino = dino_scene.instantiate()
	dino_group.add_child(dino)

func _on_game_island_clicked() -> void:
	var dinos = dino_group.get_children()
	for dino in dinos:
		dino.jump()
