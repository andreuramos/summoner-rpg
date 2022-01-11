extends KinematicBody2D

enum {IDLE, MOVE, ATTACK}
var state = IDLE
var direction = Vector2.ZERO

func _process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			move(delta)

func move(delta):
	pass

