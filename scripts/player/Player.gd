extends KinematicBody2D

var spd = 100.0
var player_velo = Vector2.ZERO
onready var anim := $animFrog

var se_moveu := false
var current_state := 0
var enter_state := true
enum {parado,andando,atacando}

func _physics_process(delta):
	print(player_velo)
	
	match current_state:
		parado:
			_parado()
		andando:
			_andando()
	
	if player_velo.x <= 0:
		$frogSpr.scale.x = 1
	else:
		$frogSpr.scale.x = -1
	
	

#-----------------------------------------------

func _parado():
	anim.play("parado")
	
	_move()
	_set_state(_check_parado())


func _andando():
	if int(player_velo.y) > 0.0:
		anim.play("andando_para_baixo")
	elif int(player_velo.y) < 0.0 :
		anim.play("andando_de_costas")
	elif int(player_velo.y) == 0.0:
		anim.play("andando_de_frente")
	
	_move()
	_set_state(_check_andando())

#-----------------------------------------------

func _check_parado():
	var new_state = current_state
	if se_moveu == true:
		new_state = andando
	return new_state


func _check_andando():
	var new_state = current_state
	if se_moveu == false:
		new_state = parado
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
	player_velo = lerp(player_velo,dir.normalized() * spd, 0.2)
	
	if dir.x != 0 or dir.y != 0:
		se_moveu = true
	else:
		se_moveu = false
	
	move_and_slide(player_velo)
