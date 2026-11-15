import unittest
from core import Arena


class CombatTests(unittest.TestCase):
    def test_attack_cooldown_and_duplicate_events(self):
        arena = Arena()
        with self.assertRaises(ValueError):
            arena.attack("blue", "too-far")
        arena.move("blue", 1, 0)
        self.assertEqual(arena.attack("blue", "one"), 75)
        with self.assertRaises(ValueError):
            arena.attack("blue", "one")
        with self.assertRaises(ValueError):
            arena.attack("blue", "two")
        for _ in range(5):
            arena.advance(.1)
        self.assertEqual(arena.attack("blue", "two"), 50)

    def test_winner_and_restart(self):
        game = Arena()
        game.move("blue", 1, 0)
        for i in range(4):
            if i:
                for _ in range(5):
                    game.advance(.1)
            game.attack("blue", f"hit-{i}")
        self.assertEqual(game.winner, "blue")
        self.assertEqual(game.robots["red"].hp, 0)
        with self.assertRaises(ValueError):
            game.attack("red", "late")
        game.reset()
        self.assertEqual(game.robots["red"].hp, 100)

    def test_bounds_and_invalid_dt(self):
        game = Arena()
        with self.assertRaises(ValueError):
            game.move("red", 100, 0)
        with self.assertRaises(ValueError):
            game.advance(float("nan"))
        self.assertEqual(game.time, 0)

    def test_same_input_same_result(self):
        first, second = Arena(), Arena()
        for game in (first, second):
            game.move("blue", 1, 0)
            game.attack("blue", "a")
            game.advance(.1)
        self.assertEqual(first.robots, second.robots)


if __name__ == "__main__":
    unittest.main()
