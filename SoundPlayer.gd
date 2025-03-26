extends Node

export(String) var sound_string = ""


func _ready():
	SoundFX.play(sound_string)
