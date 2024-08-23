# list comprehensions, list of dictionaries.
# yield operator:

def main():
    n = int(input("enter number"))
    for s in sheep(n):
        print(s)

def sheep(n):
    for i in range(n):
        yield "s" * i


if __name__ == "__main__":
    main()
