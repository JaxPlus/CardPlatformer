extends Area2D

@export var next_level: String = ""

func _on_body_entered(_body: Node2D) -> void:
	var ss = SaveScore.new()
	var file_score = 0
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		file_score = file.get_8()
	ss.save_score(%GameMenager.score + file_score)
	SceneTransition.change_scene("res://scenes/" + next_level + ".tscn")
