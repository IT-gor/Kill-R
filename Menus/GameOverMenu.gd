extends CenterContainer

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_LoadButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")
