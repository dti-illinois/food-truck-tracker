from app.main import db
import datetime

class VendorTags():
    tags = ["Savory", "Sweet", "Vegetarian", "Free"]

class TimeFormat():
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

class Location(db.EmbeddedDocument):
    lat = db.FloatField(required=True, default=0)
    lng = db.FloatField(required=True, default=0)
    location_name = db.StringField(default="")

class Schedule(db.EmbeddedDocument):
    start = db.DateTimeField(required=True, default=datetime.datetime.now)
    end = db.DateTimeField(required=True, default=datetime.datetime.now)

class CalendarItem(db.EmbeddedDocument):
    start = db.DateTimeField(required=True, default=datetime.datetime.now)
    end = db.DateTimeField(required=True, default=datetime.datetime.now)
    week_day = db.StringField(choices=TimeFormat.days)
    location = db.EmbeddedDocumentField(Location)

class Rating(db.EmbeddedDocument):
    rateId = db.StringField()
    rate_val = db.FloatField(min_value=0.0, max_value=5.0)

class Vendor(db.Document):
    username = db.StringField(required=True, unique=True)
    displayed_name = db.StringField(required=True, unique=True)
    location = db.EmbeddedDocumentField(Location)
    schedule = db.EmbeddedDocumentField(Schedule)
    description = db.StringField()
    tags = db.ListField(db.StringField(choices=VendorTags.tags))
    weekly_schedule = db.ListField(db.EmbeddedDocumentField(CalendarItem))
    # is_open = db.BooleanField(default=False)

    user_rate = db.EmbeddedDocumentListField(Rating)
    overall_rate =  db.FloatField(default = 0)
    avg_rate = db.FloatField(default = 0)
    rateCount = db.IntField(default = 0)

    meta = {'indexes': [
        {'fields': ['$displayed_name', "$description"],
         'default_language': 'english',
         'weights': {'displayed_name': 10, 'description': 2}
        }
    ]}
