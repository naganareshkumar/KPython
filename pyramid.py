def getInt(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            pass
def main():
    x = getInt("Enter number ")
    pyramid(x)

def pyramid(n):
    for i in range(n):
        print("#" * (i+1))

if __name__ == "__main__":
    main()
