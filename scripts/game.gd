extends Node3D

const save_path = "user://userdata.save"

var stomps = 0
var amount_per_click = 1

signal island_clicked
signal stomps_change

func _ready() -> void:
	load_data()
	emit_signal("stomps_change", stomps)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("island_clicked")
		
func save_data():
	var data = {
		"stomps" : stomps,
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
			stomps = data.get("stomps", 0)
	else:
		save_data()

func _on_island_clicked() -> void:
	stomps += amount_per_click
	emit_signal("stomps_change", stomps)
	save_data()
