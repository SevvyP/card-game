extends Node2D

var current_mana : int
var card_drawn_this_turn : bool
var mana_label_reference

func _process(_delta: float) -> void:
	mana_label_reference = $"../mana"
	mana_label_reference.get_node("mana_count").text = str(current_mana)

func can_play_card(card):
	if card.get_node("cost").text.to_int() <= current_mana:
		return true
	# flash the mana count to make it clear why the card isn't playing
	mana_label_reference.get_node("flash_animation").play("flash_red")
	return false
	
func play_card(card):
	current_mana -= card.get_node("cost").text.to_int()
	if card.type == "Gem":
		current_mana += 2
	
