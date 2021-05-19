extends Control

var health = 5 setget set_health
var max_health = 5 setget set_max_health
var stamina = 5 setget set_stamina
var max_stamina = 5 setget set_max_stamina


onready var healthbar = $HealthBar/Health
onready var staminabar = $StaminaBar/Stamina


func set_health(value):
	health = clamp(value, 0, max_health)
	if healthbar != null:
		healthbar.rect_size.x = 72 * health / max_health

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	if healthbar != null:
		healthbar.rect_size.x = 72 * health / max_health


func set_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	if staminabar != null:
		staminabar.rect_size.x = 72 * stamina / max_stamina

func set_max_stamina(value):
	max_stamina = max(value, 1)
	self.stamina = min(stamina, max_stamina)
	if staminabar != null:
		staminabar.rect_size.x = 72 * stamina / max_stamina

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	self.max_stamina = PlayerStats.max_stamina
	self.stamina = PlayerStats.stamina
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")
	PlayerStats.connect("stamina_changed", self, "set_stamina")
	PlayerStats.connect("max_stamina_changed", self, "set_max_stamina")
