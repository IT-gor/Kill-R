extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION
export (int) var BULLET_SPEED = 250

# const PlayerBullet = preload("res://Player/PlayerBullet.tscn")
const CannonBall = preload("res://Enemies/CannonBall.tscn")

var state
var idle_bool

onready var sprite = $Sprite
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight
onready var spriteAnimator = $SpriteAnimator
onready var muzzle = $Sprite/Cannon/Sprite/Muzzle
onready var cannon = $Sprite/Cannon
onready var fireBulletTimer = $FireBulletTimer
onready var cannonAnimator = $Sprite/Cannon/AnimationPlayer
onready var player_position = get_node("/root/World/Player").position
onready var already_shot = false

var playernode
var player_dir = 0  # direction
onready var last_player_dir = 0

enum {
	IDLE,
	RUN
}

func _ready():
	state = IDLE
	spriteAnimator.play("Idle")
	idle_bool = true

# warning-ignore:unused_argument
func player_direction():
	""" checks in which direction the player faces relative to the enemy
	returns -1 = left, 1 = right, 0 = equal position.x """
	var direction = int(playernode.global_position.x - self.global_position.x)
	return -1 if direction < -10 else 1 if direction > 10 else 0


func fire_cannonball():
	var cannonball = Utils.instance_scene_on_main(CannonBall, muzzle.global_position)
	cannonball.set_enemy(self)  # setzt sich selbst, damit man die Richtung der Sprite auslesen kann (scale)
	cannonball.set_direction(muzzle.global_position)
	# cannonball.velocity = BULLET_SPEED
	cannonAnimator.play("fire")	
	fireBulletTimer.start()

# warning-ignore:unused_argument
func _physics_process(delta):
	playernode = get_node_or_null("/root/World/Player")
	if playernode:
		player_dir = player_direction()
	else:
		state = IDLE
		player_dir = 0
	# print("state: ", state)
	# print("floorLeft.is_colliding(): ", floorLeft.is_colliding())
	# print("floorRight.is_colliding(): ", floorRight.is_colliding())
	# print("wallLeft.is_colliding(): ", wallLeft.is_colliding())
	# print("wallRight.is_colliding(): ", wallRight.is_colliding())
	match state:
		IDLE:
			motion.x = 0
			if player_dir != last_player_dir and not self.idle_bool:
				state = RUN
				spriteAnimator.play("Run")
		RUN:
			WALKING_DIRECTION = DIRECTION.LEFT if player_dir < 0 else DIRECTION.RIGHT
			sprite.scale.x = sign(motion.x)*-1  # hack, damit Sprite in richtige Richtung läuft
			motion.x = MAX_SPEED if player_dir != 0 else 0.000001
			if player_dir < 0:  # LEFT
				motion.x *= -1
				sprite.scale.x = 1
				
				if not floorLeft.is_colliding() or wallLeft.is_colliding():
					state = IDLE
					# last_player_dir = player_dir
					sprite.scale.x = 1
					spriteAnimator.play("Idle")
			if player_dir > 0:  # RIGHT
				if not floorRight.is_colliding() or wallRight.is_colliding():
					state = IDLE
					# last_player_dir = player_dir
					sprite.scale.x = -1
					spriteAnimator.play("Idle")
			else:
				pass
			if not already_shot:  # hack, damit die erste Kugel nicht nach rechts fliegt...
				already_shot = true
			else:
				if fireBulletTimer.time_left == 0:
					fire_cannonball()
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))
	last_player_dir = player_dir
	if motion.x == 0:
		motion.x = 0.00001

# warning-ignore:unused_argument
func _on_Viewbox_area_entered(area):
	if self.idle_bool:
		self.idle_bool = false
		playernode = get_node_or_null("/root/World/Player")
		WALKING_DIRECTION = DIRECTION.LEFT
		state = RUN
		spriteAnimator.play("Run")
		last_player_dir = player_direction()
