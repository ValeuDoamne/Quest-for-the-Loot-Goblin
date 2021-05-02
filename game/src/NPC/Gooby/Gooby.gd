extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
const ROLLSPEED = 125 

var velocity = Vector2.ZERO
var rollvector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var popupDialog = $CanvasLayer/PopupDialog
onready var animationState =  animationTree.get("parameters/playback")
onready var playerDetect = $PlayerDetectionZone

var points = [Vector2(80,20), Vector2(69, 69)] #Vector2(42, 42), Vector2(200, 12), Vector2(200, 100)]
var pointposition = 0
var player
var dialogue_state = 0

enum {FirstChat, SecondChat}

var chat = FirstChat

func _ready():
	popupDialog.name_set(get_tree().current_scene.name)
	animationTree.active = true
	for i in range(len(points)):
		points[i] += global_position

func _input(event):
	if event is InputEventKey:
		pass
			
	
func _physics_process(delta):
	if playerDetect.can_see_player() and Input.is_action_just_pressed("ui_select"):
		set_process_input(false)
		talk()
		


func move_state(delta, point):
	var direction = global_position.direction_to(point)
	if abs(global_position.x - point.x) > 5 or abs(global_position.y - point.y) > 5:
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Move/blend_position", direction)
		animationState.travel("Move")
		velocity = velocity.move_toward(direction*MAX_SPEED, ACCELERATION*delta)
	else:
		pointposition += 1
		#pointposition %= len(points)
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

var dialogue = {
	FirstChat : [
		"Hello there, traveller.",
		"I am Gooby, the very friendly slime with italian accent",
		"I really love spaghetti <3",
		"Goodbye!",
		"1337"
	],
	SecondChat:
	[
		"Get out of here, stupid!"	
	]
	
}

func talk():
	popupDialog.npc = self
	popupDialog.name_set("Gooby")
	popupDialog.open()
	
	match chat:
		FirstChat:
			match dialogue_state:
				0:
					popupDialog.set_and_play(dialogue[chat][dialogue_state])
				1:
					popupDialog.set_and_play(dialogue[chat][dialogue_state])
					
				2:
					popupDialog.set_and_play(dialogue[chat][dialogue_state])
				3:
					popupDialog.set_and_play(dialogue[chat][dialogue_state])
				4:
					dialogue_state = 0
					chat = SecondChat 
					popupDialog.close()
					
		SecondChat:
			match dialogue_state:
				0:
					dialogue_state = 0
					popupDialog.set_and_play(dialogue[chat][dialogue_state])
				1:
					dialogue_state = 0
					popupDialog.close()
