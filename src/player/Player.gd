extends KinematicBody2D

const MAX_SPEED = 400
const ACCELERATION = 800
const FRICTION = 1200

enum {MOVE, ATTACK}

var velocity = Vector2.ZERO
var state = MOVE
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/walk/blend_position", input_vector)
		animationTree.set("parameters/hit/blend_position", input_vector)
		animationState.travel("walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state(delta):
	animationState.travel("hit")
	
	print("hit: ", animationState.get("parameters/hit/blend_position"))
	print("move: ", animationState.get("parameters/walk/blend_position"))
	
func finish_attack_animation():
	state = MOVE
	
