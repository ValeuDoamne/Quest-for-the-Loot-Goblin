extends Area2D


func _on_NextLevel_body_entered(_body):
	var current_level = int(get_tree().current_scene.name.split("Level")[1])
	get_tree().change_scene("res://game/src/Levels/level" + str(current_level+1)+ ".tscn")
