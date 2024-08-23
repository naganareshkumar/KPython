from turtle import Turtle, Screen

def draw_housing():
    """ Draw a nice housing to hold the traffic lights """
    tess.pensize(3)
    tess.color('black', 'darkgrey')

    tess.begin_fill()
    tess.forward(80)
    tess.left(90)
    tess.forward(200)
    tess.circle(40, 180)
    tess.forward(200)
    tess.end_fill()

wn = Screen()
wn.setup(400, 500)
wn.title("Tess becomes a traffic light!")
wn.bgcolor('lightgreen')

tess = Turtle()

draw_housing()

# Position tess onto the place where the green light should be
tess.penup()
tess.left(90)
tess.forward(40)
tess.left(90)
tess.forward(50)

# Turn tess into a green circle
tess.shape('circle')
tess.shapesize(3)
tess.fillcolor('green')

# A traffic light is a kind of state machine with three states,
# Green, Amber, Red.  We number these states  0, 1, 2
# When the machine changes state, we change tess' position and
# her fillcolor.

SLOW, STOP, GO = range(3)

# Y position, color, next state; 'orange' filling in for 'amber'
STATE_MACHINE = { \
    SLOW: (120, 'orange', STOP), \
    STOP: (190, 'red', GO), \
    GO: (50, 'green', SLOW) \
}

# This variable holds the current state of the machine
state_num = SLOW

def advance_state_machine():
    global state_num

    position, color, next_state = STATE_MACHINE[state_num]

    tess.sety(position)
    tess.fillcolor(color)
    state_num = next_state

def bigger():
    stretch_wid, stretch_len, outline = tess.shapesize()
    tess.shapesize(stretch_wid, stretch_len, outline + 1)

def smaller():
    stretch_wid, stretch_len, outline = tess.shapesize()
    if outline > 0:
        tess.shapesize(stretch_wid, stretch_len, outline - 1)

def stop():
    global state_num
    state_num = STOP
    advance_state_machine()

def slow():
    global state_num
    state_num = SLOW
    advance_state_machine()

def go():
    global state_num
    state_num = GO
    advance_state_machine()

# Bind the event handlers
wn.onkey(advance_state_machine, 'space')
wn.onkey(stop, 'r')  # press 'r' key to change the light to red
wn.onkey(slow, 'y')  # press 'y' key to change the light to yellow
wn.onkey(go, 'g')  # press 'g' key to change the light to green
wn.onkey(bigger, 'plus')  # press '+' key to increase the circle size
wn.onkey(smaller, 'minus')  # press '-' key to decrease the circle size.

wn.listen()  # Listen for events

wn.mainloop()
