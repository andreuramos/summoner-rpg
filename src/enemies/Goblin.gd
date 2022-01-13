extends KinematicBody2D

enum {IDLE, MOVE, ATTACK, DIE}
var state = IDLE
var direction = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite
onready var sightRadius = $sight_radius
onready var hurtbox = $hurtbox
onready var shadow = $shadow
onready var collision = $CollisionShape2D

func _ready():
	state = IDLE

func _process(delta):
	match state:
		IDLE:
			animatedSprite.play("idle-D")
		MOVE:
			move()
		DIE:
			start_dying()

func move():
	pass

func start_dying():
	animatedSprite.play("die-D")

func finish_dying():
	sightRadius.queue_free()
	hurtbox.queue_free()
	shadow.queue_free()
	collision.queue_free()

func _on_hurtbox_area_entered(area):
	state = DIE


func _on_sight_radius_body_entered(body):
	if body.name == "Player": # or an ally
		print("found you bitch at ", body.position.x, " ", body.position.y)


func _on_AnimatedSprite_animation_finished():
	if (animatedSprite.animation == 'die-D'):
		finish_dying()
