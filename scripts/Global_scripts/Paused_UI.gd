extends CanvasLayer
func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_pause"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused


func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible


func _on_mainmenu_bt_pressed():
		get_tree().paused = false
		return get_tree().change_scene("res://cenas/others/title_menu.tscn")
