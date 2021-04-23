extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 6

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderControler = $WanderControler

enum{
	IDLE,
	WANDER,
	CHASE,
}

var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER])


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
			seek_player()
			
			if wanderControler.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderControler.get_time_left() == 0:
				update_wander()

			accelerate_towards_point(wanderControler.targe_position, delta)

			if global_position.distance_to(wanderControler.targe_position) <= WANDER_TARGET_RANGE:
				update_wander()

		CHASE:
			
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)			
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderControler.start_wander_timer(rand_range(1,3))

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector  * FRICTION
	hurtBox.create_hit_effect(area)
	
const EnemyDeathEffect = preload("res://game/src/Effects/EnemyDeathEffect.tscn")

func create_death_effect():
	
	var deathEffect = EnemyDeathEffect.instance()
	var world = get_tree().current_scene
	world.add_child(deathEffect)
	
	deathEffect.global_position = global_position
	
	queue_free()
	
func _on_Stats_no_health():
	queue_free()
	create_death_effect()
