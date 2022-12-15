extends Node2D

var flower :Node2D
var can_attack

func new_song(song:AudioStreamMP3):
	var audio = AudioStreamPlayer2D.new()
	add_child(audio)
	
	song.loop = false
	audio.stream = song
	audio.playing = true
	
	yield(audio, "finished")
	audio.queue_free()
