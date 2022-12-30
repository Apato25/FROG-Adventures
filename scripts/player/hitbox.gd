extends Area2D

var time := true
var atk_pos
var atk_pos2

func _ready():
	return get_parent().connect("attack", self, "disabled")

func _on_timer_timeout():
	look_at(get_global_mouse_position())
	
	$shape.shape.extents.x = lerp(
		$shape.shape.extents.x,
		min(
			global_position.distance_to(get_global_mouse_position())/2,
			get_parent().reach/1.90
			),
		1
	)
	$shape.position.x = $shape.shape.extents.x
	$shape.set_disabled(false)
	

func disabled(state):
	if state and time:
		$timer.start(0.02)
		time = false
	elif !state:
		$shape.set_disabled(true)
		$timer.stop()
		time = true

func _on_hitbox_body_entered(body):
	body.hit()
