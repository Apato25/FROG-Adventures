extends Node2D

onready var transition_index = $transition
onready var anim = $transition/fill/anim

func _ready():
	anim.play("transition_out")
	yield(get_tree().create_timer(1), "timeout")
	transition_index.layer = 0
	$audio.playing = true
