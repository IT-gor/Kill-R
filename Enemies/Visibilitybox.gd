extends Area2D


func _on_Visibilitybox_area_entered(viewbox):
	viewbox.emit_signal("view")
