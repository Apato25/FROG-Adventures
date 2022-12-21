extends CanvasLayer

var state :int
var rgb = [Color.white, Color.blueviolet, Color.violet]

func _ready():
	randomize()
	$thanks.modulate = rgb[randi() % rgb.size()]
	modulate()

func modulate():
	var tween = get_tree().create_tween()
	tween.tween_property($thanks, "modulate:a", 0.0, 1.0)
	$timer.start()

func color():
	var tween = get_tree().create_tween()
	var new_modulate = rgb[randi() % rgb.size()]
	$thanks.modulate.a = 1
	
	while new_modulate == $thanks.modulate:
		new_modulate = rgb[randi() % rgb.size()]
	
	$thanks.modulate = new_modulate
	$thanks.modulate.a = 0
	
	tween.tween_property($thanks, "modulate:a", 1.0, 1.0)
	$timer.start()

func _on_timer_timeout():
	match state:
		0:
			state = 1
			color()
		1:
			state = 0
			modulate()

func _input(event):
	if event.is_action_pressed("ui_pause"):
		queue_free()

func _on_exit_pressed():
	queue_free()
