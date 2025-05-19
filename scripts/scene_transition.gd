extends CanvasLayer

@onready var game_menager = GameMenager

func change_scene(path: String) -> void:
	if game_menager != null:
		game_menager.is_scene_loading = true

	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(path)
	$AnimationPlayer.play_backwards("dissolve")

	if game_menager != null:
		game_menager.is_scene_loading = false
