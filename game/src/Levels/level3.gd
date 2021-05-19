extends Node2D


onready var goblin = $YSort/Goblin
onready var lamp = $Position2D
onready var secondfinal = $PlayerDetectionZone
onready var stream = $AudioStreamPlayer

var goblin_dialogue = {
	0 : [
	"A human?! I can`t believe one of you finally found me.",
	"I hope you didn't killed all the bats from the previous level!",
	"So you are just gonna sit there and don`t say anything?",
	"Look, I know how this is gonna go. You are gonna start telling me how I kidnapped someone close to you, bla bla bla,..",
	 "... and then you are just gonna kill me and I can`t do anything about it because you are the protagonist in this game.",
	"So why don`t we just reach an agreement?",
	"I give you back all the things I stole and tell you where the people i kidnapped are, and you just let me get away.",
	"Perfect!"
	],
	1 : 
	[
		"What do you want? You already finished the game, get out of here!"
	],
	2 :
	[
		"Just go on the right!"
	]
}

func _ready():
	stream.play(0)
	goblin.dialogue = goblin_dialogue

func _process(_delta):
	
	if secondfinal.can_see_player():
		get_tree().change_scene("res://game/src/Levels/Ending2.tscn")
