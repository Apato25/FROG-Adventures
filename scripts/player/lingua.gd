extends Node2D

onready var posLingua = $fim
onready var inipos = $inicio
var can_attack = true
var mouse_pos 

func _physics_process(delta):
	mouse_pos = get_local_mouse_position()
	
	if Input.is_action_pressed("Attack") == true and  can_attack == true:
		posLingua.position = posLingua.position.linear_interpolate(mouse_pos, delta * 25)
		
	if Input.is_action_pressed("Attack") == false:
			posLingua.position = posLingua.position.linear_interpolate(inipos.position, delta * 25)
	print(posLingua.position.x)
