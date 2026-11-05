class_name HealEffect
extends SpellEffect

@export var heal_amount: int = 5

func execute(targets: Array[Node], _context: Dictionary) -> void:
	for target in targets:
		if target.has_method("heal_damage"):
			target.heal_damage(heal_amount)
