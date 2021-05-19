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

var points = [] #[Vector2(80,20), Vector2(69, 69), Vector2(42, 42), Vector2(200, 12), Vector2(200, 100)]
var pointposition = 0
var itsmovingtime = false
var player


func _ready():
	animationTree.active = true
	
func _physics_process(delta):
	if playerDetect.can_see_player() and Input.is_action_just_pressed("ui_select"):
		set_process_input(false)
		talk()
	
	if pointposition < len(points) and itsmovingtime:
		move_state(delta, points[pointposition])
	elif pointposition == len(points):
		itsmovingtime = false
		pointposition = 0
		points = []
	


func move_state(delta, point):
	var direction = global_position.direction_to(point)
	if direction != Vector2.ZERO and abs(global_position.x - point.x) > 5 or abs(global_position.y - point.y) > 5:
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Move/blend_position", direction)
		animationState.travel("Move")
		velocity = velocity.move_toward(direction*MAX_SPEED, ACCELERATION*delta)
	else:
		animationState.travel("Idle")
		pointposition += 1
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

var dialogue = null
var dialogue_state = 0
var chat = 0

func talk():
	popupDialog.npc = self
	popupDialog.name_set("Goblin")
	
	
	if dialogue == null:
		print("error: no dialogue")
	
	if chat < len(dialogue):
		popupDialog.open()
		#get_tree().paused = false
		if len(dialogue[chat]) <= dialogue_state:
			dialogue_state = 0
			chat += 1
			popupDialog.close()
		elif dialogue[chat][dialogue_state] == "xxmovexx":
			dialogue_state = 0
			chat += 1
			popupDialog.close()
			itsmovingtime = true
		else:
			popupDialog.set_and_play(dialogue[chat][dialogue_state])
