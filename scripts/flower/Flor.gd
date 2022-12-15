extends Node2D

onready var anim = $Flor_anim
onready var text = $ui/text

var body_count := 0.0
var area_count := 0.0
var is_attacked = false

export var time := 3.0

var flor_state :int
enum {Flor_0,Flor_1}

var flor_max_life = 0
var current_life = 500
var flor_life_update = true
var old_life = current_life

var flor_xp = 0
var flor_level := 1
var can_xp :bool

func _enter_tree():
	Global.flower = self


func _ready():
	$ui/label.hide()
	yield(get_tree().create_timer(2), "timeout")
	can_xp = true

func revive():
	showing(time)


func showing(x:float):
	$ui/label.text = (
		"O player renascerar em: 0"+str(int(x)+1) if x <9
		else "O player renascerar em: " +str(int(x)+1)
	)
	$ui/label.show()
	while x > 0:
		yield(get_tree().create_timer(0.5),"timeout")
		x -= 0.5
		$ui/label.text = (
			"O player renascerar em: 0"+str(int(x)+1) if x <9
			else "O player renascerar em: " +str(int(x)+1)
		)
	$ui/label.hide()
	var player = load("res://cenas/player/Player.tscn").instance()
	player.global_position = global_position
	get_tree().current_scene.add_child(player)
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Select.mp3"))
	time += 2


func _physics_process(delta):
	if can_xp:
		flor_receiveXp(delta)
	match flor_state:
		Flor_0:
			flor_max_life = 500
			anim.play("Flor_Nivel1")
		Flor_1:
			flor_max_life = 750
			anim.play("Flor_Nivel2")
	
	if body_count < 0.2 and area_count < 1:
		is_attacked = false
	else:
		is_attacked = true
	
	
	if is_attacked:
		current_life -= body_count + area_count
	
	if current_life <= 0:
		return get_tree().change_scene("res://cenas/others/title_menu.tscn")

func flor_receiveXp(delta):
#	if flor_level == 5:
#		can_xp = false
#		flor_xp = 250
#		print("Level Máximo!")
#		return
	
	var xp = flor_level
	flor_xp += delta * int(!is_attacked)
	flor_level = (
		5 if flor_xp >= 700
		else 4 if flor_xp >= 400
		else 3 if flor_xp >= 200
		else 2 if flor_xp >= 50
		else 1
	) 
	var max_xp = (
		700 if flor_level >= 4
		else 400 if flor_level == 3
		else 200 if flor_level == 2
		else 50
	)
	
	print("XP: ", int(flor_xp),"/",max_xp, " / ", "Level: ", flor_level)
	
	if xp != flor_level:
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Select 2.mp3"))
		flor_state = 1 if flor_level >= 2 else 0
		heal(250)
		text.new_text("Subi de nivel!")

func xp_gain(can:bool):
	can_xp = can

func bonus(x:int):
	if current_life != old_life:
		old_life = current_life
		return
	flor_xp += x *10
	text.new_text("Mais " +  str(x*10) + " de XP Bonus!!!")

func heal(x:int):
	current_life += x
	old_life += x

func _on_flower_area_area_entered(area):
	if area.name == "bullet":
		area_count += 1

func _on_flower_area_area_exited(area):
	if area.name == "bullet":
		area_count -= 1

func _on_flower_area_body_entered(_body):
	body_count += 0.2

func _on_area_body_exited(_body):
	body_count -= 0.2
