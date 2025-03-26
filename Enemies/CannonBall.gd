# extends "res://Player/Projectile.gd"
extends Node2D

export (int) var SPEED = 100

onready var animationPlayer = $AnimationPlayer
onready var body_entered_bool = false
onready var player_position = Vector2(0,0)

var velocity = Vector2.ZERO
var player_dir_x = -1
var MainInstances = ResourceLoader.MainInstances
var direction = -1  # -1 = left, 0 = right
var direction_setted_up = false
var enemy_scale_x = -1  # -1 = left, 0 = right
var enemy_shot_cannonball

func set_enemy(got_enemy):
	enemy_shot_cannonball = got_enemy

func set_direction(got_position):
	player_dir_x = player_direction_x(got_position)
	direction_setted_up = true

# warning-ignore:unused_argument
func player_direction_x(got_position):
	""" checks in which direction the player faces relative to the enemy
	returns -1 = left, 1 = right, 0 = equal position.x """
	var player = MainInstances.Player
	direction = got_position.x - player.position.x
	
	# checke in welche Richtung die Sprite zeigt
	for child in enemy_shot_cannonball.get_children():
		if child is Sprite:
			if child.scale.x == -1 or child.scale.x == 1:
				enemy_scale_x = child.scale.x
	return -1 if direction > 0 else 1 if direction < 0 else 0

func _ready():
	SoundFX.play("Bullet", rand_range(0.3, 0.6))
	
func _process(delta):
	if not body_entered_bool and direction_setted_up:
		var delta_pos_x = SPEED * delta * player_dir_x
		# checke in welche Richtung die BossEnemy-Sprite zeigt und korrigiere die Richtung des Schusses ggf.
		if (enemy_scale_x == -1 and delta_pos_x < 0 and enemy_scale_x < 0) or (enemy_scale_x == 1 and delta_pos_x > 0 and enemy_scale_x > 0):
			position.x += delta_pos_x * -1
		else:
			position.x += delta_pos_x

# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

# warning-ignore:unused_argument
func _on_Hitbox_body_entered(body):
	body_entered_bool = true
	animationPlayer.play("Explode")
	SoundFX.play("Explosion", rand_range(0.4, 0.6), -20)
	
# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area):
	body_entered_bool = true
	animationPlayer.play("Explode")
	SoundFX.play("Explosion", rand_range(0.4, 0.6), -20 )
