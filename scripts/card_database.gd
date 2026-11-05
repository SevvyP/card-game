const CARDS = { # attack, health, cost, type, ability, image path, spell effects
	"Knight": 	[2, 3, 2, "Hero", null, "res://sprites/knight.png", null],
	"Archer": 	[1, 1, 1, "Hero", null, "res://sprites/archer.png", null],
	"Demon": 	[5, 7, 4, "Hero", null, "res://sprites/demon.png", null],
	"Fireball": [null, null, 2, "Spell", "Deal 5 damage to an enemy", "res://sprites/fireball.png", [
		preload("res://effects/fireball.tres")
	]],
	"Heal": [null, null, 2, "Spell", "Heal an ally up to 2 HP", "res://sprites/heal.png", [
		preload("res://effects/heal.tres")
	]],
	"Gem": [null, null, null, "Gem", "Gain 2 mana", "res://sprites/gem.png", [
		preload("res://effects/gem.tres")
	]]
}
