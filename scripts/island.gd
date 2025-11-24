extends Node3D

@export var sprite_size = Vector2(100.0,100.0)
@export var sprite_resolution = Vector2(256.0,256.0)

@export  var dino_scene : PackedScene;
@onready var dino_group: Node3D = $DinoGroup


var movement_speed := 0.006
var moving_theta := 0.0
@onready var gpu_particles_3d: GPUParticles3D = $island/GPUParticles3D


var dinoScale := Vector3(0.5,0.5,0.5)

@onready var spawnPoints = {
	"stego": Vector3(-15,1.05,-10),
	"ptero" : Vector3(5,17,10),
}		

func _on_game_island_clicked() -> void:
	var dinos = dino_group.get_children()
	for dino in dinos:
		dino.jump()

func _process(_delta: float) -> void:
	moving_theta += 0.02
	if moving_theta >= 360:
		moving_theta = 0
	position.y += sin(moving_theta)/100
	
