import pygame
from pygame.locals import *
from PIL import Image, ImageOps
import os
import random

# Initialize pygame
pygame.init()

# Increased window size
window_width = 1200  # Increased width
window_height = 800  # Adjusted height

# Load the world map
world_map = Image.open('world_map.jpg')

# Ask user if they want to replace the company logo
replace_logo = input("Do you want to replace the company logo? (yes/no): ").strip().lower()

if replace_logo == 'yes':
    new_logo_path = input("Enter the path to the new logo image: ").strip()
    if os.path.exists(new_logo_path):
        company_logo = Image.open(new_logo_path)
    else:
        print("The specified logo file does not exist. Using default logo.")
        company_logo = Image.open('company_logo.png')
else:
    company_logo = Image.open('company_logo.png')

# Resize the world map to fit the window while maintaining aspect ratio
world_map.thumbnail((window_width, window_height), Image.Resampling.LANCZOS)
map_width, map_height = world_map.size

# Resize the company logo to match a puzzle piece size
piece_size = (map_width // 4, map_height // 4)
company_logo = company_logo.resize(piece_size)

# Cut the world map into pieces
pieces = []
original_positions = []

for i in range(4):
    for j in range(4):
        piece = world_map.crop((j*piece_size[0], i*piece_size[1], (j+1)*piece_size[0], (i+1)*piece_size[1]))
        pieces.append(piece)
        original_positions.append((j*piece_size[0], i*piece_size[1]))

# Add the company logo as an extra piece
pieces.append(company_logo)
original_positions.append((random.randint(0, map_width - piece_size[0]), random.randint(0, map_height - piece_size[1])))

# Randomize the pieces and their initial positions
random.shuffle(pieces)
piece_positions = [(random.randint(0, map_width - piece_size[0]), random.randint(0, map_height - piece_size[1])) for _ in range(len(pieces))]

# Create a Pygame window with increased width
screen = pygame.display.set_mode((map_width, map_height))
pygame.display.set_caption('Interactive World Map Jigsaw Puzzle')

# Convert pieces to pygame surfaces
pieces_surfaces = [pygame.image.fromstring(piece.tobytes(), piece.size, piece.mode) for piece in pieces]

# Variables to track dragging
dragging_piece = None
offset_x = 0
offset_y = 0

# Main game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == QUIT:
            running = False
        elif event.type == MOUSEBUTTONDOWN:
            # Start dragging a piece
            mouse_x, mouse_y = event.pos
            for i, (x, y) in enumerate(piece_positions):
                if x <= mouse_x <= x + piece_size[0] and y <= mouse_y <= y + piece_size[1]:
                    dragging_piece = i
                    offset_x = mouse_x - x
                    offset_y = mouse_y - y
                    break
        elif event.type == MOUSEBUTTONUP:
            # Stop dragging
            dragging_piece = None
        elif event.type == MOUSEMOTION:
            if dragging_piece is not None:
                # Update the position of the piece being dragged
                mouse_x, mouse_y = event.pos
                piece_positions[dragging_piece] = (mouse_x - offset_x, mouse_y - offset_y)

                # Snap piece into position if close enough
                target_x, target_y = original_positions[dragging_piece]
                if abs(piece_positions[dragging_piece][0] - target_x) < 10 and abs(piece_positions[dragging_piece][1] - target_y) < 10:
                    piece_positions[dragging_piece] = (target_x, target_y)

    # Clear the screen
    screen.fill((255, 255, 255))

    # Draw all the pieces
    for i, (x, y) in enumerate(piece_positions):
        screen.blit(pieces_surfaces[i], (x, y))

    pygame.display.flip()

pygame.quit()
