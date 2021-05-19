extends StaticBody2D

onready var popupDialog = $CanvasLayer/PopupDialog
onready var playerDetect = $PlayerDetectionZone

func _ready():
	popupDialog.name_set(get_tree().current_scene.name)
	
func _physics_process(delta):
	if playerDetect.can_see_player() and Input.is_action_just_pressed("ui_select"):
		set_process_input(false)
		talk()
	
var dialogue = null
var dialogue_state = 0
var chat = 0

func talk():
	popupDialog.npc = self
	popupDialog.name_set("Pierre")
	
	
	if dialogue == null:
		print("error: no dialogue")
	
	if chat < len(dialogue):
		popupDialog.open()
		if len(dialogue[chat]) <= dialogue_state:
			dialogue_state = 0
			chat += 1
			popupDialog.close()
		else:
			popupDialog.set_and_play(dialogue[chat][dialogue_state])
