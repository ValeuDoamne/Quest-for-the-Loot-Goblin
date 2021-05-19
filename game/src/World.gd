extends Node2D

onready var navigation = $Nav
onready var gooby = $YSort/Gooby
onready var tar = $Target

func _ready():
	gooby.points = navigation.get_simple_path(gooby.global_position, tar.global_position)
	
