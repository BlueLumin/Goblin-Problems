extends CanvasLayer

@onready var background_colour: ColorRect = $BackgroundColour
@onready var lose_screen: MarginContainer = $LoseScreen
@onready var win_screen: MarginContainer = $WinScreen

# WIN SCREEN
@onready var goblin_label: Label = $WinScreen/VBoxContainer/GoblinContainer/HBoxContainer/GoblinLabel
@onready var shiny_label: Label = $WinScreen/VBoxContainer/ShinyContainer/HBoxContainer/ShinyLabel
@onready var win_replay_button: Button = $WinScreen/VBoxContainer/ButtonContainer/HBoxContainer/WinReplayButton
@onready var win_menu_button: Button = $WinScreen/VBoxContainer/ButtonContainer/HBoxContainer/WinMenuButton


# LOSE SCREEN
@onready var lose_retry_button: Button = $LoseScreen/VBoxContainer/MarginContainer/HBoxContainer/LoseRetryButton
@onready var lose_menu_button: Button = $LoseScreen/VBoxContainer/MarginContainer/HBoxContainer/LoseMenuButton

var current_state: String = "lose"

var scene_manager : SceneManager

func _ready() -> void:
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	
	match current_state:
		"win":
			win_state()
		"lose":
			lose_state()


func win_state():
	background_colour.set_color(Color("#f6e8cd"))
	win_screen.visible = true
	lose_screen.visible = false
	
	shiny_label.text = "You found " + str(GlobalVariables.shinies_collected) + " of " + str(GlobalVariables.total_shinies) + " shinies!"
	
	if GlobalVariables.goblins_left == 0:
		goblin_label.text = "You got rid of all the goblins in your yard!"
	elif GlobalVariables.goblins_left == 1:
		goblin_label.text = "You left 1 goblin in your yard!"
	elif GlobalVariables.goblins_left > 1:
		goblin_label.text = "You left " + str(GlobalVariables.goblins_left) + " goblins in your yard!"
	
	# Connect Buttons
	if scene_manager == null:
		push_warning(self, " cannot locate the SceneManager.")
		return
	
	win_replay_button.pressed.connect(on_replay_button_pressed)
	win_menu_button.pressed.connect(on_menu_button_pressed)


func lose_state():
	background_colour.set_color(Color("#060e17"))
	win_screen.visible = false
	lose_screen.visible = true
	
	# Connect Buttons
	if scene_manager == null:
		push_warning(self, " cannot locate the SceneManager.")
		return
	
	lose_retry_button.pressed.connect(on_replay_button_pressed)
	lose_menu_button.pressed.connect(on_menu_button_pressed)


func on_replay_button_pressed():
	MusicManager.play_sound_effect(MusicManager.ui["Click"])
	
	scene_manager.request_scene_change("res://scenes/world/world.tscn")


func on_menu_button_pressed():
	MusicManager.play_sound_effect(MusicManager.ui["Click"])
	
	scene_manager.request_scene_change("res://ui/menu/game_menu.tscn")
