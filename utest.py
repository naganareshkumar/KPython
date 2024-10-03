import unittest
from prime import isPrime
class TestPrime(unittest.TestCase):
   
    def test_2(self):
        isp = isPrime()
        self.assertTrue(isp.isPrimenumber(2))
    def test_3(self):
        isp = isPrime()
        self.assertTrue(isp.isPrimenumber(3))

if __name__ == '__main__':
    unittest.main()
