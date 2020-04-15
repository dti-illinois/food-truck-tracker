from app.main import db 
import datetime

class VendorTags():
    tags = ["Savory", "Sweet", "Vegetarian", "Free"]

class Location(db.EmbeddedDocument):
    lat = db.FloatField(required=True, default=0)
    lng = db.FloatField(required=True, default=0)
    location_name = db.StringField(default="")

class Schedule(db.EmbeddedDocument):
    start = db.DateTimeField(required=True, default=datetime.datetime.now)
    end = db.DateTimeField(required=True, default=datetime.datetime.now)

class Vendor(db.Document):
    username = db.StringField(required=True, unique=True)
    displayed_name = db.StringField(required=True, unique=True)
    location = db.EmbeddedDocumentField(Location)
    schedule = db.EmbeddedDocumentField(Schedule)
    description = db.StringField()
    tags = db.ListField(db.StringField(choices=VendorTags.tags))

    meta = {'indexes': [
        {'fields': ['$displayed_name', "$description"],
         'default_language': 'english',
         'weights': {'displayed_name': 10, 'description': 2}
        }
    ]}
