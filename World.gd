extends Node2D


func _ready():
	
	var audioStream = $AudioStreamPlayer
	audioStream.play(0)
