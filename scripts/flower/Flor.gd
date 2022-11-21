extends Node2D

onready var anim = $Flor_anim

var flor_state
enum {Flor_0,Flor_1}

var flor_max_life = 0
var current_life = 250
var flor_xp = 0

var flor_life_update = true

func _physics_process(delta):
	flor_levelup()
	match flor_state:
		Flor_0:
			flor_max_life = 250
			anim.play("Flor_Nivel1")
		Flor_1:
			flor_max_life = 500
			anim.play("Flor_Nivel2")
	
	current_life -= 0.5
	if current_life == 0:
		current_life = flor_max_life
	print(flor_xp)



func flor_levelup():
	flor_receiveXp()
	
	if flor_xp >= 10:
		flor_state = 1
	elif flor_xp == 0:
		flor_state = 0

func flor_receiveXp():
	#botao para testar é a letra T
	if Input.is_action_just_pressed("teste"):
		flor_xp += 1

