extends Position2D

onready var label = $Label
onready var tween = $Tween
var content = ""

func _ready():
	label.set_text(str(content))
	tween.interpolate_property(
		self,
		"position",
		position,
		Vector2(position.x, position.y - 10),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.start()


func _on_Tween_tween_all_completed():
	self.queue_free()
