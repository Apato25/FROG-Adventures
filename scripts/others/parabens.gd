extends CanvasLayer

onready var game_completed = false

func _ready():
	set_visible(false)
	get_tree().paused = false

func _physics_process(delta):
	
	if game_completed:
		set_visible(true)
		get_tree().paused = true
	
	$flor_sprite.texture = $"../YSort/Flor".sprite_flor.texture
	
	if $"../YSort/Flor".flor_level == 5:
		$texto_parabens_max.visible = true
		$texto_parabens.visible = false
		$texto_flor.text = "flor nivel MAXIMO "
	else:
		$texto_parabens_max.visible = false
		$texto_parabens.visible = true
		$texto_flor.text = "flor nivel " + str($"../YSort/Flor".flor_level)
	
	
	#if $"../YSort/Flor".current_life < 0:
	#	set_visible(!get_tree().paused)
	#	get_tree().paused = !get_tree().paused

func _on_menu_pressed():
	get_tree().paused = false
	game_completed = false
	return get_tree().change_scene("res://cenas/others/title_menu.tscn")
