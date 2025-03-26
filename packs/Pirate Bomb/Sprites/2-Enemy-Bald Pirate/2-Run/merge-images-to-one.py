# https://stackoverflow.com/questions/30227466/combine-several-images-horizontally-with-python

import sys
from PIL import Image

from os import listdir
from os.path import isfile, join

files = [f for f in listdir(".") if isfile(join(".", f)) and f.split('.')[-1] != 'py']

images = [Image.open(x) for x in files]
widths, heights = zip(*(i.size for i in images))

total_width = sum(widths)
max_height = max(heights)

new_im = Image.new('RGBA', (total_width, max_height))

x_offset = 0
for im in images:
  new_im.paste(im, (x_offset,0))
  x_offset += im.size[0]

new_im.save('test1.png')

"""
for elem in list_im:
  for i in xrange(0,444,95):
    im=Image.open(elem)
    new_im.paste(im, (i,0))
  new_im.save('new_' + elem + '.jpg')
  """