extends Node2D

var selected_menu = 0

var music = ['mus_menu0.ogg', 'mus_menu1.ogg', 'mus_menu2.ogg', 'mus_menu3.ogg', 'mus_menu4.ogg', 'mus_menu5.ogg', 'mus_menu6.ogg']

onready var Continue = $ColorRect/Continue/Label
onready var NewGame = $ColorRect/NewGame/Label
onready var Quit = $ColorRect/Quit/Label
onready var audioStream = $AudioStreamPlayer

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
	randomize()
	music.shuffle()
	var menu_music = load("res://Music and Sounds/menu_music/"+music[0])
	menu_music.set_loop(true)
	audioStream.stream = menu_music
	audioStream.play(0)
	change_menu_color()

func _input(_event):
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 3;
		change_menu_color()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 2
		change_menu_color()
	elif Input.is_action_just_pressed("ui_select"):
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
