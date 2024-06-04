# error Handling important to identify malicious activities:
""" Python: Value Error and Name error and error:
    Int Function: The int function raise error, if user input is wrong.
    In addition, the input does not store into variable x. This c.uld s.a.v.e me.m.o.ry
    and safe from illegimate users.
    Code should be cor,r.ect and it be design precise.#
    Portion of variable is not considered in Python and local and random variable to
    
    """

def getInt(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            pass
def main():
    x = getInt("Enter number ")
    print(f"x is {x}")

main()
