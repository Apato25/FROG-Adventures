extends Node2D

onready var lingua = $lingua
onready var posLingua = $pos_lingua
onready var inipos = $pos_inicio
var mouse_pos 

func _physics_process(delta):
	mouse_pos = get_local_mouse_position()
	
	if Input.is_action_pressed("Attack") == true:
		posLingua.position = posLingua.position.linear_interpolate(mouse_pos.limit_length(60), delta * 20)
		lingua.set_point_position(1,posLingua.position)
		
	
	if Input.is_action_pressed("Attack") == false:
		posLingua.position = posLingua.position.linear_interpolate(inipos.position, delta * 20)
		lingua.set_point_position(1,posLingua.position)
	
