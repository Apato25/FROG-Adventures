extends Label

var write := true
var reverse := []

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	new_text("Por favor, derrote meus inimigos!")

func new_text(words:String, finish:bool = false):
	if !write:
		future_text(words)
		return
	write = false
	text = ""
	show()
	timer(finish)
	var arr = []
	for h in words:
		arr.append(h)
	
	for i in arr.size():
		text += arr[i]
		rect_position.x = 165 - (i) * 3
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Hitsound 1.mp3"))
		yield(get_tree().create_timer(0.05), "timeout")

func timer(finish:bool, time:float = 3.0):
	if !finish:
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
