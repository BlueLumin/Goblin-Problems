extends CanvasLayer

# MAIN MENU
@onready var main_menu: CanvasLayer = $MainMenu
@onready var play_button: Button = $MainMenu/VBoxContainer/HBoxContainer/PlayButton
@onready var credit_button: Button = $MainMenu/VBoxContainer/HBoxContainer/CreditButton

# CREDITS
@onready var credits: CanvasLayer = $Credits
@onready var back_button: Button = $Credits/MarginContainer/BackButton
@onready var rich_text_label: RichTextLabel = $Credits/TextContainer/VBoxContainer/RichTextLabel

var scene_manager : SceneManager


func _ready() -> void:
	set_credits_active(false)
	set_main_menu_active(true)
	
	GlobalVariables.cut_scene_completed = false
	
	for tutorial in GlobalVariables.tutorials:
		GlobalVariables.tutorials[tutorial]["completed"] = false
	
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	
	MusicManager.change_song(MusicManager.music_playlist["menu"])
	
	play_button.pressed.connect(on_play_button_pressed)
	credit_button.pressed.connect(on_credit_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)


func credits_in():
	set_main_menu_active(false)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(main_menu, "offset:x", 500, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(credits, "offset:x", 0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished
	set_credits_active(true)


func credits_out():
	set_credits_active(false)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(main_menu, "offset:x", 0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(credits, "offset:x", -500, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished
	set_main_menu_active(true)


func set_main_menu_active(active: bool):
	if active:
		play_button.set_disabled(false)
		credit_button.set_disabled(false)
	else:
		play_button.set_disabled(true)
		credit_button.set_disabled(true)


func set_credits_active(active: bool):
	if active:
		back_button.set_disabled(false)
		rich_text_label.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	else:
		back_button.set_disabled(true)
		rich_text_label.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)


func on_back_button_pressed():
	play_button_sound()
	
	credits_out()


func on_play_button_pressed():
	play_button_sound()
	
	scene_manager.request_scene_change("res://scenes/opening_cut_scene/pipe_opening_cut_scene.tscn")


func on_credit_button_pressed():
	play_button_sound()
	
	credits_in()


func play_button_sound():
	MusicManager.play_sound_effect(MusicManager.ui["Click"], 10)
