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

func load_game():
	var scene = null
	var instance = null
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for i in save_nodes:
		i.queue_free()
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
	  # Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		#print(node_data["parent"])
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		scene = load(node_data["scene"])
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		instance = scene.instance()
		instance.get_node(node_data["parent"].split('/')[-1]).add_child(new_object)
		
		get_tree().change_scene(node_data["scene"])
		save_game.close()
	
	


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
				load_game()
			1:
				# Quit game
				get_tree().quit()
