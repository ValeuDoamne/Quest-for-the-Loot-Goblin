extends Node2D

onready var popupDialog = $CanvasLayer/PopupDialog
onready var playerDetect = $PlayerDetectionZone
var dialogue_state = 0
var intro = true

func _ready():
	popupDialog.npc = self
	talk()
	
var dialogue = [
	"You did Well",
	"Hope you liked it",
	"GG",
	"We hope that you will have a nice day fren",
	"""  CTO of Redpilled: 
			Taranu Claudiu-Mihai
			CEO of Based:
			Alexa Constantin-Cosmin     
	"""
]

func talk():
	popupDialog.npc = self
	popupDialog.name_set("")
	popupDialog.open()
	
	
	$CanvasLayer/PopupDialog/ColorRect/Dialogue.valign = Label.VALIGN_CENTER
	$CanvasLayer/PopupDialog/ColorRect/Dialogue.align = Label.ALIGN_CENTER
	if dialogue_state < len(dialogue):
		popupDialog.set_and_play(dialogue[dialogue_state])
	else:
		popupDialog.close()
		get_tree().quit()
			
