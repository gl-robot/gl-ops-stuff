#!/usr/bin/python

import datetime
import time
import subprocess

from Models import engine, BookInfo
from sqlalchemy.orm import sessionmaker
from urllib import urlretrieve
from uuid import uuid4
from resizer import save_thumbnail

Session = sessionmaker(bind=engine)
session = Session()

def is_url(str_):
  return str_.startswith("http")

def get_books_with_google_images():
  books_with_google_images = session.query(BookInfo).filter(BookInfo.image_path.like("http%"))
  return books_with_google_images

def save_image_by_url(url, directory):
  image_name = "{0}.jpg".format(uuid4())
  urlretrieve(url, "{0}/{1}".format(directory, image_name))
  return image_name

if __name__ == "__main__":

  directory = "/srv/images"
  for book in get_books_with_google_images():
    new_image_path = save_image_by_url(book.image_path, directory)
    save_thumbnail(new_image_path, directory)
    book.image_path = new_image_path

  session.commit()
      

