extends KinematicBody2D

var death_particle = preload("res://cenas/mechanics/paticles_death.tscn")
onready var de_part = $death_particle_pos

enum {parado, perseguindo, morto}
var state :int
var target :KinematicBody2D

var velocity :Vector2
export (int) var speed = 30
export (int) var life = 3
var attack :bool = true
export (float, 0, 1, 0.05) var time = 1.0 # Tempo de stun
var stun :bool
signal hitted
onready var anim = $anim_enemy_gunner

func _physics_process(_delta):
	print(state)
	match state:
		0:
			pass
		1:
			_perseguindo()
		
	if velocity.x:
		$enemy_spr.scale.x = 1 if velocity.x < 0 else -1

func _perseguindo():
	if target:
		if global_position.distance_to(target.global_position) > 100:
			anim.play("idle")
			velocity = global_position.direction_to(target.global_position) * speed
			$timer.stop()
			attack = true
		elif attack:
			anim.play("attack_charge")
			
		
	velocity = move_and_slide(velocity)

func _on_area_body_entered(body):
	$area/shape.shape.radius *= 2
	target = body
	state = 1

func _on_area_body_exited(_body):
	$area/shape.shape.radius /= 2
	target = null
	state = 0

func _on_timer_timeout():
	if !target or stun:
		return
	var bullet = load("res://cenas/traps/bullet.tscn").instance()
	$pos.look_at(target.global_position + Vector2(0,7))
	bullet.global_position = $pos.global_position
	bullet.rotation_degrees = $pos.rotation_degrees
	get_tree().current_scene.add_child(bullet)

func hit():
	life = max(life -1, 0)
	emit_signal("hitted", life)
	stun = true
	if !life:
		death()
	else:
		yield(get_tree().create_timer(time) , "timeout")
		stun = false

func death():
	var particDead = death_particle.instance()
	particDead.emitting = true
	particDead.set_position(de_part.get_position())
	de_part.add_child(particDead)
	
	$area.set_deferred("disabled", true)
	$shape.set_deferred("disabled", true)
	$enemy_spr.visible = false
	$reflection_spr.visible = false
	
	
	$death_cooldown.start()
	

	state = 2




func _on_anim_enemy_gunner_animation_finished(anim_name):
	anim.play("attack")
	velocity = Vector2.ZERO
	$timer.start(2)
	attack = false


func _on_death_cooldown_timeout():
	queue_free()
