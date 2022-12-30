extends Area2D

func _ready():
	return get_parent().connect("attack", self, "disabled")

func disabled(state):
	$shape.shape.segments = [] if !state else $shape.shape.segments
	$shape.set_disabled(!state)
	print($shape.disabled)

func _on_area_body_entered(body):
	print(body)
	body.hit()
