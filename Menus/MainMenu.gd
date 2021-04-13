extends Node2D

var selected_menu = 0

onready var Continue = $ColorRect/Continue/Label
onready var NewGame = $ColorRect/NewGame/Label
onready var Quit = $ColorRect/Quit/Label
onready var backgroundStream = $BackGroundMusic
onready var menumusicStream = $MenuSelectMusic

func change_menu_color():
	Continue.set("custom_colors/font_color", Color.white)
	NewGame.set("custom_colors/font_color", Color.white)
	Quit.set("custom_colors/font_color", Color.white)
	
	match selected_menu:
		0:
			Continue.set("custom_colors/font_color", Color.green)
		1:	
			NewGame.set("custom_colors/font_color", Color.green)
		2:
			Quit.set("custom_colors/font_color", Color.green)

func _ready():
	backgroundStream.play(0)
	change_menu_color()

func _input(_event):
	change_menu_color()
	if Input.is_action_just_pressed("ui_down"):
		menumusicStream.play(0)
		selected_menu = (selected_menu + 1) % 3;
		change_menu_color()
		
	elif Input.is_action_just_pressed("ui_up"):
		menumusicStream.play(0)
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 2
	elif Input.is_action_just_pressed("ui_select"):
		var musicSelect = load("res://Music and Sounds/Menu Select.wav")
		menumusicStream.stream  = musicSelect
		menumusicStream.play(0)
		match selected_menu:
			0:
				# Continue game
				pass
			1:
				# New game
				get_tree().change_scene("res://World.tscn")
			2:
				# Quit game
				get_tree().quit()
