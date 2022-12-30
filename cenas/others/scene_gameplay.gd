extends Node2D

onready var transition_index = $transition
onready var anim = $transition/fill/anim



func _ready():
	if OS.has_touchscreen_ui_hint():
		$debug_device.text = "mobile"
		$mobile_controls.set_visible(true)
	else:
		$debug_device.text = "pc"
		$mobile_controls.set_visible(false)
	
	
	anim.play("transition_out")
	yield(get_tree().create_timer(1), "timeout")
	transition_index.layer = 0
	$audio.playing = true




func _on_TextureButton_pressed():
	$Paused_UI.set_visible(!get_tree().paused)
	get_tree().paused = !get_tree().paused
