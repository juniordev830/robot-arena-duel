"""Dependency-free turn-based combat core for Robot Arena Duel."""
from dataclasses import dataclass

@dataclass
class Robot:
    name: str
    health: int = 100
    armor: int = 5
    energy: int = 100

    def __post_init__(self):
        if not self.name or not 0 <= self.health <= 100 or not 0 <= self.armor <= 30 or not 0 <= self.energy <= 100:
            raise ValueError("Invalid robot configuration")

    @property
    def alive(self) -> bool:
        return self.health > 0

    def attack(self, target: "Robot", power: int = 20) -> int:
        if not self.alive or not target.alive:
            raise ValueError("Both robots must be active")
        if not 1 <= power <= 30:
            raise ValueError("Power must be between 1 and 30")
        cost = power // 2
        if self.energy < cost:
            raise ValueError("Insufficient energy")
        self.energy -= cost
        damage = max(1, power - target.armor)
        target.health = max(0, target.health - damage)
        return damage

    def recharge(self, amount: int = 15) -> None:
        if not self.alive or not 1 <= amount <= 30:
            raise ValueError("Invalid recharge")
        self.energy = min(100, self.energy + amount)
