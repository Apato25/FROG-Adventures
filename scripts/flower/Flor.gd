extends Node2D

onready var anim = $Flor_anim

var body_count = 0
var area_count = 0
var is_attacked = false

var time := 5.0

var flor_state
enum {Flor_0,Flor_1}

var flor_max_life = 0
var current_life = 500
var flor_xp = 0

var flor_life_update = true

func _enter_tree():
	Global.flower = self

func _ready():
	$ui.hide()

func revive():
	showing(time)

func showing(x:float):
	$ui/label.text = (
		"O player renascerar em: 0"+str(int(x)+1) if x <9
		else "O player renascerar em: " +str(int(x)+1)
	)
	$ui.show()
	while x > 0:
		yield(get_tree().create_timer(0.5),"timeout")
		x -= 0.5
		$ui/label.text = (
			"O player renascerar em: 0"+str(int(x)+1) if x <9
			else "O player renascerar em: " +str(int(x)+1)
		)
	$ui.hide()
	var player = load("res://cenas/player/Player.tscn").instance()
	player.global_position = global_position
	get_tree().current_scene.add_child(player)
	time += 3


func _physics_process(_delta):
	flor_levelup()
	match flor_state:
		Flor_0:
			flor_max_life = 500
			anim.play("Flor_Nivel1")
		Flor_1:
			flor_max_life = 750
			anim.play("Flor_Nivel2")
	
	if body_count == 0 and area_count == 0:
		is_attacked = false
	else:
		is_attacked = true
	
	 #faz a flor perder vida
	if is_attacked:
		current_life -= body_count + area_count
		#yield(get_tree().create_timer(0.5), "timeout")
	else:
		current_life = current_life
		
	#teste de cura da vida da flor
	if current_life <= 0:
		get_tree().change_scene("res://cenas/others/title_menu.tscn")
		#current_life = flor_max_life
#	print(flor_xp)



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


