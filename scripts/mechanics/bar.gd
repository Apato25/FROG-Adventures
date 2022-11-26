extends ColorRect

var size = rect_size.x
var max_life :int

func _enter_tree():
	max_life = get_parent().life
	return get_parent().connect("hitted", self, "new_bar")

func new_bar(new_value):
	rect_size.x = new_value * size / max_life
