extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION
export (int) var BULLET_SPEED = 250


var state
var idle_bool

onready var sprite = $Sprite
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight
onready var spriteAnimator = $SpriteAnimator
onready var player_position = get_node("/root/World/Player").position
# onready var player_position = get_node("/root/World/Level_00/Player").position

var playernode
var player_dir = 0  # direction
var last_player_dir


enum {
	IDLE,
	RUN
}

func _ready():
	state = IDLE
	spriteAnimator.play("Idle")
	idle_bool = true
	playernode = get_node_or_null("/root/World/Player")
	# playernode = get_node_or_null("/root/World/Level_00/Player")
	

func player_direction():
	""" checks in which direction the player faces relative to the enemy
	returns -1 = left, 1 = right, 0 = equal position.x """
	var direction = self.global_position.x - playernode.global_position.x
	
	# print("direction: ", direction)
	if -2 < direction and direction < 2:
		return 0
	if direction > 1:
		return -1
	else:
		return 1

# warning-ignore:unused_argument
func _physics_process(delta):
	playernode = get_node_or_null("/root/World/Player")
	# playernode = get_node_or_null("/root/World/Level_00/Player")

	if playernode:
		player_dir = player_direction()
	else:
		state = IDLE
		player_dir = 0
	match state:  # switch (but with dynamic data?)
		IDLE:
			motion.x = 0.000001 # bug? with motion.x = 0 the enemy does not spawn
			if player_dir != last_player_dir and not self.idle_bool:
				state = RUN
				spriteAnimator.play("Run")
		RUN:
			WALKING_DIRECTION = DIRECTION.LEFT if player_dir < 0 else DIRECTION.RIGHT
			sprite.scale.x = sign(motion.x)*-1  # hack, damit Sprite in richtige Richtung läuft
			motion.x = MAX_SPEED if player_dir != 0 else 0
			if player_dir != 0:
				if player_dir < 0:  # LEFT
					motion.x *= -1
					if not floorLeft.is_colliding() or wallLeft.is_colliding():
						state = IDLE
						last_player_dir = player_dir
						sprite.scale.x = 1
						spriteAnimator.play("Idle")
				else:
					if not floorRight.is_colliding() or wallRight.is_colliding():
						state = IDLE
						last_player_dir = player_dir
						sprite.scale.x = -1
						spriteAnimator.play("Idle")
					
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))
	# fix disappearing sprite bug! appears when motion.x == 0
	if motion.x == 0:
		motion.x = 0.00001
		spriteAnimator.play("Idle")

# warning-ignore:unused_argument
func _on_Viewbox_area_entered(area):
	if self.idle_bool:
		self.idle_bool = false
		WALKING_DIRECTION = DIRECTION.LEFT
		state = RUN
		spriteAnimator.play("Run")
		last_player_dir = player_direction()

# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area):
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_Hurtbox_area_entered(area):
	pass # Replace with function body.
