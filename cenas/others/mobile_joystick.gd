extends CanvasLayer

signal use_move_attack
signal use_move_vector

var move_attack_vec = Vector2.ZERO
var move_vector = Vector2.ZERO

var joystick_active_atk = false
var joystick_active = false

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $walk_bt.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
		
		if $attack_bt.is_pressed():
			move_attack_vec = calculate_move_vector_atk(event.position)
			joystick_active = true
			Global.is_atk = true
			
		
	if event is InputEventScreenTouch:
		if $walk_bt.is_pressed() == false:
			joystick_active = false
		
		if  $attack_bt.is_pressed() == false:
			joystick_active = false
			Global.is_atk = false

func _physics_process(_delta):
	print(Global.atk_mobile_pos)
	if joystick_active:
		emit_signal("use_move_attack",move_attack_vec)
		emit_signal("use_move_vector",move_vector)
		
	else:
		move_vector = Vector2()
		move_attack_vec = Vector2()
		emit_signal("use_move_vector",move_vector)
		emit_signal("use_move_attack",move_attack_vec)

func calculate_move_vector(event_position):
	var texture_center =  $walk_bt.position + Vector2(16,16)
	return (event_position - texture_center).normalized()

func calculate_move_vector_atk(event_position):
	return(event_position)
#	var texture_center =  $attack_bt.position + Vector2(16,16)
#	return (event_position - texture_center).normalized()


