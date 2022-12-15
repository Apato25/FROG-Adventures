extends Node2D

#lingua normal
onready var lingua = $lingua_normal/lingua
onready var posLingua = $lingua_normal/pos_lingua
onready var inipos = $lingua_normal/pos_inicio

#reflexo da lingua
onready var lingua_ref = $lingua__reflection/lingua
onready var posLingua_ref = $lingua__reflection/pos_lingua
onready var inipo_refs = $lingua__reflection/pos_inicio

export (int) var reach = 60
var sfx := true
var mouse_pos
signal attack

func _physics_process(delta):
#	print(posLingua.position)
	mouse_pos = get_local_mouse_position()
	#lingua normal
	if Input.is_action_pressed("Attack") == true and Global.can_attack == true:
		posLingua.position = posLingua.position.linear_interpolate(mouse_pos.limit_length(reach), delta * 20)
		lingua.set_point_position(1,posLingua.position)
		emit_signal("attack", true)
		if sfx:
			sfx = false
			Global.new_song(load("res://songs/sfx/GB Sound Assets/Robot Walk.mp3"))
	
	if Input.is_action_pressed("Attack") == false:
		posLingua.position = posLingua.position.linear_interpolate(inipos.position, delta * 40)
		lingua.set_point_position(1,posLingua.position)
		emit_signal("attack", false)
		sfx = true
	
	#reflexo da lingua
	if Input.is_action_pressed("Attack") == true and Global.can_attack == true:
		posLingua_ref.position = posLingua_ref.position.linear_interpolate(mouse_pos.limit_length(reach), delta * 20)
		lingua_ref.set_point_position(1,posLingua_ref.position)
	
	if Input.is_action_pressed("Attack") == false:
		posLingua_ref.position = posLingua_ref.position.linear_interpolate(inipo_refs.position, delta * 40)
		lingua_ref.set_point_position(1,posLingua_ref.position)
