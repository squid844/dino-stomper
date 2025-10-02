extends Node3D

@export var jump_duration := 0.1
@onready var base_height:= position.y
var jump_height := 0.0

func jump():
	var tween = create_tween()
	tween.tween_property(self, "jump_height", 2.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "jump_height", 0.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _process(_delta):
	position.y = base_height + jump_height
