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


## A timed guard reduces damage while still allowing a minimum of one hit point.
## This is a fictional arcade mechanic, not a real-world combat model.
static func guarded_damage(base_damage: int, armor: int, guarding: bool) -> int:
	var raw: int = effective_damage(base_damage, armor)
	if raw <= 0 or not guarding:
		return raw
	return maxi(1, int(ceil(float(raw) * 0.4)))


static func may_raise_guard(guard_seconds: float, cooldown_seconds: float) -> bool:
	if not is_finite(guard_seconds) or not is_finite(cooldown_seconds):
		return false
	return guard_seconds <= 0.0 and cooldown_seconds <= 0.0

## A dash requires movement, a ready cooldown and no active guard.
static func may_dash(cooldown_seconds: float, direction: Vector3, guarding: bool = false) -> bool:
	if not is_finite(cooldown_seconds) or not direction.is_finite():
		return false
	return cooldown_seconds <= 0.0 and direction.length_squared() > 0.001 and not guarding
