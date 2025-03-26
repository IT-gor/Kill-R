extends KinematicBody2D

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats
onready var scoreLabel = get_node("/root/World/UI/Score/ScoreLabel")


func _on_Hurtbox_hit(damage):
	print("Enemy: _on_Hurtbox_hit")
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	print("_on_EnemyStats_enemy_died")
	scoreLabel.add_score()
	queue_free()


func _on_Hurtbox_area_entered(area):
	# print("Enemy: _on_Hurtbox_area_entered")
	pass

#func _on_Viewbox_area_entered(area):
#	print("VIIIEW: Enemy: _on_Viewbox_area_entered")
#	
