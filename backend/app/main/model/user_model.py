from app.main import db 
from .vendor_model import Vendor 

class User(db.Document):
    username = db.StringField(required=True)
    fav_trucks = db.ListField(db.LazyReferenceField(Vendor))