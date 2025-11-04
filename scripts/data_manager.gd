extends Node2D

const save_path = "user://userdata.save"
signal update_timer_tag
signal reset_data

@onready var general_data ={
	"stomps" : 0,
	"consumed_stomps": 0,
	"fruits" : 0,
	"stomps_per_fruit" : 10,
	"total_dinos" : 1,
	"amount_per_click" : 1,
	
}
@onready var perpetual_data = {
	# les trucs que je veux garder d'un cycle à l'autre
	"dino_souls" : 0,
	"dino_unlocked" : {"stego" : true, "diplo" : false},
}

@onready var base_dino_stats = {
	# [base_price, current_price, number_on_screen]
	"stego" : {"base_price" : 2, "current_price" : 2, "number" : 1, "stomp_per_jump": 1},
	"ptero" : {"base_price" : 1, "current_price" : 1, "number" : 0, "stomp_per_jump": 1},
	
}

@onready var dino_stats = {
	# [base_price, current_price, number_on_screen]
	"stego" : {"base_price" : 2, "current_price" : 2, "number" : 1, "stomp_per_jump": 1},
	"ptero" : {"base_price" : 1, "current_price" : 1, "number" : 0, "stomp_per_jump": 1},
}

@onready var time_dico = {
	"crash_timer" : 60,
	"threshold" : 10
}
@onready var meteorite_data = {
	"pos_x": 30.0,
	"pos_y": 25.0,
	"scale" : 1.0,
	"power_timer" :0
	
}
@onready var previous_stomps : int = general_data["stomps"] - time_dico["threshold"]

func _on_game_over_stats_reset_data() -> void:
	# to rework
	general_data["stomps"] = 0
	general_data["consumed_stomps"] = 0
	general_data["fruits"]= 0
	dino_stats = base_dino_stats
	general_data["amount_per_click"] = 1
	general_data["total_dinos"]= 1
	time_dico = {"crash_timer" : 60,"threshold" : 10}
	meteorite_data = {"pos_x": 30.0, "pos_y": 25.0, "scale" : 1.0,  "power_timer" :0}
	save_data()
	reset_timer_data()
	emit_signal("stomps_change",0)
	emit_signal("fruits_change",0)

func save_data():
	var data = {
		"general_data" : general_data,
		"dino_stats" : dino_stats,
		"time_dico" : time_dico,
		"pepetual_data" : perpetual_data,
		"meteorite_data" : meteorite_data
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			general_data = data.get("general_data",{"stomps" : 0, "consumed_stomps": 0,"fruits" : 0,"stomps_per_fruit" : 10,"total_dinos" : 1, "amount_per_click":1,})
			dino_stats = data.get("dino_stats",{"stego" : {"base_price" : 2, "current_price" : 2, "number" : 1, "stomp_per_jump":1}, "ptero" : {"base_price" : 1, "current_price" : 1, "number" : 0, "stomp_per_jump": 1}})
			time_dico = data.get("time_dico",{"crash_timer" : 60, "threshold" :  10})	
			perpetual_data = data.get("perpetual_data", {"dino_souls" : 0, "dino_unlocked" : {"stego" : true, "diplo" : false},})	
			meteorite_data = data.get("meteorite_data", {"pos_x": 30.0, "pos_y": 25.0, "scale" : 1.0,  "power_timer" :0})	
	else:
		save_data()
		
func reset_timer_data()->void:
	emit_signal("update_timer_tag",time_dico["crash_timer"],time_dico["threshold"],int(general_data["stomps"] - previous_stomps >= time_dico["threshold"])*int((general_data["stomps"] - previous_stomps) / time_dico["threshold"]))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		emit_signal("reset_data")


func _on_reset_data() -> void:
	general_data["stomps"] = 0
	general_data["consumed_stomps"] = 0
	general_data["fruits"]= 0
	general_data["total_dinos"]= 1
	dino_stats = base_dino_stats
	time_dico = {"crash_timer" : 60,"threshold" : 10}
	general_data["amount_per_click"] = 1
	save_data()
	reset_timer_data()
	emit_signal("stomps_change",0)
	emit_signal("fruits_change",0)
