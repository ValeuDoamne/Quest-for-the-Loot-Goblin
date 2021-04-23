extends Node2D

var selected_menu = 0

onready var TryAgain = $TryAgain
onready var Quit = $Quit
onready var backgroundStream = $Music
onready var menumusicStream = $MenuMusicSelect

func change_menu_color():
	TryAgain.set("custom_colors/font_color", Color.white)
	Quit.set("custom_colors/font_color", Color.white)
	
	match selected_menu:
		0:
			TryAgain.set("custom_colors/font_color", Color.red)
		1:
			Quit.set("custom_colors/font_color", Color.red)

func _ready():
	backgroundStream.play(0)
	change_menu_color()

func _input(_event):
	change_menu_color()
	if Input.is_action_just_pressed("ui_right"):
		menumusicStream.play(0)
		selected_menu = (selected_menu + 1) % 2
		change_menu_color()
		
	elif Input.is_action_just_pressed("ui_left"):
		menumusicStream.play(0)
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 1
	elif Input.is_action_just_pressed("ui_select"):
		var musicSelect = load("res://game/assets/music_and_sounds/menu/Menu Select.wav")
		menumusicStream.stream  = musicSelect
		menumusicStream.play(0)
		match selected_menu:
			0:
				PlayerStats.health = PlayerStats.max_health
				get_tree().change_scene("res://game/src/World.tscn")
			1:
				# Quit game
				get_tree().quit()
