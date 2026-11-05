extends Area2D

signal hovered
signal hovered_off

var position_in_hand
var current_card_slot
var type
var highlighted = false
var attacked_this_turn = false
var attack
var health

var effects

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# all cards must be a child of card manager or this will error
	get_parent().connect_card_signals(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if highlighted:
		get_node("card_frame_highlight").visible = true
	else:
		get_node("card_frame_highlight").visible = false
	pass

func _on_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	
