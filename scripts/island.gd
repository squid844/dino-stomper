extends Node3D

@export var sprite_size = Vector2(70.0,70.0)
@export var sprite_resolution = Vector2(256.0,256.0)

@export  var dino_scene : PackedScene;
@onready var dino_group: Node3D = $DinoGroup

var rotation_speed := 0.0015
var movement_speed := 0.003
var moving_direction := 1.0

var dinoHeight := 1.05 #Supposed to change depending on the dinoScale, must be put in dino script
var dinoScale := Vector3(0.5,0.5,0.5)

@onready var spawnPoints = {
	0: Vector3(0,dinoHeight,0),
	1 : Vector3(-15,dinoHeight,-10),
}		

func _on_game_island_clicked() -> void:
	var dinos = dino_group.get_children()
	for dino in dinos:
		dino.jump()

func _process(delta: float) -> void:
	rotation.y += rotation_speed
	if position.y >= 0.3 or position.y <= -0.3: 
		moving_direction = -moving_direction
	position.y += (1-sqrt((position.y)**2))**2 * movement_speed* moving_direction
	
