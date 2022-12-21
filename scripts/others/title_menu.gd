extends Node2D

onready var transition_index = $transition
onready var anim = $transition/fill/anim

func _ready():
	for buttons in $buttons.get_children():
		buttons.connect("pressed", self, buttons.name)

func new_game():
	$buttons.hide()
	transition_index.layer = 2
	anim.play("transition_in")
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Back.mp3"))
	yield(get_tree().create_timer(1), "timeout")
	return get_tree().change_scene("res://cenas/cenas de teste/Teste.tscn")

func credits():
	Global.new_song(load("res://songs/sfx/GB Sound Assets/Menu Back.mp3"))
	add_child(load("res://cenas/others/credits.tscn").instance())
 
