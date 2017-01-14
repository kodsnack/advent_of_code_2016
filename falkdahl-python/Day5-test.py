import unittest, Day5


class TestDay5(unittest.TestCase):

    def test1(self):
        self.assertTrue(Day5.generate_password('abc') == '18f47a30')

if __name__ == '__main__':
    unittest.main()
