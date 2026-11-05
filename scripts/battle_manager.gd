extends Node

const TOGGLED_CARD_OFFSET = Vector2(30, 30)
const CARD_ATTACK_POSITION = Vector2(960, 450)

var current_mana : int
var card_drawn_this_turn : bool
var mana_label_reference
var toggled_card

# in the future, dynamically load the enemy based on selection or whatever
var enemy

func _ready() -> void:
	enemy = $"../enemy"
	enemy.get_node("name").text = "[center]Lord of Wrath[/center]"
	enemy.get_node("health").text = "[center]20[/center]"
	enemy.health = 20
	

func _process(_delta: float) -> void:
	mana_label_reference = $"../mana"
	mana_label_reference.get_node("mana_count").text = str(current_mana)

func add_mana(mana):
	current_mana += mana
	
	# future proofing negative mana effects
	if current_mana < 0:
		current_mana = 0
	

func can_play_card(card):
	if card.get_node("cost").text.to_int() <= current_mana:
		return true
	# flash the mana count to make it clear why the card isn't playing
	mana_label_reference.get_node("flash_animation").play("flash_red")
	return false
	
func play_card(card):
	current_mana -= card.get_node("cost").text.to_int()
	
	if card.type != "Hero" and card.effects:
		for effect in card.effects:
			var target : Array[Node] = [self]
			effect.execute(target, {})
			
func toggle_attack_mode(card):
	enemy.disable_animation = not enemy.disable_animation
	if enemy.disable_animation:
		card.position -= TOGGLED_CARD_OFFSET
		toggled_card = card
	else:
		card.position += TOGGLED_CARD_OFFSET
		toggled_card = null
	
func take_damage(amount):
	enemy.health -= amount
	enemy.get_node("health").text = "[center]" + str(enemy.health) + "[/center]"
	if enemy.health <= 0:
		end_game()
	
func attack_enemy_with_toggled_card():
	var tween = get_tree().create_tween()
	var current_pos = toggled_card.position
	tween.tween_property(toggled_card, "position", CARD_ATTACK_POSITION, 0.1)
	tween.tween_property(toggled_card, "position",current_pos, 0.2)
	await tween.finished
	enemy.take_damage(toggled_card.attack)
	enemy.get_node("health").text = "[center]" + str(enemy.health) + "[/center]"
	if enemy.health == 0:
		end_game()
		
	toggled_card.attacked_this_turn = true
	toggle_attack_mode(toggled_card)
		
func end_game():
	print("game over!")
