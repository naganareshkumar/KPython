# Find the second lowest of scores and print name in alphabetical order 


if __name__ == '__main__':
    students = []

    # Read number of students
    for _ in range(int(input("Enter the number of students: "))):
        name = input("Enter the student's name: ")
        score = float(input("Enter the student's grade: "))
        students.append([name, score])

    # Extract all unique grades
    grades = sorted(set(student[1] for student in students))

    # Find the second lowest grade
    second_lowest_grade = grades[1]

    # Find students with the second lowest grade
    second_lowest_students = [student[0] for student in students if student[1] == second_lowest_grade]

    # Sort the names alphabetically
    second_lowest_students.sort()

    # Print the names
    for student in second_lowest_students:
        print(student)
