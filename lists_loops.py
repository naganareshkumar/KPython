# List and Loop
# Function prints the students from hogwarts function.
def main():
    students = [
        {"name" : "naresh", "marks":"40", "grade":"F"},
        {"name" : "naresh", "marks":"40", "grade":"F"},
        {"name" : "naresh", "marks":"40", "grade":"F"}
        ]
    i=1
    for student in students:
        print(i ,student["name"],student["marks"],student["grade"],sep=",")
        i+=1


main()
