extends Area2D

@onready var game_menager: Node = %GameMenager

func _on_body_entered(_body: Node2D) -> void:
	game_menager.add_point()
	queue_free()
