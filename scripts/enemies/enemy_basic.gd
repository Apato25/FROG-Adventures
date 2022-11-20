extends KinematicBody2D

enum {parado, perseguindo}
var state :int
var target :KinematicBody2D

var velocity :Vector2
export (int) var speed = 30

func _physics_process(_delta):
	match state:
		0:
			pass
		1:
			_perseguindo()

func _perseguindo():
	if target:
		velocity = global_position.direction_to(target.global_position) * speed
	velocity = move_and_slide(velocity)

func _on_area_body_entered(body):
	$area/shape.shape.radius *= 1.5
	$state.set_text("Perseguindo")
	target = body
	state = 1

func _on_area_body_exited(_body):
	$area/shape.shape.radius /= 1.5
	$state.set_text("Parado")
	target = null
	state = 0
