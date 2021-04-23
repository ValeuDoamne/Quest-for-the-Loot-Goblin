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
onready var animationState =  animationTree.get("parameters/playback")

var points = [Vector2(80,20), Vector2(69, 69), Vector2(42, 42), Vector2(200, 12), Vector2(200, 100)]
var pointposition = 0

func _ready():
	animationTree.active = true
	for i in range(len(points)):
		points[i] += global_position

func _physics_process(delta):
	if pointposition < len(points):
		move_state(delta, points[pointposition])

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
