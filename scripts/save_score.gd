class_name SaveScore
extends Resource

var score = 0

func save_score(new_score: int):
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	score = new_score
	file.store_8(score)

func load_score():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	return file.get_8()
