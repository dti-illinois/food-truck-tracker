from app.main import db 

class Location(db.EmbeddedDocument):
    lat = db.FloatField(required=True)
    lng = db.FloatField(required=True)

class Schedule(db.EmbeddedDocument):
    start = db.DateTimeField(required=True)
    end = db.DateTimeField(required=True)

class Vendor(db.Document):
    username = db.StringField(required=True)
    displayed_name = db.StringField(required=True, unique=True)
    location = db.EmbeddedDocumentField(Location)
    schedule = db.EmbeddedDocumentField(Schedule)
