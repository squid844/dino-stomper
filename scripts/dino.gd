class_name dino extends Node3D


@export var jump_duration := 0.1
@onready var base_height:= position.y
@onready var jump_flag := false
var jump_height := 0.0
var shortest_jump_counter := 0
var jump_tween : Tween
func jump():
	if not jump_flag:
		jump_flag = true
		if jump_tween and jump_tween.is_running():
			jump_tween.kill()
		jump_tween = create_tween()
		jump_tween.tween_property(self, "jump_height", 2.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		jump_tween.tween_property(self, "jump_height", 0.0, jump_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _process(_delta):
	shortest_jump_counter +=1
	if shortest_jump_counter >= 30:
		jump_flag = false
		shortest_jump_counter = 0
	position.y = base_height + jump_height
	
