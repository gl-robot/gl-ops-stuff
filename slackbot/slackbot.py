#!/usr/bin/python

import datetime
import time
import subprocess

from Models import engine, User, Location
from slackclient import SlackClient
from sqlalchemy.orm import sessionmaker

def get_info():
  Session = sessionmaker(bind=engine)
  session = Session()

  current_time = datetime.datetime.utcnow()
  hour_ago = current_time - datetime.timedelta(hours=1)

  new_users = session.query(User).filter(User.create_date > hour_ago).all()
  last_visitors = session.query(User).filter(User.last_visit_date > hour_ago).all()
  
  return (new_users, last_visitors)

def post_stat(channel_, text_, sc):
  sc.api_call(
      "chat.postMessage", channel=channel_, text=text_,
      username='bot', icon_emoji=':robot_face:')

if __name__ == "__main__":
  
  token = "secret"
  sc = SlackClient(token)
  
  new_users, last_visitors = get_info()
  
  new_users_str = ""
  for user in new_users:
    new_users_str = "\n".join([new_users_str, str(user)])

  last_visitors_str = ""  
  for visitor in last_visitors:
    last_visitors_str = "\n".join([last_visitors_str, str(visitor)])

  msg = "```New users in last hour: \n {nu} \n\n\nVisitors in last hour: \n {v} \n ```".format(nu=new_users_str, v=last_visitors_str)
  
  if len(new_users) + len(last_visitors) == 0:              
    print "No new users"
  else:
    print sc.api_call(
      "chat.postMessage", channel="#gridlibrary", text=msg,
      username='Grid Library Robot', icon_emoji=':robot_face:')


