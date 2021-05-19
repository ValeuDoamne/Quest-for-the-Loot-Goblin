extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
const ROLLSPEED = 125 

enum {
	MOVE,
	ROLL,
	ATTACK
}


var state = MOVE

var velocity = Vector2.ZERO
var rollvector = Vector2.LEFT
var stats = PlayerStats
var lockedstamina = false


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState =  animationTree.get("parameters/playback")
onready var blinkAnimation =  $BlinkAnimation
onready var swordHitBox = $HitboxPivot/SwordHibox
onready var hurtBox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "die")
	stats.connect("no_stamina", self, "stamina_end")
	animationTree.active = true
	swordHitBox.knockback_vector = rollvector

func die():
	queue_free()
	get_tree().change_scene("res://game/src/Menus/GameOver/GameOver.tscn")

func stamina_end():
	lockedstamina = true

func _physics_process(delta):
	regenerate(delta)
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func regenerate(delta):
	var new_stamina = min(stats.stamina + stats.stamina_regeneration * delta, stats.max_stamina)
	if new_stamina != stats.stamina:
		stats.set_stamina(new_stamina)
		if stats.stamina >= 1:
			lockedstamina = false

	var new_health = min(stats.health + stats.health_regeneration * delta, stats.max_health)
	if new_health != stats.health:
		stats.set_health(new_health)



func move_state(delta):
	hurtBox.monitoring = true
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		rollvector = input_vector
		swordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	
	if Input.is_action_just_pressed("attack") and not lockedstamina:
		stats.stamina -= 2.5
		state = ATTACK
	elif Input.is_action_just_pressed("roll") and not lockedstamina:
		stats.stamina -= 2
		state = ROLL
	elif Input.is_action_just_pressed("ui_exit"):
		get_tree().quit()

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	hurtBox.monitoring = false
	velocity = rollvector * MAX_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE


func _on_Hurtbox_area_entered(area):
	blinkAnimation.play("Start")
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect(area)
	#sleep(5)

func _on_BlinkAnimation_animation_finished(anim_name):
	if anim_name == "Start":
		blinkAnimation.play("Stop")



func save():
	var save_dict = {
		"filename" : get_filename(),
		"scene" : get_tree().current_scene.get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict
