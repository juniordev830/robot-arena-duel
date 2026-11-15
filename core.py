"""Local combat rules for a two-robot arena prototype."""
from dataclasses import dataclass
from math import hypot, isfinite


def finite(v):
    if isinstance(v, bool) or not isinstance(v, (int, float)) or not isfinite(v):
        raise ValueError("non-finite value")
    return float(v)


@dataclass
class Robot:
    x: float = 0.0
    y: float = 0.0
    hp: int = 100
    cooldown: float = 0.0


class Arena:
    def __init__(self, radius: float = 10, attack_range: float = 3):
        self.radius, self.attack_range = finite(radius), finite(attack_range)
        if self.radius <= 0 or self.attack_range <= 0:
            raise ValueError("positive arena size and attack range required")
        self.reset()

    def reset(self):
        self.robots = {"blue": Robot(-2, 0), "red": Robot(2, 0)}
        self.time = 0.0
        self.events = set()
        self.winner = None

    def move(self, team: str, dx: float, dy: float):
        robot = self.robots[team]
        dx, dy = finite(dx), finite(dy)
        if self.winner:
            raise ValueError("duel finished")
        nx, ny = robot.x + dx, robot.y + dy
        if hypot(nx, ny) > self.radius:
            raise ValueError("arena wall collision")
        robot.x, robot.y = nx, ny

    def advance(self, dt: float):
        dt = finite(dt)
        if not 0 < dt <= 0.1:
            raise ValueError("invalid timestep")
        if self.winner:
            return
        for robot in self.robots.values():
            robot.cooldown = max(0.0, round(robot.cooldown - dt, 9))
        self.time += dt

    def attack(self, attacker: str, event_id: str) -> int:
        if attacker not in self.robots or not event_id or not isinstance(event_id, str):
            raise ValueError("invalid attack")
        if event_id in self.events or self.winner:
            raise ValueError("duplicate event or finished duel")
        target = "red" if attacker == "blue" else "blue"
        source, victim = self.robots[attacker], self.robots[target]
        if source.cooldown > 0:
            raise ValueError("weapon on cooldown")
        if hypot(source.x - victim.x, source.y - victim.y) > self.attack_range:
            raise ValueError("target out of range")
        self.events.add(event_id)
        victim.hp = max(0, victim.hp - 25)
        source.cooldown = 0.5
        if victim.hp == 0:
            self.winner = attacker
        return victim.hp


if __name__ == "__main__":
    arena = Arena()
    arena.move("blue", 1.0, 0)
    print("Opponent remaining HP:", arena.attack("blue", "first"))
