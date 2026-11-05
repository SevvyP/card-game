extends Area2D

const DEFAULT_CARD_SCALE = Vector2(0.5, 0.5)
const READ_CARD_SCALE = Vector2(0.75, 0.75)
const DEFAULT_POSITION = Vector2(960, 232)
const READ_POSITION = Vector2(960, 330)

var health
var disable_animation = false
var current_tween: Tween

func _on_mouse_entered() -> void:
	read_card()

func _on_mouse_exited() -> void:
	unread_card()

func read_card():
	if disable_animation:
		return
	if current_tween and current_tween.is_running():
		current_tween.kill()
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "position", READ_POSITION, 0.1)
	current_tween.tween_property(self, "scale", READ_CARD_SCALE, 0.1)
	
func unread_card():
	if disable_animation:
		return
	if current_tween and current_tween.is_running():
		current_tween.kill()
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "scale", DEFAULT_CARD_SCALE, 0.1)
	current_tween.tween_property(self, "position", DEFAULT_POSITION, 0.1)
