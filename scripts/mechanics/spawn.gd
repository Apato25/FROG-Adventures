extends Node2D

export (Array, Array, String) var enemies

# A array armazena uma quantidade de arrays filhos, sendo esses filhos os dados do inimigos.
# Os dados armazenados nesses arrays filhos são do tipo String e serão:
# Índice  nº0 seu nodepath e o índice nº1 espaço de tropa na horda.
# Ex: [res://cenas/enemies/miniboss.tscn, 5].

var difficult := 1
var horda := 1
var limit :int
var size :int
var died :int
var enemies_death :int

func _ready():
	randomize()
	attack()
	$ui/aviso.hide()

func _physics_process(_delta):
	if Input.is_action_just_pressed("teste"):
		death_count(((horda-1) * 5) + 10)

func pre_attack():
	horda += 1
	died = 0
	if horda == 3:
		difficult += 1
		$timer.wait_time -= 0.5
	if horda == 5:
		difficult += 1
		$timer.wait_time -= 0.5
	if horda == 7:
		difficult += 1
		$timer.wait_time -= 0.5
	
	$anim.play("show")
	yield($anim, "animation_finished")
	attack()

func attack():
	$ui/UI_count_horda/horda.text = "Horda "+str(horda)
	size = ((horda-1) * 5) + 10
	$ui.show()
	$timer.start()

func _on_timer_timeout():
	if !size:
		$timer.stop()
		return
	
	var rng = randi() % difficult
	while int(enemies[rng][1]) > size:
		rng = randi() % difficult
	
	
	var new_enemy = load(enemies[rng][0]).instance()
	var new_pos = Vector2(
		0 if randi() % 2 < 1 else 336,
		0 if randi() % 2 <1 else 189
	)
	
	
	new_enemy.global_position = new_pos # Posições de teste.
	new_enemy.connect("died", self, "death_count")

	add_child(new_enemy)
	size -= int(enemies[rng][1])

func death_count(x):
	died += x
	enemies_death += x
	$ui/UI_count_horda/count.text = "0"+str(enemies_death) if enemies_death < 10 else ""+str(enemies_death)
	if died < ((horda-1) * 5) + 10:
		return
	if horda < 9:
		pre_attack()
	else:
		winner()

func winner():
	$ui/aviso.set_text("Para...Béns...!!!")
	$ui/aviso.rect_position = Vector2(111,88)
	$ui/aviso.show()
