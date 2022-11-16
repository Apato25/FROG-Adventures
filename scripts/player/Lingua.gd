extends Node2D

onready var lingua = $lingua
onready var posLingua = $pos_lingua
onready var inipos = $pos_inicio
export (int) var reach = 60
var mouse_pos 

func _physics_process(delta):
	mouse_pos = get_local_mouse_position()
	
	if Input.is_action_pressed("Attack") == true and Global.can_attack == true:
		posLingua.position = posLingua.position.linear_interpolate(mouse_pos.limit_length(reach), delta * 20)
		lingua.set_point_position(1,posLingua.position)
	
	if Input.is_action_pressed("Attack") == false:
		posLingua.position = posLingua.position.linear_interpolate(inipos.position, delta * 40)
		lingua.set_point_position(1,posLingua.position)


