extends Node3D

@export var jump_duration := 0.1
@onready var base_height:= position.y
var jump_height := 0.0

var jump_tween : Tween
func jump():
	if jump_tween and jump_tween.is_running():
		jump_tween.kill()
	jump_tween = create_tween()
	jump_tween.tween_property(self, "jump_height", 2.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	jump_tween.tween_property(self, "jump_height", 0.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _process(_delta):
	position.y = base_height + jump_height
