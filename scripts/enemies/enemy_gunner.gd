extends KinematicBody2D

enum {parado, perseguindo}
var state :int
var target :KinematicBody2D

var velocity :Vector2
export (int) var speed = 30
var attack :bool = true

func _physics_process(_delta):
	match state:
		0:
			pass
		1:
			_perseguindo()

func _perseguindo():
	if target:
		if global_position.distance_to(target.global_position) > 100:
			velocity = global_position.direction_to(target.global_position) * speed
			$state.set_text("Perseguindo")
			$timer.stop()
			attack = true
		elif attack:
			$state.set_text("Parando para atirar")
			velocity = Vector2.ZERO
			$timer.start(2)
			attack = false
	velocity = move_and_slide(velocity)

func _on_area_body_entered(body):
	$area/shape.shape.radius *= 2
	target = body
	state = 1

func _on_area_body_exited(_body):
	$area/shape.shape.radius /= 2
	$state.set_text("Parado")
	target = null
	state = 0

func _on_timer_timeout():
	var bullet = load("res://cenas/traps/bullet.tscn").instance()
	$pos.look_at(target.global_position + Vector2(0,7))
	bullet.global_position = $pos.global_position
	bullet.rotation_degrees = $pos.rotation_degrees
	get_tree().current_scene.add_child(bullet)
