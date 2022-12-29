extends CanvasLayer

onready var is_dead = false

func _ready():
	set_visible(false)
	get_tree().paused = false

func _physics_process(_delta):
	if is_dead:
		set_visible(true)
		get_tree().paused = true
	
	$"texto xp".text = "flor nivel " + str($"../YSort/Flor".flor_level) + ":" + "\nxp " + str(int($"../YSort/Flor".flor_xp)) + " / " +"680"
	
	#if $"../YSort/Flor".current_life < 0:
	#	set_visible(!get_tree().paused)
	#	get_tree().paused = !get_tree().paused


func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible


func _on_restart_bt_pressed():
	return get_tree().reload_current_scene()
