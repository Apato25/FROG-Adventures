extends Label

var write := true
var reverse := []
var pos := 76

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	new_text("Por favor, derrote meus inimigos!")

func new_level(level):
	pos = 57 if level == 5 else 59 if level == 4 else 70 if level == 3 else 76

func new_text(words:String, time:float = 3.0):
	if !write:
		future_text(words)
		return
		
	write = false
	text = ""
	show()
	timer(time)
	
	
	rect_position.y = pos
	var count = 0
	
	for y in words:
		text += y
		rect_position.x = 165 - count * 3
		count += 1
		Global.new_song(load("res://songs/sfx/Hitsound 1.mp3"))
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
