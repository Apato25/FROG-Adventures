extends KinematicBody2D

var life := 3
var spd = 100.0
var player_velo = Vector2.ZERO
onready var anim := $player_pos2d/animFrog
onready var lingua := $Lingua

var esta_atacando := false
var se_moveu := false
var current_state := 0
var enter_state := true
enum {parado,andando,atacando}

signal atacando
signal new_life

func _ready():
	emit_signal("new_life", life)

func _physics_process(_delta):
	match current_state:
		parado:
			_parado()
		andando:
			_andando()
		atacando:
			_atacando()
	
	

#-----------------------------------------------

func _parado():
	anim.play("parado")
	
	if player_velo.x:
		$player_pos2d.scale.x = -1 if player_velo.x < 0 else 1
		
	_move()
	_set_state(_check_parado())

func _andando():
	
	var animation = (
		"andando_para_baixo" if _get_direction().y > 0
		else "andando_de_costas" if _get_direction().y < 0
		else "andando_de_frente"
	)
	
	anim.play(animation)
	
	
	if player_velo.x:
		$player_pos2d.scale.x = -1 if player_velo.x < 0 else 1
		
	_move()
	_set_state(_check_andando())

func _atacando():
	var lingua_pos = $Lingua/lingua_normal/pos_lingua
	var mouse_pos = get_local_mouse_position()
	
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
		$player_pos2d.scale.x = -1 if mouse_pos.x < 0 else 1
		lingua.position.x = -3 if mouse_pos.x < 0 else 3
	
	
	Global.can_attack = true
	esta_atacando = true
	_set_state(_check_atacando())

#-----------------------------------------------

func _check_parado():
	var new_state = current_state
	if se_moveu:
		new_state = andando
	elif Input.is_action_pressed("Attack") == true and esta_atacando == false:
		new_state = atacando
		emit_signal("atacando")
	return new_state

func _check_andando():
	var new_state = current_state
	if !se_moveu:
		new_state = parado
	elif Input.is_action_just_pressed("Attack") and esta_atacando == false:
		new_state = atacando
		emit_signal("atacando")
	return new_state

func _check_atacando():
	var new_state = current_state
	if Input.is_action_pressed("Attack") == false and esta_atacando == true:
		new_state = parado
		lingua.z_index = -1
		Global.can_attack = false
		$cooldown_ataque.start()
	return new_state
	
#-----------------------------------------------

func _set_state(new_state): #seleciona o novo estado do peixe
	if new_state != current_state:
		enter_state = true
	current_state = new_state

#-----------------------------------------------

func _get_direction(): #pega a posição que o player vai se mover
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

func _move(): #aplica velocidade no player o fazendo se mover para a direção indicada
	var dir = _get_direction()
	player_velo = lerp(player_velo,dir.normalized() * spd,0.2)
	se_moveu = 1 if dir else 0
	player_velo = move_and_slide(player_velo)


func _on_cooldown_ataque_timeout():
		esta_atacando = false

func _on_area_area_entered(_area):
	hit()

func _on_area_body_entered(_body):
	hit()

func hit():
	$area/shape.set_deferred("disabled", true)
	life = int(max(life-1, 0))
	if !life:
		queue_free()
	emit_signal("new_life", life)
	new_modulate(3)

func new_modulate(seg:float):
	var tween = create_tween()
	var init_seg = seg
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
	yield(get_tree().create_timer(init_seg), "timeout")
	$area/shape.set_deferred("disabled", false)
