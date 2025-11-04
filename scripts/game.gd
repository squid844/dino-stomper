extends Node3D

@export var stego_scene : PackedScene


@onready var general_data = $DataManager.general_data
@onready var perpetual_data = $DataManager.perpetual_data
@onready var base_dino_stats = $DataManager.base_dino_stats
@onready var dino_stats = $DataManager.dino_stats
@onready var data_manager: Node2D = $DataManager


@onready var meteorite: Node3D = $Scenery/Meteorite

@onready var island : Node3D
@onready var dino_group: Node3D

@onready var fade_transition: ColorRect = $ControlLayer/FadeTransition
@onready var fade_transition_animation_player:AnimationPlayer = $ControlLayer/FadeTransition/AnimationPlayer

signal island_clicked
signal stomps_change
signal fruits_change

signal reset_data
signal restart_game


func _ready() -> void:
	fade_transition_animation_player.play("fade_out")
	#data_manager.save_data()
	data_manager.load_data()
	$DataManager.general_data["consumed_stomps"] = $DataManager.general_data["stomps"] - $DataManager.general_data["stomps"] % $DataManager.general_data["stomps_per_fruit"] # used to calculate on much steps needed to update fruit
	
	emit_signal("stomps_change", $DataManager.general_data["stomps"])
	emit_signal("fruits_change", $DataManager.general_data["fruits"])
	
	island = $Scenery/Island
	dino_group = island.dino_group

	instantiate_dinos("stego",$DataManager.general_data["total_dinos"], true)
	update_stomp_rate()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("island_clicked")
			

		 
func update_stomp_rate() -> void:
	var temp_apc = 0
	for dino in $DataManager.dino_stats:
		temp_apc += $DataManager.dino_stats[dino]["number"] * $DataManager.dino_stats[dino]["stomp_per_jump"]#!!!!
	$DataManager.general_data["amount_per_click"] = temp_apc


func _on_island_clicked() -> void:
	$DataManager.general_data["stomps"] += $DataManager.general_data["amount_per_click"]
	emit_signal("stomps_change", $DataManager.general_data["stomps"])
	# logic to increase the number of fruits whenever enough stomps are collected
	if ($DataManager.general_data["stomps"] - $DataManager.general_data["consumed_stomps"] >= $DataManager.general_data["stomps_per_fruit"]):
		$DataManager.general_data["fruits"] += int(($DataManager.general_data["stomps"] - $DataManager.general_data["consumed_stomps"]) / $DataManager.general_data["stomps_per_fruit"])
		$DataManager.general_data["consumed_stomps"] = $DataManager.general_data["stomps"] - $DataManager.general_data["stomps"] % $DataManager.general_data["stomps_per_fruit"]
		
		emit_signal("fruits_change", $DataManager.general_data["fruits"])

func instantiate_dinos(dino_type: String, number_of_dinos: int, init : bool) -> void:
	var spawnPoints = island.spawnPoints
	var dinoScale = island.dinoScale
	# Récupère la variable correspondant à dino_type+"_scene"
	var scene_var_name = dino_type + "_scene"
	var scene_to_instantiate : PackedScene = get(scene_var_name)
	if scene_to_instantiate == null:
		push_error("Scene not found for dino_type: " + dino_type)
		return
	if init:
		for i in range(min(number_of_dinos,len(spawnPoints))):
			var dino = scene_to_instantiate.instantiate()
			dino.scale = dinoScale
			dino.position = spawnPoints[i]
			dino_group.add_child(dino)
	else:
		for i in range(min(number_of_dinos,len(spawnPoints)),len(spawnPoints)):
			var dino = scene_to_instantiate.instantiate()
			dino.scale = dinoScale
			dino.position = spawnPoints[i]
			dino_group.add_child(dino)
		


func _on_meteorite_game_over() -> void:
	# handles the logic of game over actions : hiding stats and buttons and showing game over layout with updated data
	fade_transition.show()
	fade_transition_animation_player.play("fade_in")
	
	data_manager.save_data()
	var game_over_timer: Timer = $ControlLayer/FadeTransition/GameOverTimer
	game_over_timer.start()	

func _on_restart_game() -> void:
	emit_signal("reset_data")
	fade_transition.show() # to rework
	fade_transition_animation_player.play("fade_in")

func _on_game_over_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over_menu.tscn")
	emit_signal("restart_game")
