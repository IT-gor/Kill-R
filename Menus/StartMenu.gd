extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.dimgray)
	pass # Replace with function body.


func _on_StartButton_pressed():
	SoundFX.play("Click", 1, -30)
	get_tree().change_scene("res://World/World.tscn")


func _on_LoadButton_pressed():
	SoundFX.play("Click", 1, -30)
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
