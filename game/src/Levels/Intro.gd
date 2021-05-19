extends Node2D

onready var popupDialog = $CanvasLayer/PopupDialog
onready var stream = $AudioStreamPlayer
onready var playerDetect = $PlayerDetectionZone
var dialogue_state = 0
var intro = true

func _ready():
	stream.playing = 1
	stream.play(0)
	popupDialog.npc = self
	talk()
	
var dialogue = [
	"Far, far away, in a land where no human had set foot, there was a kingdom. Wrokong was its name. This kingdom was populated by many strange creatures, from orcs, to slimes, and even vampires, but its main residents were the goblins, a powerful species of green people that dominated these lands. They were weaker than orcs, but where they lacked in power, they made up in numbers. ",
	"Sadly, one year a horrible drought had hit the kingdom and killed all the crops. Slowly but surely they ran out of food and had to resort to killing the other creatures in order to survive, but even this wasn't enough so in the end they perished.",
	"Centuries later a group of travelers came across the ruins of what once was Wrokong and decided to bring more people there to start a new life. Years later, the new community was thriving, but something wasn't right. Every other week people would dissapear without a trace. No one knew why or how, and none dared to find out. Untill, one day, a brave hero grabbed his sword and ventured to find out what was happening. ",
	"YOU ARE THAT HERO",
	"AND THIS IS YOUR STORY",
	"P.S. Interact with the slimeball by pressing [Z] to give you the tutorial"
]

func talk():
	popupDialog.npc = self
	popupDialog.name_set("")
	popupDialog.open()
	get_tree().paused = false
	if dialogue_state > 2:
		$CanvasLayer/PopupDialog/ColorRect/Dialogue.valign = Label.VALIGN_CENTER
		$CanvasLayer/PopupDialog/ColorRect/Dialogue.align = Label.ALIGN_CENTER
	if dialogue_state < len(dialogue):
		popupDialog.set_and_play(dialogue[dialogue_state])
	else:
		popupDialog.close()
		get_tree().change_scene("res://game/src/Levels/level1.tscn")
			
