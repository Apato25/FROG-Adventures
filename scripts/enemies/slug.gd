extends KinematicBody2D

var death_particle = preload("res://cenas/mechanics/paticles_death.tscn")
onready var de_part = $death_particle_pos

enum {parado, perseguindo,morto}
var state :int
var target
onready var anim = $slugAnim

var velocity :Vector2
export (int) var speed = 30
export (int) var life = 3
export (float, 0, 1, 0.05) var time = 1.0 # Tempo de stun
var stun :bool

export var size = 1
signal hitted
signal died

func _ready():
	emit_signal("hitted", life)
	target = Global.flower.get_node("flower_area") if Global.flower else null
	state = perseguindo

func _physics_process(_delta):
	match state:
		parado:
			_parado()
		perseguindo:
			_perseguindo()
		morto:
			pass
		
	if velocity.x:
		$slug_spr.scale.x = -1 if velocity.x < 0 else 1
	if velocity.x:
		$reflection_spr.scale.x = -1 if velocity.x < 0 else 1
	velocity = move_and_slide(velocity * speed)

func _parado():
	anim.play("idle")
	velocity = Vector2.ZERO

func _perseguindo():
	anim.play("walk")
	velocity = Vector2.ZERO
	if target and !stun:
		velocity = global_position.direction_to(target.global_position-Vector2(0,15))

func hit():
	life = max(life -1, 0)
	emit_signal("hitted", life)
	stun = true
	if !life:
		velocity = Vector2()
		death()
	else:
		get_node("slug_spr").modulate = Color(255, 255, 255)
		yield(get_tree().create_timer(time), "timeout")
		stun = false
		get_node("slug_spr").modulate = Color(1,1,1)

func death():
	var particDead = death_particle.instance()
	particDead.emitting = true
	particDead.set_position(de_part.get_position())
	de_part.add_child(particDead)
	
	emit_signal("died", size)
	$area/shape.set_deferred("disabled", true)
	$shape.set_deferred("disabled", true)
	$slug_spr.visible = false
	$reflection_spr.visible = false
	$death_cooldown.start()
	state = morto

func _on_death_cooldown_timeout():
	queue_free()


func _on_area_area_entered(area):
	if area.name == "flower_area":
		state = parado
