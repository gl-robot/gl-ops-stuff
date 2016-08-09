from os import listdir
from resizeimage import resizeimage
import Image

# directory = "/home/aarutyunyan/imgs/images/"
# image_names = listdir(directory)
# print image_names

WIDTH = 250 

def save_thumbnail(image_name, directory):
  im = Image.open("".join([directory,  image_name]))
  if im.size[0] > WIDTH:
    im.thumbnail((WIDTH, WIDTH))
  im.save("{0}/thumbnail_{1}".format(directory, image_name), im.format)

