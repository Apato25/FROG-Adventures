extends Area2D

export var speed = 130
var velocity :Vector2

func _physics_process(delta):
	velocity = Vector2.RIGHT.rotated(rotation)
	global_position += velocity * speed * delta

func _on_bullet_area_entered(_area):
#	queue_free()
	pass
func _on_bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()

func _on_not_screen_exited():
	queue_free()
