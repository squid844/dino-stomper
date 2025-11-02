extends Node3D

@export var sprite_size = Vector2(100.0,100.0)
@export var sprite_resolution = Vector2(640.0,640.0)

@onready var data_manager: Node2D = $"../../DataManager"

@onready var time_dico = data_manager.time_dico
@onready var stomps : int 
@onready var threshold_timer: Timer = $ThresholdTimer


@onready var meteorite: Node3D = $"."
@onready var previous_stomps : int

@onready var pos_x : float
@onready var pos_y : float
@onready var scale_factor : float 
signal update_timer_tag
signal game_over

func _ready() -> void:
	
	await get_tree().process_frame
	time_dico = data_manager.time_dico
	pos_x = data_manager.meteorite_data["pos_x"]
	pos_y = data_manager.meteorite_data["pos_y"]
	scale_factor = data_manager.meteorite_data["scale"]
	
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
	data_manager.save_data()

	if time_dico["crash_timer"] <=0.5:
		threshold_timer.autostart = false
		emit_signal("game_over")


var scale_tween_x : Tween
var scale_tween_y : Tween
	
func update_meteorite_scale():
	if scale_tween_x and scale_tween_x.is_running():
		scale_tween_x.kill()
	if scale_tween_y and scale_tween_y.is_running():
		scale_tween_y.kill()
	scale_tween_x = create_tween()
	scale_tween_y = create_tween()
	
	var t : float = clamp(data_manager.time_dico["crash_timer"] / 60.0, 0.0, 1.0) # Normalise la valeur du timer entre 0 et 1
	scale_tween_x.tween_property(self, "pos_x", 20.0+t*10.0, 1.0)
	scale_tween_y.tween_property(self, "pos_y", 10.0+t*15.0, 1.0)
	scale_factor = clamp(2*(1.0 - t), 1.0, 2.0)
	data_manager.meteorite_data["scale"] = scale_factor
	meteorite.scale = Vector3.ONE * scale_factor
	
	 # Position (descente vers le sol)	
	data_manager.meteorite_data["power_timer"] +=1
	if data_manager.meteorite_data["power_timer"] == 30:
		update_meteorite_power()

func _process(_delta):
	position = Vector3(pos_x,pos_y,5.0)
	data_manager.meteorite_data['pos_x'] = pos_x
	data_manager.meteorite_data['pos_y'] = pos_y

func update_meteorite_power():
	data_manager.time_dico["threshold"] *=10
