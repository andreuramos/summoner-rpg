extends KinematicBody2D

enum {IDLE, MOVE, ATTACK, DIE}
var state = IDLE
var direction = Vector2.ZERO
var floating_text = preload("res://ui/floating_text.tscn")

onready var animatedSprite = $AnimatedSprite
onready var sightRadius = $sight_radius
onready var hurtbox = $hurtbox
onready var shadow = $shadow
onready var collision = $CollisionShape2D
onready var stats = $stats

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
	var attacker = area.find_parent("Player")
	if attacker == null:
		return
		
	if attacker.has_node("stats"):
		var text = floating_text.instance()
		text.position.y -= 50
		var attacker_stats = attacker.get_node("stats")
		if attacker_stats.hit(stats):
			var damage = attacker_stats.damage(stats)
			stats.health -= damage
			text.content = damage
			print(self.name, "/", stats.health, "/", stats.max_health)
		else:
			text.content = "MISS"
		add_child(text)
		print(self.global_position, text.global_position)
		if stats.health <= 0:
			state = DIE


func _on_sight_radius_body_entered(body):
	if body.name == "Player": # or an ally
		print("found you bitch at ", body.position.x, " ", body.position.y)


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation.begins_with('die'):
		finish_dying()
