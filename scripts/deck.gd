extends Area2D

const CARD_SCENE_PATH = "res://prefabs/card.tscn"
const CARD_DRAW_SPEED = 0.2
const CARD_SPAWN_POSITION = Vector2(150, 900)
const STARTING_HAND_SIZE = 5
const DEFAULT_CARD_SCALE = Vector2(0.33, 0.33)
const HAND_DEALT_TIMER = 0.1

var player_deck = ["Knight", "Archer", "Demon", "Fireball", "Heal", "Gem", "Gem", "Gem", "Gem"]
var card_database_reference
var hero_frame_reference
var spell_frame_reference
var gem_frame_reference

# counter variable to assign unique numbers to each card
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$cards_remaining.text = str(player_deck.size())
	card_database_reference = preload("res://scripts/card_database.gd")
	hero_frame_reference = preload("res://sprites/card_frame_hero_demo.png")
	spell_frame_reference = preload("res://sprites/card_frame_spell_demo.png")
	gem_frame_reference = preload("res://sprites/card_frame_gem_demo.png")
	
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		await get_tree().create_timer(HAND_DEALT_TIMER).timeout
	
func draw_card():
	var card_drawn = player_deck.get(0)
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$CollisionShape2D.disabled = true
		get_node("card_back").visible = false
	
	$cards_remaining.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../card_manager".add_child(new_card)
	
	# perform these for every card type
	new_card.name = "deck" + "-" + str(counter)
	counter += 1
	new_card.get_node("type").text = card_database_reference.CARDS[card_drawn][3]
	new_card.type = card_database_reference.CARDS[card_drawn][3]
	new_card.get_node("card_image").texture = load(card_database_reference.CARDS[card_drawn][5])
	new_card.get_node("name").text = card_drawn
	
	# hero cards
	if card_database_reference.CARDS[card_drawn][3] == "Hero":
		new_card.get_node("attack").text = str(card_database_reference.CARDS[card_drawn][0])
		new_card.attack = card_database_reference.CARDS[card_drawn][0]
		new_card.get_node("health").text = str(card_database_reference.CARDS[card_drawn][1])
		new_card.health = card_database_reference.CARDS[card_drawn][1]
		new_card.get_node("cost").text = str(card_database_reference.CARDS[card_drawn][2])
		new_card.get_node("card_frame").texture = hero_frame_reference
		new_card.get_node("ability").visible = false
	
	# spell cards
	if card_database_reference.CARDS[card_drawn][3] == "Spell":
		new_card.get_node("cost").text = str(card_database_reference.CARDS[card_drawn][2])
		new_card.get_node("ability").text = center_text(str(card_database_reference.CARDS[card_drawn][4]))
		new_card.get_node("card_frame").texture = spell_frame_reference
		new_card.get_node("attack").visible = false
		new_card.get_node("health").visible = false
	
	# gem cards
	if card_database_reference.CARDS[card_drawn][3] == "Gem":
		new_card.get_node("ability").text = center_text(str(card_database_reference.CARDS[card_drawn][4]))
		new_card.get_node("card_frame").texture = gem_frame_reference
		new_card.get_node("attack").visible = false
		new_card.get_node("health").visible = false
		new_card.get_node("cost").visible = false

	new_card.position = CARD_SPAWN_POSITION
	new_card.scale = DEFAULT_CARD_SCALE
	
	$"../player_hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("flip_animation").play("card_flip")
	
func center_text(text: String):
	text = "[center]" + text + "[/center]"
	return text
	
