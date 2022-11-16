extends KinematicBody2D

var spd = 100.0
var player_velo = Vector2.ZERO
onready var anim := $animFrog

var se_moveu := false
var current_state := 0
var enter_state := true
enum {parado,andando,atacando}

func _physics_process(_delta):
	print(player_velo)
	
	match current_state:
		parado:
			_parado()
		andando:
			_andando()
	
	$frogSpr.scale.x = 1 if player_velo.x <= 0 else -1
	_set_state(_check_state())

#-----------------------------------------------

func _parado():
	anim.play("parado")
	
	_move()
#	_set_state(_check_parado())


func _andando():
	var animation = (
		"andando_para_baixo" if int(player_velo.y) > 0
		else "andando_de_costas" if int(player_velo.y) < 0 
		else "andando_de_frente"
	)
	anim.play(animation)
	_move()

#-----------------------------------------------

func _check_state():
	var new_state = andando if se_moveu else parado
	return new_state

#-----------------------------------------------

func _set_state(new_state): #seleciona o novo estado do peixe
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
	se_moveu = 1 if dir else 0
	player_velo = move_and_slide(player_velo)
