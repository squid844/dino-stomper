extends Control


@onready var game: Node3D = $"../../.."
@onready var data_manager: Node2D = $"../../../DataManager"

@onready var cost_tag: Label = $ButtonContainer/CostTag
@export var dino_type : String

signal stomps_change
signal fruits_change
signal dino_purchased

func _ready() -> void:
	await(get_tree().process_frame)
	cost_tag.text = "Cost : " + str(data_manager.dino_stats["stego"]["current_price"])

func _on_buy_button_button_down() -> void:
	if data_manager.general_data["fruits"] >= data_manager.dino_stats[dino_type]["current_price"]:
		data_manager.general_data["fruits"]-=data_manager.dino_stats[dino_type]["current_price"] # update fruits
		data_manager.dino_stats[dino_type]["current_price"] *=2 #update stego price
		data_manager.dino_stats[dino_type]["number"]+=1
		data_manager.general_data["total_dinos"]+=1
		emit_signal("fruits_change", data_manager.general_data["fruits"])
		emit_signal("dino_purchased", data_manager.dino_stats[dino_type]["current_price"])
		game.instantiate_dinos(dino_type,1,false)
		game.update_stomp_rate()


func _on_dino_purchased(current_price) -> void:
	cost_tag.text = "Cost : " + str(current_price)
