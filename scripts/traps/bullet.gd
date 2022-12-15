extends Node2D

export var speed = 200
var velocity :Vector2

func _physics_process(delta):
	velocity = Vector2.RIGHT.rotated(rotation)
	global_position += velocity * speed * delta

func _on_bullet_body_entered(_body):
	queue_free()

func _on_not_screen_exited():
	queue_free()
