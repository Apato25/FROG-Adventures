extends KinematicBody2D

var death_particle = preload("res://cenas/mechanics/paticles_death.tscn")
onready var de_part = $death_particle_pos

enum {parado, perseguindo,morto}
var state :int
var target :KinematicBody2D
onready var anim = $slugAnim

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
			anim.play("idle")
		1:
			anim.play("walk")
			_perseguindo()
		2:
			pass
		
	if velocity.x:
		$slug_spr.scale.x = -1 if velocity.x < 0 else 1
	if velocity.x:
		$reflection_spr.scale.x = -1 if velocity.x < 0 else 1

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
	var particDead = death_particle.instance()
	particDead.emitting = true
	particDead.set_position(de_part.get_position())
	de_part.add_child(particDead)
	
	$area.set_deferred("disabled", true)
	$shape.set_deferred("disabled", true)
	$slug_spr.visible = false
	$reflection_spr.visible = false
	
	$death_cooldown.start()
	state = 2


func _on_death_cooldown_timeout():
	queue_free()
