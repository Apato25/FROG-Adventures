extends Label

var write := true
var reverse := []

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	new_text("Por favor, derrote meus inimigos!")

func new_text(words:String, time:float = 3.0):
	if !write:
		future_text(words)
		return
		
	write = false
	text = ""
	show()
	timer(time)
	
	var count = 0
	for y in words:
		text += y
		rect_position.x = 165 - count * 3
		count += 1
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Hitsound 1.mp3"))
		yield(get_tree().create_timer(0.05), "timeout")


func timer(time:float = 3.0):
	yield(get_tree().create_timer(time), "timeout")
	hide()
	write = true
	if reverse:
		new_text(reverse[0])
		reverse.pop_front()

func future_text(words:String = ""):
	if reverse.size() == 2:
		reverse.pop_front()
	reverse.append(words)
