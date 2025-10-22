extends Node3D

@export var sprite_size = Vector2(100.0,100.0)
@export var sprite_resolution = Vector2(1280.0,1280.0)

@onready var data_manager: Node2D = $"../../DataManager"

@onready var time_dico = data_manager.time_dico
@onready var stomps : int 
@onready var threshold_timer: Timer = $ThresholdTimer


@onready var meteorite: Node3D = $"."
@onready var previous_stomps : int
var msr : float # meteorite scale ratio
var power_cpt := 0 # a changer
var power_cap = [10,100,1000] # a changer
signal update_timer_tag
signal game_over

func _ready() -> void:
	await get_tree().process_frame
	time_dico = data_manager.time_dico
	
	stomps = data_manager.general_data["stomps"] #initialize stomps values for correct timer calculus
	previous_stomps = data_manager.general_data["stomps"]
	emit_signal("update_timer_tag",time_dico["crash_timer"],time_dico["threshold"],0) # update time stats at game launch
	update_meteorite_scale()
	
func _on_threshold_timer_timeout() -> void:

	# every seccond, update the crash timer and the related tags, checks if game over
	time_dico = data_manager.time_dico
	previous_stomps = stomps
	stomps = data_manager.general_data["stomps"]
	data_manager.time_dico["crash_timer"] += int(stomps - previous_stomps >= time_dico["threshold"])*int((stomps - previous_stomps) / time_dico["threshold"]) - 1
	emit_signal("update_timer_tag",data_manager.time_dico["crash_timer"],data_manager.time_dico["threshold"],int(stomps - previous_stomps >= data_manager.time_dico["threshold"])*int((stomps - previous_stomps) / data_manager.time_dico["threshold"]))
	update_meteorite_scale()
	if data_manager.time_dico["crash_timer"] <=0.5:
		threshold_timer.autostart = false
		emit_signal("game_over")

var scale_tween: Tween
func update_meteorite_scale():
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()
	time_dico = data_manager.time_dico
	var msr = 60.0 / float(time_dico["crash_timer"])
	var target_scale = Vector3(msr, msr, msr)
	scale_tween = create_tween()
	scale_tween.tween_property(meteorite, "scale", target_scale, 1.0)
	
	power_cpt +=1
	if power_cpt == power_cap[0]:
		update_meteorite_power()

func update_meteorite_power():
	time_dico["threshold"] *=10
