extends KinematicBody2D

enum {parado, perseguindo}
var state :int
var target :KinematicBody2D

var velocity :Vector2
export (int) var speed = 30
export (int) var life = 3
export (float, 0, 1, 0.05) var time = 1.0 # Tempo de stun
var stun :bool
signal hitted

func _ready():
	emit_signal("hitted", life)

func _physics_process(_delta):
	match state:
		0:
			pass
		1:
			_perseguindo()

func _perseguindo():
	velocity = Vector2.ZERO
	if target and !stun:
		velocity = global_position.direction_to(target.global_position) * speed		
	velocity = move_and_slide(velocity)

func _on_area_body_entered(body):
	$area/shape.shape.radius *= 1.5
	target = body
	state = 1

func _on_area_body_exited(_body):
	$area/shape.shape.radius /= 1.5
	target = null
	state = 0

func hit():
	life = max(life -1, 0)
	emit_signal("hitted", life)
	stun = true
	if !life:
		death()
	else:
		yield(get_tree().create_timer(time), "timeout")
		stun = false


func death():
	queue_free()
