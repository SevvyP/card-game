extends Area2D

const CARD_SCENE_PATH = "res://prefabs/card.tscn"
const CARD_DRAW_SPEED = 0.2
const CARD_SPAWN_POSITION = Vector2(150, 900)

var player_deck = ["knight", "archer", "demon"]
var card_database_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://scripts/card_database.gd")
	
func draw_card():
	var card_drawn = player_deck.get(0)
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$CollisionShape2D.disabled = true
		get_node("card_back").visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../card_manager".add_child(new_card)
	new_card.name = card_drawn
	new_card.get_node("attack").text = str(card_database_reference.CARDS[card_drawn][0])
	new_card.get_node("health").text = str(card_database_reference.CARDS[card_drawn][1])
	new_card.get_node("card_image").texture = load(card_database_reference.CARDS[card_drawn][2])
	new_card.position = CARD_SPAWN_POSITION
	$"../player_hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("flip_animation").play("card_flip")
