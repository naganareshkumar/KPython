"""
New handout! Hi all, this is a brand new handout to explain a concept that CS106A students often find difficult. If you find something confusing about this handout please ask on Ed. You will help us make the handout better!
In this handout we are going to go on a little adventure together. Its going to have three phases. Part I: We will start with a few observations of some strange phenomena in code.
Part II: We will formalize the pattern to gain a practical understanding, as well as common coding-patterns to solve related bugs.
Part III: We will take this chance to learn the theory of precisely what is going on under the hood in Python -- often considered an advanced topic, but one that you are ready for!

Erratum, Oct 9th: based on a great question on Ed we updated the wording on The Re-Binding Rule and added examples to Binding in parameters and Binding in for each loops.

Part I: Motivating examples!
First-time programmers bump into a need for a deeper understanding of what is actually going on under the hood when observing that in some for loops, and in some helper functions, changes to variables sometimes persist and sometimes do not! Lets first look at a few programs to build up this mystery:

Can you predict what each example prints? If not than read on to get your deep understanding.

Example 1: What will this print?

def main():
    x = [1, 2, 3]
    y = x
    # does this change impact x?
    y.append(4)
    print(x)
Output:
[1, 2, 3, 4]
Yes! Notice how the change to y does impact the value of x.
Example 2: Now lets swap the third line for a different way of changing the variable y:

def main():
    x = [1, 2, 3]
    y = x
    # does this change impact x?
    y = []
    print(x)
Output:
[1, 2, 3]
No! Notice how the change to y does not impact the value of x. Why is this different than example 1?
That single line change led to a very different result. How come one way of changing y affected x, but the other way did not? When students don't understand the difference between these two types of changes it makes it very hard to predict what for loops or functions with parameters will do.

Here are more examples of the same phenomena in other contexts. Our goal is to get you to the point where you can predict the output for each of these examples. Feel free to explore! When you are ready read part II to start mastering the different ways of changing variables.

 def main():
    my_list = [1, 2, 3]
    for value in original_list:
        # will this change impact my_list?
        value += 5
    print(my_list)
Output:
[1, 2, 3]
Here the change to value in the for loop body does not affect my_list.
Part II: Simple Rules to Explain the Pattern
The key concept to get your head around to make these predictions is between two ways of "changing" a variable: binding and mutation.

Binding
Until recently, the only way we knew how to change a variable was through a process called "binding" which some folks (including the Python reader) refer to as "assignment" or "reassignment". Binding attaches the variable name to a new value! Binding is easy to recognize. It is the process that you are using anytime you have a variable name immediately followed by an equal sign. Here are a few examples

# binding example 1
# We bind the name "x" in this function to the value 5
x = 5

# binding example 2
# Here we bind the name my_image to a new image.
my_image = SimpleImage("dog.png")

# binding example 3
x += 5 # recall this is the same as x = x + 5, still binding.

# binding example 4 
# we bind y to the same value that x is bound to
y = x
Notice how every example fits the pattern var = expression. That is the binding pattern.

Mutation
Some variables can be changed either via binding, or through a different process called mutation. Mutation doesn't attach the variable name to a new value as in binding. Instead we are going to be modifying the value that the variable is already attached to. Here are a few examples


# mutation example 1. 
# We are modifying the list that my_list is bound to.
my_list.append(4)

# mutation example 2. 
# Again, we are modifying the existing list.
my_list[0] = 9

# mutation example 3. 
# We are modifying the pixel's sub-part
my_pixel.red = 0
You need to keep these two processes separate! Mutations might look similar to the untrained-eye, but there is a big difference between binding your variable name to a new value, and modifying the value that its already bound to. Want to go deeper? The adventure continues!

Re-binding changes do not affect the original
There is a simple rule to help you predict if a change will persist:

The Re-Binding Rule: If you bind two variable names to the same value, future binding changes of one variable will not affect the other. Future mutation changes will.
Re-binding rule example

def main():
    x = [1, 2, 3]

    # now, two variables are bound to the same value
    y = x

    # this mutation change will impact both x and y
    # as they are bound to the same list
    y[0] = 0

    # this re-binding will not affect x. 
    # x and y are no longer bound to the same value
    y = []

    # this mutation will not affect x. 
    # since x and y are no longer bound to the same value
    y.append(6)

    print('x', x)
    print('y', y)
Output:
x [0, 2, 3]
y [6]
Are you curious to see exactly what this looks like in memory? Did you have trouble following what happened? In part III we visualize memory for this exact example step-by-step!

In both helper-functions and for-each loops, you are already accessing your value through a bound copy (parameters, or the variable name in the for-each loop). In the next two sections we explore how binding vs mutations predict if a change will persist in these contexts:

Binding in parameters
Python creates parameters by binding the parameter name to the value passed in

# parameters are passed via binding
def main():
    original = [1, 2, 3]
    do_your_thing(original)
    print('original', original)

# when this function is called, the param_name in do_your_thing
# is "bound" to the same value as original.
def do_your_thing(param_name):
    # mutation change impacts both original and param_name
    param_name.append(4)

    # re-binding will not impact original
    param_name = []

    # param_name and original are no longer bound to the same value
    # so this mutation does not impact the variable "original"
    param_name.append(5)
Output:
original [1, 2, 3, 4]
Binding in for-each loops
When executing a for-each loop, python binds your iterator name to each of the values being looped over.

# for each loops work by binding 
def main():
    x = [5, 6, 7]
    # here "value" is "bound" to each of 5, 6, and 7
    for value in x:
        # any re-binding will not affect the value in the list
        value = value + 5
        # any mutation would affect the value in the list
        # but note that here value is a number, which is immutable
Mutation changes will still impact the underlying value:

def main():
    my_image = SimpleImage("dog.png")
    for pixel in my_image:
        # this is a mutation! The original pixel is changed.
        pixel.red = 0
    my_image.show()
Immutable types
Some variable types, such as numbers, are immutable which means you can only change them via binding (you can't mutate them). How can you modify these variables in a helper-function or a for loop? Variable types that are immutable include: int, float, string, tuples.

Revisit examples
At this point we suggest you revisit the examples in Part I. For every example, (1) try to recognize when two variable names are bound to the same value then (2) look at the line where a change is being made. Ask yourself, is this "re-binding" or "mutation". If the answer is re-binding, the change will not impact the original variable's value. If it is mutation, the change will impact both!

x = change(x) for persistent binding
If a helper function wants to change a variable via binding how can we make that change impact a variable in the original function? How would you modify this so that the change in the helper function (add_five) persists?
def main():
    x = 0
    add_five(x)
    print(x)

# when this is called the name x in add_five is bound 
# to the same value as x in main.
def add_five(x):
    # this re-binding has no impact on the x in main
    x += 5
Note that x is an integer, which is an immutable type. That means the only way you can change it is via binding. But re-binding won't change the value of the other x. Is all hope lost? No! We can use the x = change(x) pattern. In this case add_five is our function which is changing x. This pattern is the general solution to the problem "my helper function wants to make a persistent change via binding" Here we fix the code:
def main():
    x = 0
    # here is where x = change(x) pattern gets its name
    x = add_five(x)
    print(x)

def add_five(x):
    x += 5
    return x
Now your turn. How would you modify this example using the x = change(x) paradigm so that the modification to x in add_five impacts the variable x in main?
def main():
    x = [1, 2, 3]
    add_five(x)
    print(x)

def add_five(x):
    # we want this change to impact the x variable in main.
    x = [1, 2, 3, 5]
Persistent binding changes in for loops
Notice how example 2 is the fix to the problem in example 1. If you have a for loop, and your re-binding changes are not persisting, often the best solution is to change your for loop to be a loop over indices not values (ie for i in range(len(my_list)):). This way the line in the body is changing the list via mutation, not changing the name of the for-each variable via binding.

How would you modify this example using a loop over indices?

def main():
    x = [1, 2, 3]
    # value gets bound to the values 1, 2 then 3
    for value in x:
        # this re-binding has no persistent impact
        value += 5
Part III: Memory model theory
Binding vs mutation are concepts that you can understand in a much deeper way once you combine this new insight with a "memory model". In a memory model you keep track of each function call and each variable. Each variable is a name, that lives within a function's memory. It is associated with a value that lives in a place called the "heap". During binding, a variable is attached to a new value. During mutation the value the variable is attached to is changed.

Memory diagram of re-binding
Step through this animation to visualize the difference between binding and mutation. When two variable names are bound to the same value, mutation of one impacts the other. Re-binding ends the "sharing".


Memory diagram with parameters
Step through this animation to visualize the difference between binding and mutation. Note how when add_five is called, the parameter is bound to the value which is passed in. The mutation change (append) impacts the value the parameter is bound to.
"""


# for each loops work by binding 
def main():
    x = [5, 6, 7]
    # here "value" is "bound" to each of 5, 6, and 7
    for value in x:
        # any re-binding will not affect the value in the list
        value = value + 5
        # any mutation would affect the value in the list
        # but note that here value is a number, which is immutable
        # value.append(5)

    print(x)



if __name__ == "__main__":
    main()
    
