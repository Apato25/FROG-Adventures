extends CanvasLayer

signal use_move_attack
signal use_move_vector

var move_attack_vec = Vector2.ZERO
var move_vector = Vector2.ZERO

var can_atk = true
var move_bt = true
var joystick_active = false

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $walk_bt.is_pressed() and move_bt:
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
		
		elif $attack_bt.is_pressed() and can_atk:
			move_attack_vec = calculate_move_vector_atk(event.position)
			joystick_active = true
			Global.is_atk = true
		
	if event is InputEventScreenTouch:
		if $walk_bt.is_pressed() == false or $attack_bt.is_pressed() and move_bt:
			joystick_active = false
			move_bt = false
		
		if  $attack_bt.is_pressed() == false:
			joystick_active = false
			Global.is_atk = false
			move_bt = true
			can_atk = false
			yield(get_tree().create_timer(1),"timeout")
			can_atk = true
			

func _physics_process(_delta):
	print(Global.can_attack)
#	print(Global.atk_mobile_pos)
	Global.atk_mobile_pos = move_attack_vec
	Global.move_mobile_pos = move_vector
	
	if joystick_active:
		#Global.atk_mobile_pos = move_attack_vec
		#Global.move_mobile_pos = move_vector
		pass
	
	else:
		move_vector = Vector2()
		move_attack_vec = Vector2()

func calculate_move_vector(event_position):
	var texture_center =  $walk_bt.position + Vector2(16,16)
	return (event_position - texture_center).normalized()

func calculate_move_vector_atk(event_position):
	var texture_center =  $attack_bt.position + Vector2(16,16)
	return (event_position - texture_center)


