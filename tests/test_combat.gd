extends SceneTree
const Rules = preload("res://scripts/combat_rules.gd")

func _initialize() -> void:
	assert(Rules.effective_damage(16, 2) == 14, "armor reduces damage")
	assert(Rules.effective_damage(2, 999) == 1, "positive attacks deal at least one")
	assert(Rules.effective_damage(0, 0) == 0, "no attack does no damage")
	assert(Rules.remaining_health(10, 99) == 0, "health never goes negative")
	assert(Rules.remaining_health(95, -3) == 95, "negative damage never heals")
	assert(Rules.in_range(2.35, 2.35), "boundary is in range")
	assert(not Rules.in_range(2.36, 2.35), "beyond boundary is out of range")
	assert(not Rules.in_range(-1.0, 2.35), "invalid distance rejected")
	print("Combat rules: all 8 assertions passed")
	quit()
