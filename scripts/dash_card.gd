extends ColorRect

@onready var card: Sprite2D = $TeleportCardFull

func _ready() -> void:
	card.set_texture(load("res://assets/sprites/" + get_meta("type") + "_card_full.png"))
	
	match(get_meta("type")):
		"dash":
			$CardName.text = "Dash"
		"double_jump":
			$CardName.text = "Double Jump"
		"teleport":
			$CardName.text = "Teleport"
