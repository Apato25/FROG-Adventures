extends TextureProgress



func _physics_process(delta):
	max_value = get_tree().root.get_node("Flor").flor_max_life
	value = get_tree().root.get_node("Flor").current_life
