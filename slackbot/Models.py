#!/usr/bin/python

import datetime

from sqlalchemy import create_engine
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import sessionmaker

engine = create_engine('postgresql://pg_user:pg_pass@localhost:5432/postgres')
Base = declarative_base()

class Location(Base):
  __tablename__ = 'locations'
  
  id = Column(Integer, primary_key=True)
  full_name = Column(String)

  users = relationship("User")

class User(Base):
  __tablename__ = 'users'

  id = Column(String, primary_key=True)
  full_name = Column(String)
  create_date = Column(DateTime)
  last_visit_date = Column(DateTime)

  location_id = Column(Integer, ForeignKey('locations.id'))
  location = relationship("Location", back_populates="users")

  def __repr__(self):
    name = self.full_name
    loc = (self.location.full_name if self.location is not None else "no location")
    cd = self.create_date
    lvd = self.last_visit_date
     
    return "{n} ({l})".format(n=name, l=loc)

if __name__ == '__main__':
  Session = sessionmaker(bind=engine)
  session = Session()

  current_time = datetime.datetime.utcnow()
  hour_ago = current_time - datetime.timedelta(hours=1)

  for user in session.query(User).filter(User.create_date > hour_ago).all():
    print user


