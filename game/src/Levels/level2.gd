extends Node2D

onready var pierre = $YSort/Pierre
onready var stream = $AudioStreamPlayer

var pierre_dialogue = {
	0:[
	"Welcome to my little shop, traveler.",
	"Are you gonna buy anything, or are you just gonna sit there doing nothing?",
	"Ok. Then GET OUT!"
	],
	1 : [
		"Well, now you just want to get on my nerves.",
		"MERDE!"
	],
	2 : [
		"..."
	],
	3 :[
		"This is a rushed game don't expect more chat",
		"The programmer was really tired when he made me."
	]
}

func _ready():
	stream.play(0)
	pierre.dialogue = pierre_dialogue
