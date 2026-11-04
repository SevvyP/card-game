extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1
const DEFAULT_CARD_SCALE = Vector2(0.33, 0.33)
const HOVERED_CARD_SCALE = Vector2(0.45, 0.45)
const SLOTTED_CARD_SCALE = Vector2(0.25, 0.25)
const CAST_SPELL_Y_VALUE = 512

var card_being_dragged : Area2D
var screen_size : Vector2
var is_hovering_on_card : bool
var player_hand_reference
var discard_reference
var battle_manager_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../player_hand"
	discard_reference = $"../discard"
	battle_manager_reference = $"../battle_manager"
	$"../input_manager".connect("left_mouse_button_released", on_left_click_released)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos =  get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))
		# effect on spell cards to let player know they're being cast
		var card_slot_found = raycast_check_for_card_slot()
		if card_being_dragged.position.y < CAST_SPELL_Y_VALUE and not card_being_dragged.type == "Hero":
			card_being_dragged.highlighted = true
		elif card_slot_found and not card_slot_found.card_in_slot and card_being_dragged.type == "Hero":
			card_being_dragged.highlighted = true
		else:
			card_being_dragged.highlighted = false
			
func start_drag(card):
	card_being_dragged = card
	card.scale = DEFAULT_CARD_SCALE
	
func finish_drag():
	card_being_dragged.scale = HOVERED_CARD_SCALE
	var card_slot_found = raycast_check_for_card_slot()
	
	if card_slot_found and not card_slot_found.card_in_slot and card_being_dragged.type == "Hero":
		if battle_manager_reference.can_play_card(card_being_dragged):
			battle_manager_reference.play_card(card_being_dragged)
			player_hand_reference.remove_card_from_hand(card_being_dragged)
			card_being_dragged.position = card_slot_found.position
			card_being_dragged.get_node("CollisionShape2D").disabled = true
			card_slot_found.card_in_slot = true
			card_being_dragged.scale = SLOTTED_CARD_SCALE
			card_being_dragged.highlighted = false
			card_being_dragged.current_card_slot = card_slot_found
			card_being_dragged.z_index = -1
			is_hovering_on_card = false
		else:
			card_being_dragged.highlighted = false
			player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	elif card_being_dragged.position.y < CAST_SPELL_Y_VALUE and not card_being_dragged.type == "Hero":
		# cast spell only if enough mana (gems don't have a cost and will pass this)
		if battle_manager_reference.can_play_card(card_being_dragged):
			battle_manager_reference.play_card(card_being_dragged)
			discard(card_being_dragged)
		else:
			card_being_dragged.highlighted = false
			player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	else:
		card_being_dragged.highlighted = false
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged = null
			
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_left_click_released():
	if card_being_dragged:
		finish_drag()
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		enlarge_hovered_card(card, true)
	
func on_hovered_off_card(card):
	if !card.current_card_slot:
		if !card_being_dragged:
			enlarge_hovered_card(card, false)
			# check if user hovered off card staight onto another card
			var new_card_hovered = raycast_check_for_card()
			if new_card_hovered:
				enlarge_hovered_card(new_card_hovered, true)
			else:
				is_hovering_on_card = false
	
func enlarge_hovered_card(card, hovered):
	if card.current_card_slot:
		return
	if hovered:
		card.scale = HOVERED_CARD_SCALE
		card.z_index = 2
	else:
		card.scale = DEFAULT_CARD_SCALE
		card.z_index = 1

func get_card_with_highest_z_index(cards):
	# assume the first card passed in has the highest z index
	var highest_z_card = cards[0].collider
	var highest_z_index = highest_z_card.z_index
	
	# loop through the rest of the cards checking for a higher z index
	for i in range(1, cards.size()):
		if cards[i].collider.z_index > highest_z_index:
			highest_z_card = cards[i].collider
			highest_z_index = highest_z_card.z_index
			
	return highest_z_card

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider
	else:
		return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	else:
		return null
		
func discard(card):
	card_being_dragged.highlighted = false
	discard_reference.send_card_to_discard(card, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged.get_node("CollisionShape2D").disabled = true
	card_being_dragged.current_card_slot = "discard"
	card_being_dragged.scale = DEFAULT_CARD_SCALE
	is_hovering_on_card = false
