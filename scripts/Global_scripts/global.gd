extends Node2D

var flower :Node2D
var can_attack
var atk_mobile_pos = Vector2()
var move_mobile_pos = Vector2()
var is_atk :bool

func new_song(song:AudioStreamMP3, volume:int = -15):
	var radio = AudioStreamPlayer.new()
	radio.volume_db = volume
	add_child(radio)
	
	song.loop = false
	radio.stream = song
	radio.playing = true
	
	yield(radio, "finished")
	radio.queue_free()
