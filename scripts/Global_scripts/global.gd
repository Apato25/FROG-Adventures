extends Node2D

var flower :Node2D
var can_attack
var atk_mobile_pos
var is_atk

func new_song(song:AudioStreamMP3, volume:int = -15):
	var radio = AudioStreamPlayer.new()
	radio.volume_db = volume
	add_child(radio)
	
	song.loop = false
	radio.stream = song
	radio.playing = true
	
	yield(radio, "finished")
	radio.queue_free()
