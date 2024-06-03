# function define array with specified capacity, initialised with zero
""" 1. Initialize the array with a specified capacity
    2. Ensures the capacity is greater than 0
    3. Sets the initial size to 0 and creates an internal array with the given
    capacity"""
class DynamicArray:
    def __init__(self, capacity):
        if capacity <= 0:
            raise ValueError("capacity must be greater than 0")
        self.capacity = capacity
        self.size = 0
        self.array = [0]*capacity
# return array from specified index, if index is not with in the range than raise error
    def get(self, index):
        if index < 0 or index >=self.size:
            raise IndexError("Index out of bounds")
        return self.array[index]

# Add or modify element if size in bound
    def set(self, i, n):
        if i < 0 or i >= self.size:
            raise IndexError("Index out of bounds")
        self.array[i] = n
        
#Pushing an element
    def pushback(self, n):
        if self.size == self.capacity:
            self.resize()
        self.array[self.size] = n
        self.size += 1
# delete element from array
    def popback(self):
        if self.size == 0:
            raise IndexError("pop from empty array")
        value = self.array[self.size - 1]
        self.size -= 1
        return value
# create new capacity and array, assign to older array
    def resize(self):
        new_capacity =self.capacity*2
        new_array = [0]*new_capacity
        for i in range(self.size):
            new_array[i] = self.array[i]
        self.array = new_array
        self.capacity = new_capacity

# return size of array
    def getSize(self):
        return self.size
# return capacity valu
    def getCapacity(self):
        return self.capacity

array = DynamicArray(1)

# get the size of Array
print(array.getSize())

# get size of capacity
print(array.getCapacity())

# insert an array
array.pushback(1)
print(array.getCapacity())
array.pushback(2)
print("," ,array.getCapacity())

# get the size of Array
print(array.getSize())
