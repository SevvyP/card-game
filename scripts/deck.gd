extends Area2D

const CARD_SCENE_PATH = "res://prefabs/card.tscn"
const CARD_DRAW_SPEED = 0.2

var player_deck = ["knight", "knight", "knight"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size())


func draw_card():
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../card_manager".add_child(new_card)
	new_card.name = "card"
	$"../player_hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
