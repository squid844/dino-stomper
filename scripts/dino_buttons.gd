extends Control


@onready var game: Node3D = $"../../.."
@onready var data_manager: Node2D = $"../../../DataManager"


@export var dino_type : String

@onready var ability_button: TextureButton = $ButtonContainer/AbilityButton
@onready var buy_button: Button = $ButtonContainer/BuyButton
@onready var cost_tag: Label = $ButtonContainer/CostTag
@onready var undiscovered_cost_tag: Label = $ButtonContainer/UndiscoveredCostTag

@onready var dino_button_texture = {
	"stego_n" : preload("uid://eh4qx4qppp8"),
	"stego_p" : preload("uid://dsqjy5bi2aje6"),
	"ptero_n" : preload("uid://0lcd7nhexlnx"),
	"ptero_p" : preload("uid://tdtl31mohp84"),
	"undiscovered" : preload("uid://bhxegpuq568nm")
}

signal fruits_change
signal dino_purchased

func _ready() -> void:
	await(get_tree().process_frame)
	# set the button textures, if undiscovered, cover the buttons
	if data_manager.general_data["dino_unlocked"][dino_type]:
		ability_button.texture_normal = dino_button_texture[dino_type + "_n"]
		ability_button.texture_pressed = dino_button_texture[dino_type + "_p"]
		undiscovered_cost_tag.hide()
		cost_tag.show()
		buy_button.show()
	else : 
		ability_button.texture_normal = dino_button_texture["undiscovered"]
		undiscovered_cost_tag.text = str(data_manager.dino_stats[dino_type]["base_price"] * 10) + " stomps to unlock"
		cost_tag.hide()
		buy_button.hide()
	cost_tag.text = "Cost : " + str(data_manager.dino_stats[dino_type]["current_price"])+" / "+str(data_manager["dino_stats"][dino_type]["number"]) + " "+ dino_type

func _on_buy_button_button_down() -> void:
	if data_manager.general_data["fruits"] >= data_manager.dino_stats[dino_type]["current_price"]:
		data_manager.general_data["fruits"]-=data_manager.dino_stats[dino_type]["current_price"] # update fruits
		data_manager.dino_stats[dino_type]["current_price"] *=2 #update stego price
		data_manager.dino_stats[dino_type]["number"]+=1
		data_manager.general_data["total_dinos"]+=1
		emit_signal("fruits_change", data_manager.general_data["fruits"])
		emit_signal("dino_purchased", data_manager.dino_stats[dino_type]["current_price"], dino_type)
		if data_manager.dino_stats[dino_type]["number"] == 1:
			game.instantiate_dinos(dino_type)
		game.update_stomp_rate()


func _on_dino_purchased(current_price, dino_type) -> void:
	cost_tag.text = "Cost : " + str(current_price) +" / "+str(data_manager["dino_stats"][dino_type]["number"]) + " "+ dino_type


func _on_game_dino_unlocked(_dino) -> void:
	if dino_type == _dino:
		ability_button.texture_normal = dino_button_texture[dino_type + "_n"]
		ability_button.texture_pressed = dino_button_texture[dino_type + "_p"]
		undiscovered_cost_tag.hide()
		cost_tag.show()
		buy_button.show()
