extends RefCounted
## Small, deterministic domain rules that can be exercised without rendering.

static func effective_damage(base_damage: int, armor: int) -> int:
	if base_damage <= 0:
		return 0
	return maxi(1, base_damage - maxi(0, armor))


static func remaining_health(current: int, damage: int, maximum: int = 100) -> int:
	return clampi(current - maxi(0, damage), 0, maximum)


static func in_range(distance: float, reach: float) -> bool:
	return distance >= 0.0 and reach >= 0.0 and distance <= reach
