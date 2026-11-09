"""Core turn-based combat rules for Robot Arena Duel (Python 3.10+)."""
from dataclasses import dataclass


@dataclass
class Robot:
    name: str
    health: int = 100
    energy: int = 30
    shield: int = 0

    @property
    def alive(self):
        return self.health > 0


def take_turn(attacker: Robot, defender: Robot, action: str) -> str:
    if not attacker.alive or not defender.alive:
        raise ValueError("Combat has already ended")
    if action == "charge":
        attacker.energy = min(50, attacker.energy + 15)
        return f"{attacker.name} charged"
    if action == "defend":
        attacker.shield = min(30, attacker.shield + 12)
        return f"{attacker.name} raised shield"
    costs = {"strike": 5, "blast": 15}
    damages = {"strike": 12, "blast": 28}
    if action not in costs:
        raise ValueError("Unknown action")
    if attacker.energy < costs[action]:
        raise ValueError("Insufficient energy")
    attacker.energy -= costs[action]
    damage = damages[action]
    blocked = min(defender.shield, damage)
    defender.shield -= blocked
    defender.health = max(0, defender.health - (damage - blocked))
    return f"{attacker.name} used {action} for {damage - blocked} damage"


def main():
    robots = [Robot("Atlas"), Robot("Nova")]
    turn = 0
    print("Robot Arena Duel: strike, blast, charge, defend")
    while all(robot.alive for robot in robots):
        attacker, defender = robots[turn % 2], robots[(turn + 1) % 2]
        print(f"{attacker.name}: {attacker.health} HP, {attacker.energy} energy")
        try:
            print(take_turn(attacker, defender, input("Action> ").strip().lower()))
            turn += 1
        except ValueError as error:
            print(error)
    print(f"Winner: {next(robot.name for robot in robots if robot.alive)}")


if __name__ == "__main__":
    main()
