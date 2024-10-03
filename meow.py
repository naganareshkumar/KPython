# mypy
"""
pip install mypy

String with Multiplication operator and number is operator overloading

class Cat:
    MEOWS = 3

    def meow(self):
        for _ in range(Cat.MEOWS):
            print("Meow")


cat = Cat()
cat.meow()




def meow(n: int) -> str:
    
    # Meow n times.
    # : param n: number of times to meow
    # type error
   # return "\nmeow"*n

number: int = int(input("NUmber: "))
meows: str = meow(number)
print(meows)



"""

import argparse

parser = argparse.ArgumentParser(description = "Meow like a cat")
parser.add_argument("-n", default =1 , help = "number of times to meow",type = int)
args = parser.parse_args()

for _ in range(int(args.n)):
    print("meow")



