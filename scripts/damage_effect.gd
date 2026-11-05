class_name DamageEffect
extends SpellEffect

@export var damage_amount: int = 5

func execute(targets: Array[Node], _context: Dictionary) -> void:
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage_amount)
