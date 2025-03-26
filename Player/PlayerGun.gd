extends Node2D

func _process(delta):
	var player = get_parent()
	# print("player: ", player)
	rotation = player.get_local_mouse_position().angle()
