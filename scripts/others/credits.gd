extends CanvasLayer

var state :int

func _input(event):
	if event.is_action_pressed("ui_pause"):
		Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Back.mp3"))
		queue_free()

func _on_exit_pressed():
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Back.mp3"))
	queue_free()
