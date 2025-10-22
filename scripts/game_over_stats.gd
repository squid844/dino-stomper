extends VBoxContainer

signal reset_data

@onready var fade_transition: ColorRect = $"../FadeTransition"
@onready var fade_transition_animation_player: AnimationPlayer = $"../FadeTransition/AnimationPlayer"

func _ready() -> void:
	fade_transition_animation_player.play("fade_out")
	$"../DataManager".load_data()
	var dino_stats = $"../DataManager".dino_stats
	var stomps = $"../DataManager".general_data["stomps"]
	$DinoTag.text = "Total Dinos this cycle :
	- Stego :" +str(dino_stats["stego"]["number"]) # !!!
	$StompsTag.text = str(stomps) + " Stomps this cycle"
	
func _on_restart_button_button_down() -> void:
	emit_signal("reset_data")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	



func _on_quit_button_button_down() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	fade_transition.hide()
