extends Control


@onready var data_manager: Node2D = $"../DataManager"
var button_type : String

@onready var fade_transition: ColorRect = $FadeTransition

@onready var fade_transition_animation_player: AnimationPlayer = $"FadeTransition/AnimationPlayer"
@onready var fade_timer: Timer = $"FadeTransition/FadeTimer"

func _ready() -> void:
	data_manager.load_data()
	
func _on_start_button_pressed() -> void:
	play_animation("fade_in")
	fade_timer.start()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func play_animation(animation_type)->void:
	fade_transition.show()
	fade_transition_animation_player.play(animation_type)
	
func _on_fade_timer_timeout() -> void:
	if (data_manager.time_dico["crash_timer"] <=1):
		get_tree().change_scene_to_file("res://scenes/game_over_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
