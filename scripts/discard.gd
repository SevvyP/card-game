extends Area2D

const DISCARD_PILE_POSITION = Vector2(1768, 888)

var player_hand_reference
var discard_pile = []

func _ready() -> void:
	player_hand_reference = $"../player_hand"

func send_card_to_discard(card, speed):
	discard_pile.append(card)
	player_hand_reference.remove_card_from_hand(card)
	# move the card to the top of the tree so that it renders over other cards in the pile
	card.get_parent().move_child(card, -1)
	player_hand_reference.animate_card_to_position(card, DISCARD_PILE_POSITION, speed)
		
