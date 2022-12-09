extends Node2D

export (Array, Array, String) var enemies

# A array armazena uma quantidade de arrays filhos, sendo esses filhos os dados do inimigos.
# Os dados armazenados nesses arrays filhos são do tipo String e serão:
# Índice  nº0 seu nodepath e o índice nº1 espaço de tropa na horda.
# Ex: [res://cenas/enemies/miniboss.tscn, 5].

var difficult := 1
var horda :int
var size :int
var died :int
var pos := Vector2(336, 189)

func _ready():
	randomize()
	attack()
	$ui/aviso.hide()

func pre_attack():
	horda += 1
	died = 0
	if horda == 3:
		difficult += 1
		$timer.wait_time = 2
	if horda == 5:
		difficult += 1
		$timer.wait_time = 1
	
	$anim.play("show")
	yield($anim, "animation_finished")
	attack()

func attack():
	$ui/UI_count_horda/horda.text = "Horda "+str(horda+1)
	size = (horda * 5) + 10
	$ui/UI_count_horda/count.text = "0"+str(size) if size < 10 else ""+str(size)
	$ui.show()
	$timer.start()

func _on_timer_timeout():
	if !size:
		$timer.stop()
		return
	
	var rng = randi() % difficult # Escolhe um array filho aleatório.
	while int(enemies[rng][1]) > size: # Verifica se seu espaço ultrapassar size.
		rng = randi() % difficult # Caso sim escolhe outro filho.
	
	# Cria o inimigo assim que seu espaço for <= a size.
	var new_enemy = load(enemies[rng][0]).instance()
	var new_pos = Vector2(
		0 if randi() % 2 < 1 else 336,
		0 if randi() % 2 <1 else 189
	)
	new_enemy.global_position = new_pos # Posições de teste.
	
	# Conecta o sinal que os inimigos emitem quando morrer, retonando seus respectivos size.
	new_enemy.connect("died", self, "death_count")

	add_child(new_enemy)
	size -= int(enemies[rng][1]) # Diminui a quantidade de monstro.
	$ui/UI_count_horda/count.text = "0"+str(size) if size < 10 else ""+str(size)

func death_count(x): # Verifica se todos os inimigos dessa horda morreram.
	died += x
	if died != (horda * 5) + 10:
		return
	if horda < 7: # Caso todos os inimigos estejam mortos e a horda não for a 7 à guerra contínua.
		pre_attack()
	else: # Derrote a horda 7 se for possível.
		winner()

func winner():
	print("Para...Béns...!!!")
