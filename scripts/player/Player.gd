extends KinematicBody2D

var death_particle = preload("res://cenas/mechanics/paticles_death.tscn")
onready var de_part = $death_part_pos

var hitted := true
var life := 3
var spd = 100.0
var player_velo = Vector2.ZERO
var attack_vec = Vector2.ZERO
var mobile_vec = Vector2.ZERO
onready var anim := $player_pos2d/animFrog
onready var lingua := $Lingua

var esta_atacando := false
var se_moveu := false
var current_state := 0
var enter_state := true
var input_atk :bool
var is_attack :bool
enum {parado,andando,atacando,morte}

signal atacando
signal new_life
signal died

func _ready():
	invunerable(3)
	emit_signal("new_life", life)
	return connect("died", Global.flower, "revive")

func _physics_process(_delta):
	if OS.has_touchscreen_ui_hint():
		input_atk = Global.is_atk
	else:
		input_atk = Input.is_action_pressed("Attack")
		
	if input_atk:
		is_attack = true
	else:
		is_attack = false
	
	match current_state:
		parado:
			_parado()
		andando:
			_andando()
		atacando:
			_atacando()
		morte:
			_morreu()

	print("botao esta "+ str(is_attack))
	print("atacando esta "+ str(is_attack))


#-----------------------------------------------

func _parado():
	anim.play("parado")
	
	if player_velo.x:
		$player_pos2d.scale.x = -1 if player_velo.x < 0 else 1
		
	_move()
	_set_state(_check_parado())

func _andando():
	var animation
	if OS.has_touchscreen_ui_hint():
		
		if _get_direction().y > 0:
			animation = "andando_para_baixo"
		else:
			animation = "andando_de_costas" 
		if _get_direction().x > 0.50 or _get_direction().x < -0.50:
			animation = "andando_de_frente"
		
	else:
		animation = (
		"andando_para_baixo" if _get_direction().y > 0 else "andando_de_costas" 
		if _get_direction().y < 0 else "andando_de_frente")
	
	
	anim.play(animation)
	
	
	if player_velo.x:
		$player_pos2d.scale.x = -1 if player_velo.x < 0 else 1
		
	_move()
	_set_state(_check_andando())

func _atacando():
	var lingua_pos = $Lingua/lingua_normal/pos_lingua
	var atk_pos 
	if OS.has_touchscreen_ui_hint():
		atk_pos = attack_vec
	else:
		atk_pos = get_local_mouse_position()
	
	if lingua_pos.position.y > 0 and lingua_pos.position.x < 30 and lingua_pos.position.x > -30:
		anim.play("atacando_para_baixo")
		lingua.z_index = 1
		
	elif lingua_pos.position.y < 0:
		anim.play("atacando_para_cima")
		lingua.z_index = 0

	elif lingua_pos.position.y > 0 and lingua_pos.position.x > 30 or lingua_pos.position.y > 0 and lingua_pos.position.x < -30:
		anim.play("atacando_para_frente")
		lingua.z_index = 1
	
#	print(lingua_pos.position.x)
	if lingua_pos.position.x:
		$player_pos2d.scale.x = -1 if atk_pos.x < 0 else 1
		lingua.position.x = -3 if atk_pos.x < 0 else 3
	
	
	Global.can_attack = true
	esta_atacando = true
	_set_state(_check_atacando())

func _morreu():

	$colisaoFrog.set_deferred("disabled", true)
	$player_pos2d/area.set_deferred("disabled", true)
	$player_pos2d.visible = false
	$Lingua.visible = false
	$hearth.visible = false
	
#-----------------------------------------------

func _check_parado():
	var new_state = current_state
	if se_moveu:
		new_state = andando
	elif is_attack == true and esta_atacando == false:
		new_state = atacando
		emit_signal("atacando")
	elif !life:
		new_state = morte
	return new_state

func _check_andando():
	var new_state = current_state
	if !se_moveu:
		new_state = parado
	elif is_attack and esta_atacando == false:
		new_state = atacando
		emit_signal("atacando")
	elif !life:
		new_state = morte
	return new_state

func _check_atacando():
	var new_state = current_state
	if is_attack == false and esta_atacando == true:
		new_state = parado
		lingua.z_index = -1
		Global.can_attack = false
		$cooldown_ataque.start()
	elif !life:
		new_state = morte
	return new_state

#-----------------------------------------------

func _set_state(new_state): #seleciona o novo estado do peixe
	if new_state != current_state:
		enter_state = true
	current_state = new_state

#-----------------------------------------------

func _get_direction(): #pega a posição que o player vai se mover
	if OS.has_touchscreen_ui_hint():
		return Vector2(mobile_vec)
	else:
		return Vector2(
				Input.get_axis("ui_left", "ui_right"),
				Input.get_axis("ui_up", "ui_down")
			)

func _move(): #aplica velocidade no player o fazendo se mover para a direção indicada
	var dir
	dir = _get_direction()
	player_velo = lerp(player_velo,dir.normalized() * spd,0.2)
	
	
	se_moveu = 1 if dir else 0
	player_velo = move_and_slide(player_velo)
	global_position.x = clamp(global_position.x, 10, get_viewport_rect().size.x -10)
	global_position.y = clamp(global_position.y, 10, get_viewport_rect().size.y -10)

func _on_cooldown_ataque_timeout():
		esta_atacando = false

func _on_area_area_entered(_area):
	hit()

func _on_area_body_entered(_body):
	hit()

func hit():
	if hitted:
		return
	hitted = true
	life = int(max(life-1, 0))
	if !life:
		death_part()
		$death_cooldown.start()
		Global.new_song(load("res://songs/sfx/Drop.mp3"))
	else:
		Global.new_song(load("res://songs/sfx/Eat.mp3"))
		emit_signal("new_life", life)
		invunerable(3)

func invunerable(seg:float):
	$player_pos2d/area/shape.set_deferred("disabled", true)
	var tween = create_tween()
	while seg >=0:
		tween.tween_property($player_pos2d, "modulate:a", 0.0, 0.25)
		tween.parallel().tween_property($Lingua, "modulate:a", 0.0, 0.25)
		tween.tween_property($player_pos2d, "modulate:a", 1.0, 0.25)
		tween.parallel().tween_property($Lingua, "modulate:a", 1.0, 0.25)
		seg -= 0.5
		if seg <= 1.0:
			while seg >= 0:
				tween.tween_property($player_pos2d, "modulate:a", 0.0, 0.125)
				tween.parallel().tween_property($Lingua, "modulate:a", 0.0, 0.125)
				tween.tween_property($player_pos2d, "modulate:a", 1.0, 0.125)
				tween.parallel().tween_property($Lingua, "modulate:a", 1.0, 0.125)
				seg -= 0.25
	yield(tween, "finished")
	hitted = !true
	$player_pos2d/area/shape.set_deferred("disabled", false)

func death_part():
	var particDead = death_particle.instance()
	particDead.emitting = true
	particDead.set_position(de_part.get_position())
	de_part.add_child(particDead)

func _on_death_cooldown_timeout():
	emit_signal("died")
	queue_free()

func _on_mobile_joystick_use_move_vector(move_vector):
	mobile_vec = move_vector


func _on_mobile_joystick_use_move_attack(move_attack_vec):
	Global.atk_mobile_pos = move_attack_vec
	attack_vec = move_attack_vec
