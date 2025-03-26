extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION

var state
var idle_bool

onready var sprite = $Sprite
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight
onready var spriteAnimator = $SpriteAnimator
# onready var player_position = get_node("/root/World3/Player").position
onready var player = get_node("/root/World3/Player")

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
	playernode = get_node_or_null("/root/World3/Player")

# func player_direction(player_position):
func player_direction(player):
	if not player:
		return 0
	var player_position = player.position
	""" checks in which direction the player faces relative to the enemy
	returns -1 = left, 1 = right, 0 = equal position.x """
	var direction = self.position.x - player_position.x
	return -1 if direction > 0 else 1 if direction < 0 else 0


func _physics_process(delta):
	playernode = get_node_or_null("/root/World3/Player")
	if playernode:
		# player_dir = player_direction(playernode.position)
		player_dir = player_direction(playernode)
	else:
		state = IDLE
		player_dir = 0
		
	match state:  # switch (but with dynamic data?)
		IDLE:
			motion.x = 0.000000000001  # bug? with motion.x = 0 the enemy does not spawn
			if player_dir != last_player_dir and not self.idle_bool:
				state = RUN
				spriteAnimator.play("Run")
		RUN:
			WALKING_DIRECTION = DIRECTION.LEFT if player_dir < 0 else DIRECTION.RIGHT
			if player_dir < 0:  # LEFT
				motion.x = MAX_SPEED * -1
				if not floorLeft.is_colliding() or wallLeft.is_colliding():
					state = IDLE
					last_player_dir = player_dir
					spriteAnimator.play("Idle")
			else:
				motion.x = MAX_SPEED
				if not floorRight.is_colliding() or wallRight.is_colliding():
					state = IDLE
					last_player_dir = player_dir
					spriteAnimator.play("Idle")
					
	# sprite.scale.x = ... * -1 --> hack, damit die Animation in die richtige Richtung abläuft
	sprite.scale.x = sign(motion.x)*-1  # just the sign of the movements +/-
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))


func _on_Viewbox_area_entered(area):
	if self.idle_bool:
		self.idle_bool = false
		WALKING_DIRECTION = DIRECTION.LEFT
		state = RUN
		spriteAnimator.play("Run")
		# last_player_dir = player_direction(playernode.position)
		last_player_dir = player_direction(playernode)
