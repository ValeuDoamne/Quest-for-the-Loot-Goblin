extends Node

export(int) var max_health = 5 setget set_max_health
var health = max_health setget set_health
export(int) var max_stamina = 5 setget set_max_stamina
var stamina = max_stamina setget set_stamina

var stamina_regeneration = 2
var health_regeneration = 0.5

signal no_health
signal health_changed(value)
signal max_health_changed(value)

signal no_stamina
signal stamina_changed(value)
signal max_stamina_changed(value)


func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_stamina(value):
	max_stamina = value
	self.stamina = min(stamina, max_stamina)
	emit_signal("max_stamina_changed", max_stamina)

func set_stamina(value):
	stamina = value
	emit_signal("stamina_changed", stamina)
	if stamina <= 0:
		emit_signal("no_stamina")


func _ready():
	self.health = max_health
	self.stamina = max_stamina
