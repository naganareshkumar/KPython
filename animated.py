import sys

from PIL import image

images = []

for arg in sys.argv[1:]:
    image = image.open(arg)
    images.append(image)

images[0].save(
    "1.png", save_all=True, append_images = [images[1]], duration =200,top =0
    )
