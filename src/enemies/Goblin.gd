extends KinematicBody2D

enum {IDLE, ATTACK, FOLLOW, DIE}
var state = IDLE
var direction = Vector2.ZERO
var sprite_orientation = "D"
var floating_text = preload("res://ui/floating_text.tscn")
var followed_enemy = null

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
			animatedSprite.play("idle-" + sprite_orientation)
			if (sightRadius.canSeePlayer()):
				state = FOLLOW
		DIE:
			start_dying()
		FOLLOW:
			follow(delta)


func start_dying():
	animatedSprite.play("die-D")


func finish_dying():
	sightRadius.queue_free()
	hurtbox.queue_free()
	shadow.queue_free()
	collision.queue_free()


func follow(delta):
	var enemy_direction = (followed_enemy.global_position - global_position).normalized()
	direction = direction.move_toward(
		enemy_direction * stats.MAX_SPEED, 
		delta * stats.ACCELERATION
	)
	print(self.name, direction, enemy_direction, stats.speed())
	direction = move_and_slide(direction)


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
		if body.global_position.y > self.global_position.y:
			sprite_orientation = "U"
		else:
			sprite_orientation = "D"
		if body.global_position.x > self.global_position.x:
			sprite_orientation = "R"
		else:
			sprite_orientation = "L"
		followed_enemy = body
		state = FOLLOW


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation.begins_with('die'):
		finish_dying()
