extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
const ROLLSPEED = 125 

enum {
	MOVE,
#	ROLL,
	ATTACK
}


var state = MOVE

var velocity = Vector2.ZERO
var rollvector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState =  animationTree.get("parameters/playback")
onready var blinkAnimation =  $BlinkAnimation
onready var swordHitBox = $HitboxPivot/SwordHibox
onready var hurtBox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "end")
	animationTree.active = true
	swordHitBox.knockback_vector = rollvector

func end():
	queue_free()
	get_tree().change_scene("res://game/src/Menus/GameOver/GameOver.tscn")


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		rollvector = input_vector
		swordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	blinkAnimation.play("Start")
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect(area)
	#sleep(5)
	blinkAnimation.play("Stop")
