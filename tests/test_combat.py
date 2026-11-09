import unittest
from combat import Robot

class CombatTests(unittest.TestCase):
    def test_attack_consumes_energy_and_damages_target(self):
        a, b = Robot("Alpha"), Robot("Beta")
        self.assertEqual(a.attack(b), 15)
        self.assertEqual(a.energy, 90)
        self.assertEqual(b.health, 85)

    def test_armor_reduces_damage(self):
        a, b = Robot("A"), Robot("B", armor=30)
        self.assertEqual(a.attack(b, 10), 1)

    def test_insufficient_energy_does_not_damage(self):
        a, b = Robot("A", energy=0), Robot("B")
        with self.assertRaises(ValueError):
            a.attack(b)
        self.assertEqual(b.health, 100)

    def test_recharge_caps_energy(self):
        a = Robot("A", energy=95)
        a.recharge()
        self.assertEqual(a.energy, 100)

    def test_destroyed_robot_cannot_attack(self):
        with self.assertRaises(ValueError):
            Robot("A", health=0).attack(Robot("B"))

if __name__ == "__main__":
    unittest.main()
