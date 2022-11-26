extends Node2D

func _enter_tree():
	return get_parent().connect("new_life", self, "new_sprite")

func new_sprite(life):
	var tween = get_tree().create_tween()
	$sprite.rect_size.x = min(life, 3) * 11
	position.x = -min(life, 3) * 5.5
	tween.tween_property(self, "modulate:a", 1.0, 0.25)
	tween.tween_property(self, "modulate:a", 0.0, 1.75)
# CRIAR MÉTODO PARA MOSTRAR A PARTIR DA QUARTA VIDA UMA NOVA FILEIRA DE NO MÁXIMO 3 CORAÇÕES
