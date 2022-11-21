extends KinematicBody2D

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
	var lingua_pos = $Lingua/pos_lingua
	var mouse_pos = get_local_mouse_position()
	
	if lingua_pos.position.y > 0 and lingua_pos.position.x < 30:
		anim.play("atacando_para_baixo")
		lingua.z_index = 1
		
	elif lingua_pos.position.y < 0:
		anim.play("atacando_para_cima")
		lingua.z_index = -1
		
	elif lingua_pos.position.y > 0 and lingua_pos.position.x > 30:
		anim.play("atacando_para_frente")
		lingua.z_index = 1
		
	
	if lingua_pos.position.x:
		$player_pos2d.scale.x = -1 if mouse_pos.x < 0 else 1
		$Lingua.position.x = -3 if mouse_pos.x < 0 else 3
	
	
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
