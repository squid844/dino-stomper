extends VBoxContainer

@onready var cost_tag: Label = $StegoButton/CostTag

func _ready() -> void:
	await(get_tree().process_frame)
	cost_tag.text = "Cost : " + str($"../../DataManager".dino_stats["stego"]["current_price"])
	
func _on_game_stego_purchased(current_price) -> void:
	cost_tag.text = "Cost : " + str(current_price)
	
