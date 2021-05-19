extends Node2D

onready var popupDialog = $CanvasLayer/PopupDialog
onready var playerDetect = $PlayerDetectionZone
var dialogue_state = 0
var intro = true

func _ready():
	popupDialog.npc = self
	talk()
	
var dialogue = [
	"You let the Goblin win",
	"How pitiful",
	"GG",
	"I hope you are proud of yourself",
	"""                     
		Art Developer and Story Writer:
			Taranu Claudiu-Mihai
		Lead Programmer and QA Tester:
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
			
