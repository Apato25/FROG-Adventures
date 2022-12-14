extends TextureProgress


func _physics_process(_delta):
	max_value = Global.flower.flor_max_life
	value = Global.flower.current_life
