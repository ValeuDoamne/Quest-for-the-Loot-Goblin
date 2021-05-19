extends StaticBody2D


onready var playerDetect = $PlayerDetectionZone
onready var popupDialog = $CanvasLayer/PopupDialog

var dialogue_state = 0

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func _physics_process(_delta):
	if playerDetect.can_see_player() and Input.is_action_just_pressed("ui_select"):
		save_game()
		talk()


func talk():
	popupDialog.npc = self
	popupDialog.name_set("Lamp")
	popupDialog.open()
	match dialogue_state:
		0:
			popupDialog.last_dialogue_set_and_play("Your game is saved.")
		1:
			dialogue_state = 0
			popupDialog.close()
