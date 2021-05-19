extends PopupDialog

var npc_name setget name_set
var dialogue setget dialogue_set
var npc = null
var end = 0
onready var continueDialogue = $ColorRect/ContinueDialogue

func _ready():
	set_process_input(false)

func _input(event):
	if event is InputEventKey:
		if npc.playerDetect.can_see_player() or npc.intro:
			if event.is_action_released("ui_select"):
				set_process_input(false)
				npc.talk()
			elif event.is_action_released("attack"):
				set_process_input(false)
				close()
				
func name_set(new_value):
	npc_name = new_value
	$ColorRect/NPCName.text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$ColorRect/Dialogue.text = new_value

func dialogue_play():
	continueDialogue.visible = false
	if dialogue.length() != 0:
		$AnimationPlayer.playback_speed = 60.0 / dialogue.length()
		$AnimationPlayer.play("Load Dialogue")

func set_and_play(new_value = ""):
	npc.dialogue_state += 1
	dialogue_set(new_value)
	dialogue_play()

func last_dialogue_set_and_play(new_value = ""):
	end = 1
	npc.dialogue_state += 1
	dialogue_set(new_value)
	dialogue_play()

func open():
	continueDialogue.visible = false
	get_tree().paused = true
	popup()
		

func close():
	continueDialogue.visible = false
	get_tree().paused = false
	hide()
	set_process_input(false)

func _on_AnimationPlayer_animation_finished(_anim_name):
	continueDialogue.visible = true
	set_process_input(true)

