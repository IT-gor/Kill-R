extends Node

func _ready():
	# VisualServer.set_default_clear_color(Color.black)  # background color
	pass


func _on_Player_player_died():
	yield(get_tree().create_timer(1.0), "timeout")  # gibt timer zurück (wie bei return)... macht jedoch weiter nach der Timer-Pause
	get_tree().change_scene("res://Menus/GameOverMenu.tscn")
