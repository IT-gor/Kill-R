extends Label

# var EnemyStats = ResourceLoader.EnemyStats
onready var score = 0

# Called when the node enters the scene tree for the first time.


func add_score():
	score += 1
	self.text = "Score: " + str(score)

