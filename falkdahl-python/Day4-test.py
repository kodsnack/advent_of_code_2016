import unittest, Day4

class TestDay4(unittest.TestCase):

    def testRealRooms(self):
        self.assertTrue(Day4.isRealRoom('aaaaa-bbb-z-y-x-123[abxyz]'))
        self.assertTrue(Day4.isRealRoom('a-b-c-d-e-f-g-h-987[abcde]'))
        self.assertTrue(Day4.isRealRoom('not-a-real-room-404[oarel]'))

    def testFakeRooms(self):
        self.assertFalse(Day4.isRealRoom('totally-real-room-200[decoy]'))

if __name__ == '__main__':
    unittest.main()
