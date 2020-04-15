from app.main import db 

class Location(db.EmbeddedDocument):
    lat = db.FloatField(required=True)
    lng = db.FloatField(required=True)
    location_name = db.StringField(default="")

class Schedule(db.EmbeddedDocument):
    start = db.DateTimeField(required=True)
    end = db.DateTimeField(required=True)

class Vendor(db.Document):
    username = db.StringField(required=True, unique=True)
    displayed_name = db.StringField(required=True, unique=True)
    location = db.EmbeddedDocumentField(Location)
    schedule = db.EmbeddedDocumentField(Schedule)
    description = db.StringField()
    tags = db.ListField(db.StringField())

    meta = {'indexes': [
        {'fields': ['$displayed_name', "$description"],
         'default_language': 'english',
         'weights': {'displayed_name': 10, 'description': 2}
        }
    ]}