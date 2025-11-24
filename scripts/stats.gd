extends VBoxContainer

@onready var stomp_label: Label = $StompLabel
@onready var fruits_label: Label = $FruitsLabel
@onready var timer_label: Label = $TimerLabel
@onready var added_time_label = $AddedTimeLabel


func _on_game_stomps_change(amount) -> void:
	stomp_label.text = str(amount) + " Stomps"

func _on_game_fruits_change(amount) -> void:
	fruits_label.text = str(amount) + " Fruits"

var time_tween: Tween

func _on_data_manager_update_timer_tag(time_left,threshold,added_seconds) -> void:
	timer_label.text = str(time_left) + "s before crash | " + str(threshold) +" stomps per/s to add time"
	added_time_label.text = "+" + str(added_seconds)
	if added_seconds !=0:
		added_time_label.show()
		added_time_label.modulate.a = 0.0
		if time_tween and time_tween.is_running():
			time_tween.kill()
		time_tween = create_tween()
		time_tween.set_trans(Tween.TRANS_SINE)
		time_tween.set_ease(Tween.EASE_IN_OUT)
		
		# Fade in
		time_tween.tween_property(added_time_label, "modulate:a", 1.0, 0.3)
		
		# Petite pause visible
		time_tween.tween_interval(0.4)
		
		# Fade out
		time_tween.tween_property(added_time_label, "modulate:a", 0.0, 0.3)


func on_dino_button_node_fruits_change(amount) -> void:
	fruits_label.text = str(amount) + " Fruits"
