extends Node

@onready var label: Label = $UI/BoxContainer/VBoxContainer/Score
@onready var cards: HBoxContainer = %UI/BoxContainer/VBoxContainer/HBoxContainer
@onready var last_label: Label = %LastLabel

var player_skills = []
var score = 0

var is_scene_loading = false

func add_point():
	score += 1
	label.text = "Points: " + str(score)

func add_card(type: String):
	player_skills.append(type)
	
	var card_scene = preload("res://scenes/card.tscn")
	
	var temp = card_scene.instantiate()
	temp.set_meta("type", type)
	cards.add_child(temp)


func _on_score_loader_body_entered(body: Node2D) -> void:
	var score_saver = SaveScore.new().load_score()
	last_label.text = "You won! Or something... \n Your score is " + str(score_saver + score)
