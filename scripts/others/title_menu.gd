extends Node2D

onready var transition_index = $transition
onready var anim = $transition/fill/anim

func _on_TextureButton_pressed():
	$buttons.hide()
	transition_index.layer = 2
	anim.play("transition_in")
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Back.mp3"))
	yield(get_tree().create_timer(1), "timeout")
	return get_tree().change_scene("res://cenas/cenas de teste/Teste.tscn")
	
