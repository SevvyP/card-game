class_name ManaEffect
extends SpellEffect

@export var mana_amount: int = 2

func execute(targets: Array[Node], _context: Dictionary) -> void:
	for target in targets:
		if target.has_method("add_mana"):
			target.add_mana(mana_amount)
