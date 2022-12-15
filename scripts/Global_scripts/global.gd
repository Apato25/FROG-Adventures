extends Node2D

var flower :Node2D
var can_attack

func new_song(song:AudioStreamMP3):
	var audio = AudioStreamPlayer.new()
	audio.volume_db = -15
	add_child(audio)
	
	song.loop = false
	audio.stream = song
	audio.playing = true
	
	yield(audio, "finished")
	audio.queue_free()
