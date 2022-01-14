extends Area2D

var player = null

func _on_sight_radius_body_entered(body):
	if body.name == "Player":
		player = body


func _on_sight_radius_body_exited(body):
	player = null


func canSeePlayer():
	return player != null
