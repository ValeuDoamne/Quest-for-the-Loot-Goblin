extends Node2D


onready var gooby = $YSort/Gooby
onready var lamp = $Position2D
onready var navigation = $Nav
onready var firstfinal = $PlayerDetectionZone
onready var stream = $AudioStreamPlayer
var gooby_dialogue = {
	0 : [
		"Hello there, traveler. ",
		"It`s a me, Gooby, the friendly italian slime.",
		"Oh, so you are the silent type.",
		"So, lets start the tutorial...",
		"To exit forced from a conversation press [X], but not from this one",
		"To attack press [X] and to interact with things press [Z]",
		"To do a Tokio Drift Barrel Roll press [C]",
		"To exit this roasting looking game press [Esc]",
		"Please follow me...",
		"xxmovexx"
	], 
	1 : [
		"You can save your game to a lamppost by pressing [Z].",
		"You are still a weirdo, tbh",
		"Why are you interacting with me again if you are not gonna say anything."
	],
	2 : [
	"Damn, the person playing this must not be the brightest.",
	"Oh, you didn`t know you are in a game?"
	],
	3 : [
	"You got two options at the moment.",
	"You can go left and let Fruld win.",
	"Or you can go right and beat that living creature while is still alive."
	]
}

func _ready():
	stream.play(0)
	gooby.dialogue = gooby_dialogue
	gooby.points = navigation.get_simple_path(gooby.global_position, lamp.global_position)

func _process(_delta):
	if firstfinal.can_see_player():
		get_tree().change_scene("res://game/src/Levels/Ending1.tscn")
