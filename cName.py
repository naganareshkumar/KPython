endOfProgram = False
while not endOfProgram:
    name = input("name:")
    if len(name) < 2:
        endOfProgram = True
        continue
    else:
        age = int(input("Age:"))
        if age > 15:
            children = int(input("# of children"))
            if (children > 0):
                for c in range(children):
                    cName = input("childrenName")
            else:
                mother = input("Mother name: ")

print("END")
