extends VBoxContainer

@export var resolution_option: OptionButton
@export var fullscreen_check: CheckBox
@export var borderless_check: CheckBox
@export var vsync_check: CheckBox

# Liste des résolutions proposées (tu peux en ajouter)
var resolutions = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1280, 720),
	Vector2i(854, 480),
	Vector2i(640, 360)
]

func _ready():
	# Remplit la liste déroulante avec les résolutions
	for res in resolutions:
		resolution_option.add_item("%dx%d" % [res.x, res.y])

	# Charge les réglages actuels (fenêtre ou plein écran)
	load_current_settings()

	# Connecte les signaux
	resolution_option.item_selected.connect(_on_resolution_selected)

	

func load_current_settings():
	# Récupère les infos actuelles de la fenêtre
	var mode = DisplayServer.window_get_mode()
	# Sélectionne la bonne résolution dans le menu
	var window_size = DisplayServer.window_get_size()
	for i in range(resolution_option.item_count):
		var parts = resolution_option.get_item_text(i).split("x")
		if parts.size() == 2 and int(parts[0]) == window_size.x and int(parts[1]) == window_size.y:
			resolution_option.select(i)
			break


func _on_resolution_selected(index: int):
	var text = resolution_option.get_item_text(index)
	var parts = text.split("x")
	if parts.size() != 2:
		return

	var new_size = Vector2i(int(parts[0]), int(parts[1]))

	# --- 🧠 Partie clé inspirée de la doc "Multiple Resolutions" ---
	# On ne touche PAS au viewport virtuel.
	# On garde le stretch_mode=viewport et aspect=keep (dans les Project Settings)
	# => Le rendu interne reste basé sur la résolution de base du projet
	# => Le moteur fait lui-même le "scale" propre et garde les proportions

	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(new_size)

	# Pour que le tiler (Hyprland) ne "coince" pas la fenêtre dans un coin
	# On recentre la fenêtre sur l’écran principal
	var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	var centered_pos = Vector2i(
		(screen_size.x - new_size.x) / 2,
		(screen_size.y - new_size.y) / 2
	)
	DisplayServer.window_set_position(centered_pos)




func _on_borderless_toggled(pressed: bool):
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, pressed)
