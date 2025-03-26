extends KinematicBody2D

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats
onready var scoreLabel = get_node("/root/World/UI/Score/ScoreLabel")
onready var spriteAnim = $SpriteAnimator

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	scoreLabel.add_score(stats.score)
	SoundFX.play("EnemyDie", rand_range(0.9, 1.1), -15)
	queue_free()

# warning-ignore:unused_argument
func _on_Hurtbox_area_entered(area):
	pass
