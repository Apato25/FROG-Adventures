extends Node2D

#lingua normal
onready var lingua = $lingua_normal/lingua
onready var posLingua = $lingua_normal/pos_lingua
onready var inipos = $lingua_normal/pos_inicio

onready var shape = $area/shape

#reflexo da lingua
onready var lingua_ref = $lingua__reflection/lingua
onready var posLingua_ref = $lingua__reflection/pos_lingua
onready var inipo_refs = $lingua__reflection/pos_inicio

export (int) var reach = 60
var sfx := true
var lingua_pos
var is_attack = false
var input_atk
signal attack

func _physics_process(delta):
#	print(lingua_pos)
	
	if OS.has_touchscreen_ui_hint():
		lingua_pos = Global.atk_mobile_pos
		input_atk = Global.is_atk
	else:
		lingua_pos = get_local_mouse_position()
		input_atk = Input.is_action_pressed("Attack")
	
	if input_atk:
		is_attack = true
	else:
		is_attack = false
	
	#lingua normal
	if is_attack == true and Global.can_attack == true:
		posLingua.position = posLingua.position.linear_interpolate(lingua_pos.limit_length(reach), delta * 20)
		lingua.set_point_position(1,posLingua.position)
		shape.shape.segments = lingua.points
		emit_signal("attack", true)
		if sfx:
			sfx = false
			Global.new_song(load("res://songs/sfx/Robot Walk.mp3"), -5)
	
	if is_attack == false:
		posLingua.position = posLingua.position.linear_interpolate(inipos.position, delta * 40)
		lingua.set_point_position(1,posLingua.position)
		emit_signal("attack", false)
		sfx = true
	
	#reflexo da lingua
	if is_attack == true and Global.can_attack == true:
		posLingua_ref.position = posLingua_ref.position.linear_interpolate(lingua_pos.limit_length(reach), delta * 20)
		lingua_ref.set_point_position(1,posLingua_ref.position)
	
	if is_attack == false:
		posLingua_ref.position = posLingua_ref.position.linear_interpolate(inipo_refs.position, delta * 40)
		lingua_ref.set_point_position(1,posLingua_ref.position)
