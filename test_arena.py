import unittest
from arena import Robot, take_turn


class ArenaTests(unittest.TestCase):
    def test_strike(self):
        a, b = Robot("A"), Robot("B")
        take_turn(a, b, "strike")
        self.assertEqual(b.health, 88)
        self.assertEqual(a.energy, 25)

    def test_shield_blocks_damage(self):
        a, b = Robot("A"), Robot("B")
        take_turn(b, a, "defend")
        take_turn(b, a, "strike")
        self.assertEqual(a.health, 88)
        self.assertEqual(a.shield, 0)

    def test_invalid_action(self):
        with self.assertRaises(ValueError):
            take_turn(Robot("A"), Robot("B"), "teleport")


if __name__ == "__main__":
    unittest.main()
