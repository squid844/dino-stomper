extends VBoxContainer

@onready var stomp_label: Label = $StompLabel

func _on_game_stomps_change(amount) -> void:
	stomp_label.text = str(amount) + " Stomps"
