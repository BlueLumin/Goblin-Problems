# Manages the pop-up tutorials.
extends Node
class_name TutorialManager

@onready var tutorial_screen: CanvasLayer = $TutorialScreen
@onready var tutorial_text: Label = $TutorialScreen/TextBoxMarginContainer/TextMarginContainer/TutorialText

var tutorial_showing : bool = false
var current_tutorial : String = ""
var skipable : bool = false

var tutorials : Dictionary = {}


func _ready() -> void:
	tutorials = GlobalVariables.tutorials


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
	
		if tutorial_showing and skipable:
			tween_out()
			
			MusicManager.play_sound_effect(MusicManager.ui["Click"])
			
			skipable = false


func start_tutorial(tutorial: String):
	if has_tutorial_been_completed(tutorial):
		return # If the tutorital has already been completed, do not start tutorial
	
	if tutorial_showing:
		return # Do not run if there is already a tutorial showing
	
	tutorial_showing = true
	skipable = false
	
	pause_game()
	update_tutorial_text(tutorials[tutorial]["tutorial_text"])
	current_tutorial = tutorial
	tween_in()
	
	MusicManager.play_sound_effect(MusicManager.ui["Tutorial"], 5)


func has_tutorial_been_completed(tutorial: String) -> bool:
	return tutorials[tutorial]["completed"]


func update_tutorial_text(text: String):
	tutorial_text.text = text


func tween_in():
	tutorial_screen.offset.y = 200
	
	var tween = create_tween()
	tween.tween_property(tutorial_screen, "offset:y", 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	skipable = true


func tween_out():
	tutorial_screen.offset.y = 0
	
	var tween = create_tween()
	tween.tween_property(tutorial_screen, "offset:y", 200, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	tutorials[current_tutorial]["completed"] = true # Set the current tutorial as completed
	
	tutorial_showing = false
	current_tutorial = ""
	resume_game()


func pause_game():
	get_tree().paused = true


func resume_game():
	get_tree().paused = false
