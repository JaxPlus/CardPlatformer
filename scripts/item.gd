extends Area2D

@onready var game_menager: Node = %GameMenager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play(get_meta("type"))

func _on_body_entered(_body: Node2D) -> void:
	game_menager.add_card(get_meta("type"))
	queue_free()
