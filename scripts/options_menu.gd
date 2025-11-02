extends Control

@onready var video_button: Button = $Settings/Intermediate/VideoButton
@onready var audio_button: Button = $Settings/Intermediate2/AudioButton
@onready var languages_button: Button = $Settings/Intermediate3/LanguagesButton
@onready var quit_button: Button = $Settings/Intermediate4/QuitButton

@onready var video: VBoxContainer = $Video
@onready var resolution_handler: HBoxContainer = $Video/ResolutionHandler

@onready var status : String = "options" # to orientate back button
@onready var threshold_timer: Timer = $"../Scenery/Meteorite/ThresholdTimer"

func _on_button_button_down() -> void:
	$".".show()
	threshold_timer.stop()

func _on_video_button_button_down() -> void:
	hide_buttons()
	status = "video"
	video.show()
	
func _on_audio_button_button_down() -> void:
	hide_buttons()
	status = "audio"
	#audio.show()


func _on_languages_button_button_down() -> void:
	hide_buttons()
	status = "languages"
	#languages.show()

func _on_back_button_button_down() -> void:
	if status == "options":
		$".".hide()
		threshold_timer.start()
	else:
		if status == "video":
			video.hide()
		elif status == "audio":
			#audio.hide()
			pass
		elif status == "languages":
			#languages.hide()	
			pass
		status = "options"
		show_buttons()

func hide_buttons()-> void:
	video_button.hide()
	audio_button.hide()
	languages_button.hide()
	quit_button.hide()
	
func show_buttons()-> void:
	video_button.show()
	audio_button.show()
	languages_button.show()
	quit_button.show()


func _on_quit_button_button_down() -> void:
	get_tree().quit()
