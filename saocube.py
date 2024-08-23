# This method calculate Surface area of cube,
# given edge length in float and returns string

"""
def surface_A_O_Cube(elength: float) -> str:
    return f"The surface area of the code is {6 * elength **2}"

def main():
    print(surface_A_O_Cube(4.0))

if __name__ == "__main__":
    main()

"""

# This method calculates the scalar product of Vector
# given as list of float values.
Vector = list[float]

def scale(scalar: float, vector: Vector) -> Vector:
    return [scalar * num for num in vector]

nVector = scale(2.0, [1.0, -4.2, 5.4])

print(nVector)

