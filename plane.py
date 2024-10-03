# Python vector animation

from manim import *

class HomotopyExample(Scene):
    def construct(self):
        plane = NumberPlane()
        pi_creature = PiCreature(color = PINK)
        plane.add(pi_creature)

        def homotopy(x,y, z, t):
            norm = np.linalg.norm([x,y])
            tau = interpolate(5, -5, t) + norm/space_width
            alpha = sigmoid(tau)
            return [x,y + 0.5 *np.sin(2*np.pi*alpha), z]

        self.play(HomotopyAnimation(plane, homotopy,run_time=3))
        self.wait(2)
        matrix = np.array([[0,-1],[1,0]])
        self.play(ApplyMatrix(matrix, plane))
        self.wait(2)
    
