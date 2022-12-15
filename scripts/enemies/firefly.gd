extends KinematicBody2D

var death_particle = preload("res://cenas/mechanics/paticles_death.tscn")
onready var de_part = $death_particle_pos
onready var anim = $anim_enemy_gunner


enum {perseguindo, morto}
var state :int
var target

var velocity :Vector2
export (int) var speed = 30
export (int) var life = 3
var attack := true
export (float, 0, 0.5, 0.05) var time = 0.5
var stun :bool

export (int) var size = 1
signal hitted
signal died

export (Color) var color = Color(255,255,255)
var arr :Array

func _ready():
	target = Global.flower
	modulate = color
	for h in $cannons.get_children():
		arr.append(h.rotation_degrees)

func _physics_process(_delta):
	match state:
		perseguindo:
			_perseguindo()
		morto:
			pass
		
	if velocity.x:
		$enemy_spr.scale.x = 1 if velocity.x < 0 else -1
	elif target:
		$enemy_spr.scale.x = 1 if target.global_position.x < global_position.x else -1
	if velocity.x:
		$reflection_spr.scale.x = 1 if velocity.x < 0 else -1

func _perseguindo():
	if target:
		if global_position.distance_to(target.global_position) > 100:
			anim.play("idle")
			velocity = lerp(velocity,global_position.direction_to(target.global_position) * speed,0.1)
			$timer.stop()
			attack = true
		elif attack:
			velocity = lerp(velocity, Vector2.ZERO, 0.1)
			anim.play("attack_charge")
			
	velocity = move_and_slide(velocity)

func _on_area_body_entered(body):
	$area/shape.shape.radius *= 2
	target = body

func _on_area_body_exited(_body):
	$area/shape.shape.radius /= 2
	target = Global.flower

func _on_timer_timeout():
	if !target or stun:
		return
	
	var new_target = Vector2(0,-4) if target == Global.flower else Vector2(0,7)
	var rot = 0
	for h in $cannons.get_children():
		var bullet = load("res://cenas/traps/bullet.tscn").instance()
		h.look_at(target.global_position + new_target)
		h.rotation_degrees += arr[rot]
		
		bullet.global_position = h.global_position
		bullet.rotation_degrees = h.rotation_degrees
		
		rot +=1
		get_tree().current_scene.add_child(bullet)
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Power Hit.mp3"))

func hit():
	life = max(life -1, 0)
	emit_signal("hitted", life)
	stun = true
	if !life:
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Item Get.mp3"))
		velocity = Vector2()
		death()
	else:
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Charge 3.mp3"))
		get_node("enemy_spr").modulate = Color(255,255,255)
		yield(get_tree().create_timer(time) , "timeout")
		stun = false
		get_node("enemy_spr").modulate = color

func death():
	var particDead = death_particle.instance()
	particDead.emitting = true
	particDead.set_position(de_part.get_position())
	de_part.add_child(particDead)
	
	emit_signal("died", size)
	$timer.stop()
	$area.set_deferred("disabled", true)
	$shape.set_deferred("disabled", true)
	$enemy_spr.visible = false
	$reflection_spr.visible = false
	
	$death_cooldown.start()
	state = morto

func _on_anim_enemy_gunner_animation_finished(_anim_name):
	anim.play("attack")
	velocity = Vector2.ZERO
	$timer.start(2)
	attack = false

func _on_death_cooldown_timeout():
	queue_free()
