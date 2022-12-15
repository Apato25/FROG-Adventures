extends Node2D

export (Array, Array, String) var enemies

var difficult := 1
var horda := 1
var limit :int
var size :int
var died :int
var enemies_death :int
var meta :int
var text := ["",""]

signal flower_xp
signal dead_horde


func _ready():
	randomize()
	$ui/aviso.hide()
	
	var _conect = connect("flower_xp", Global.flower, "xp_gain")
	_conect = connect("dead_horde", Global.flower, "bonus")
	
	yield(get_tree().create_timer(2), "timeout")
	attack()

func pre_attack():
	emit_signal("flower_xp", true)
	emit_signal("dead_horde", horda)
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
	size += 25 if horda == 10 else 0
	meta += size
	printer()
	$ui.show()
	$timer.start()

func _on_timer_timeout():
	if !size:
		$timer.stop()
		emit_signal("flower_xp", false)
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
	printer()
	if died < ((horda-1) * 5) + 10:
		return
	if horda < 10:
		pre_attack()
	else:
		winner()

func printer():
	text = [
		"0"+str(enemies_death) if enemies_death < 10 else "" + str(enemies_death),
		"0"+str(meta) if meta < 10 else "" + str(meta)
	]
	$ui/UI_count_horda/count.text = text[0] +" / " + text[1]

func winner():
	$ui/aviso.set_text("Para...Béns...!!!")
	$ui/aviso.rect_position = Vector2(111,88)
	$ui/aviso.show()
