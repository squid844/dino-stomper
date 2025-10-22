extends Control

var button_type : String
@onready var fade_transition: ColorRect = $"../FadeTransition"
@onready var fade_transition_animation_player: AnimationPlayer = $"../FadeTransition/AnimationPlayer"
@onready var fade_timer: Timer = $"../FadeTransition/FadeTimer"

func _on_start_button_pressed() -> void:
	play_animation("fade_in")
	fade_timer.start()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func play_animation(animation_type)->void:
	fade_transition.show()
	fade_transition_animation_player.play(animation_type)
	
func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
